# Unit 2: 进程同步 | Process Synchronization [未完成]

!!! info "引入"

    > 首先我们**简单**描述什么是同步问题，读者可以抱着对下面这段话的疑问去阅读接下来的内容。
    >
    > 不必尝试立刻理解这段话，我希望读者能够在看的过程中以下面这段话为主线，猜测接下来将要展开的内容，去发现问题、思考解决办法。

    在支持并发甚至并行的系统中，虽然进程之间相对隔离，在一般情况下互不**直接**干扰，自顾自跑——即是异步的；但它们可能会在一段时间里操作同一份计算机资源，此时由于**各种原因**，进程之间的执行需要互相制约，因此进程需要通过**某些手段**，让协作进程能够直接或间接了解到其它相关进程的状态，以实现对当前进程执行的控制，最终在宏观上实现同步控制。

    而上面提到的“**各种原因**”和“**某些手段**”，就是我们稍后将讨论的东西。

    需要注意的是，同步并不是某种中央调控机制，而更像是一种“协议”，当各个进程发现有别的进程与自己产生竞争时，应当有某种手段允许它们达成协商，以决定谁先谁后。
    
    我们按照问题的复杂程度，由浅入深地讨论这些东西。

!!! warning "语境问题"

    一个比较尴尬的问题是，书本上以协作进程的语境为开篇，但接下来讲的有些内容是以线程同步为语境（主要体现在使用全局变量来作为“锁”的实现，虽然或许可以**迁移**但是多少有些奇怪），如果在用词上都区分线程和进程，那么会变得很繁杂，所以我接下来一律用进程表示，但读者心中应当对这个语境更适于线程还是进程有所感受。
    
    关于这些方法更适合在 process 还是 thread 上被应用，可以看[这个](https://stackoverflow.com/a/4623428/22331129){target="_blank"}。

## 竞态条件

!!! quote "Links"

    - [Race Condition | Wikipedia](https://en.wikipedia.org/wiki/Race_condition){target="_blank"}

我们需要意识到，我们无法一步到位地、in-place 地去修改一个内存中的数据，换言之，要想修改 `mem[x]`，我们需要三个步骤：

1. `reg` <- `mem[x]`；
2. `reg` <- update(`reg`)；
3. `mem[x]` <- `reg`；

而如果现在不止一个进程在修改 `mem[x]`，例如下面这个例子：

```linenums="1"
┌──────────────┬──────────────┐
│ process A    │ process B    │ mem[x] = 1 (initial)
├──────────────┼──────────────┤
│ t0 <- mem[x] │ t0 <- mem[x] │ mem[x] = 1
│ t0 <- t0 + 1 │ t0 <- t0 + 1 │
│ mem[x] <- t0 │ t0 <- t0 + 1 │ mem[x] = 2, B's t0 is out of date
│              │ mem[x] <- t0 │ mem[x] = 3, 2 is overwritten
└──────────────┴──────────────┘
```

它们都想要更新 `mem[x]`，又好巧不巧的它们几乎同时发生读取了 `mem[x]`，那么就会出现问题：两个进程同时读取 `mem[x]`，然后各自计算更新后的值，然后各自写回 `mem[x]`，理想情况下，最终的 `mem[x]` 会比原来大 3，但现在的 `mem[x]` 只比原来大 2，其中 process A 对它的修改在第 7 行被覆盖了。

究其根本，由于如今我们处在并发语境下，所以会出现若干用户同时持有一份数据资源的情况（为了发挥并发的优势，我们也应当尽可能的满足这种需求），逻辑上数据修改过程应当是符号的、瞬间的、立即生效的，但实际上我们对数据的操作是数值的、需要一段时间来完成的。在这种（后者）语境下，<u>如果我们无法保证读入数值完成到写入数值完成的过程中，`mem[x]` 保持不变</u>，那么该操作实际上是使用过时数据进行计算。

```linenums="1" hl_lines="6"
┌──────────────┬──────────────┐
│ process A    │ process B    │ mem[x] = 1 (initial)
├──────────────┼──────────────┤
│ t0 <- mem[x] │ t0 <- mem[x] │ mem[x] = 1
│ t0 <- t0 + 1 │ t0 <- t0 + 1 │
│ mem[x] <- t0 │ t0 <- t0 + 1 │ mem[x] = 2, B's t0 is out of date
│              │ mem[x] <- t0 │ mem[x] = 3, 2 is overwritten
└──────────────┴──────────────┘
```

可以发现，第六行的 `t0` 仍然在用更新之前的 `mem[x]` 做计算，因而可以认为此时 process B 中的 `t0` 参与运算的、暗含的 `mem[x]` 的数据已经**过时**。

!!! definition "race condition"
    
    类似这种的，由两个信号产生竞争，其竞争情况影响最终结果的情况，被称为**竞态条件(race condition)**。在上面这个例子中，谁后执行，最终结果就是谁的输出，而另一个用户的输出则会被覆盖。

    需要注意的是，这里的重点并不是“如何控制竞争结果”，因为无论竞争结果如何（甚至谁赢了结果可能都一样），只要这种“竞争”出现，那么最终结果就有可能不符合预期的。 真正的重点应该是如何**避免这种竞争**的出现。
    
    就比如上面的例子，无论最终 `mem[x]` 是 3 还是 2 都不对，理想情况下应该是 4——无论是先进行 `+1` 还是先进行 `+2`。

!!! warning "注意"

    虽然上面的例子中我们模拟的两个程序是按照相同速度，一行一个指令执行的，但是我们在并行语境下对所有进程执行的速度不应当有所假设，即进程 A 不知道进程 B 的速度。

    不仅如此，我们也并不一定要在并行语境下讨论这个问题，在多道语境下这个问题都会出现，例如：

    ```linenums="1"
    ┌──────────────┐     ┌──────────────┐
    │ process A    │     │ process B    │ mem[x] = 1 (initial)
    ├──────────────┤     ├──────────────┤
    │              │     │ t0 <- mem[x] │ mem[x] = 1
    │ t0 <- mem[x] │◄────┤ <ctx switch> │ mem[x] = 1
    │ t0 <- t0 + 1 │     │              │
    │ mem[x] <- t0 │     │              │ mem[x] = 2, B's t0 is out of date
    │ <ctx switch> ├────►│ t0 <- t0 + 1 │
    │              │     │ t0 <- t0 + 1 │ 
    │              │     │ mem[x] <- t0 │ mem[x] = 3, 2 is overwritten
    └──────────────┘     └──────────────┘
    ```

    问题依旧。

根据上面这个具体的例子，我们发现，如果需要解决这个问题，我们有两种选择：

1. 进行符号的运算而非数值的运算，这样输入的变化能在任意时刻反映在输出上，这样时时刻刻都是“最新”，而不会出现“过时”；
2. 保证读入数值完成到写入数值完成的过程中，`mem[x]` 保持不变，即两个可能竞争的操作，在时间上不应该有交集；

显然，我们应当选择第二种。

## The Critical-Section Problem

为了更好地展开，我们对上面的这种情况进行建模，并给出解决 race condition 问题的方法需要满足的范式：

我们应当保证在一个进程在修改 `mem[x]` 的时候，其它进程不应该读取 `mem[x]`（至少不应以修改 `mem[x]` 为目的来读取），直到这个进程完成了对 `mem[x]` 的修改。换句话来说，`mem[x]` 这个共享资源应当只能被一个用户持有，我们称这种只能被至多一个用户占有的资源为临界资源。而程序中访问临界资源的代码段，我们称之为**临界区段(critical section, CS)[🔗](https://en.wikipedia.org/wiki/Critical_section){target="_blank"}**。

那么，对于之前提到过的例子，我们拿出来对比模拟的部分就是 critical section。

而 CS 问题，指的就是<u>如何保证最多只有一个用户在执行临界区段的代码</u>[^1]。

---

围绕临界区段，我们定义能够解决 CS 问题的代码应当能够做如下划分：

```
┌─────────────────────┐
│  Entry Section      │ <-- ask for & wait for permission to enter CS
├─────────────────────┤
│  Critical Section   │ <-- codes manipulating critical resources
├─────────────────────┤
│  Exit Section       │ <-- release the critical resources
├─────────────────────┤
│  Remainder Section  │ <-- other codes
└─────────────────────┘
```

进程需要在 entry section 判断是否能够进入 critical section，即申请持有临界资源，如果不行则等待；而在进入 critical section 后，进程需要在 exit section 释放临界资源；然后脱离 CS 问题的语境，进入 remainder section 继续执行。

!!! tip "Brainstorming"

    整个过程有点像[调度](./Unit1.md/#进程调度){target="_bank"}，等待申请临界资源的过程就好像 ready 态等待调度过程中的 CPU 资源（CPU 也可以认为是一种临界资源，只不过它不是由进程主动处理和申请的）。

    既然如此我们可以迁移“状态”这个概念。我们只关心直接与 CS 问题有关的状态，所以我在这里定义：就绪、临界、无关三个状态。

    1. 就绪态：进程随时准备好进入 critical section，<u>**想要**持有临界资源</u>；
    2. 临界态：进程正在执行 critical section，<u>**持有**临界资源</u>，或进程执行完 critical section，执行 exit section <u>正在释放**持有**的临界资源中</u>；
    3. 无关态：不处于就绪态也不处于临界态，不想要持有临界资源，或是使用完已经释放；

    根据我们先前给出的，解法[需要满足的性质](#r4s2csp){target="_blank"}中的 mutual exclusion，不能同时有多个进程处于临界态，但是可以有若干进程处于就绪态，而无关态则表示不会产生竞争，和调度过程十分相似。

    这些定义将会在我们之后的探索中起作用。

同时，我们要求解决方案需要满足如下性质：

<a id="r4s2csp"></a>
!!! definition "requirements for solution to CS problem"

    1. 临界互斥(mutual exclusion)：操作同一临界资源的临界区段应当互相排斥；
        - 如果进程 $P_i$ 正在执行其 critical section，那么不应当有其他进程处于（操作同一临界资源的）critical section；
    2. 选择时间有限(progress)：选择下一个进入 critical section 的操作应当只有处于 entry/critical/exit section 的进程参与，且该选择应当在**有限时间内被执行**；
    3. 等待时间有限(bounded waiting)：进程等待被允许进入 critical section 的时间应当是有限的；

接下来，我们以讨论 CS 问题是如何解决的为主线，探索如何解决 race condition。

### For Kernel Code

由于 kernel code 下的 CS 问题解决较为清晰直接，所以先行介绍。

!!! section "For Kernel Code"

    在 kernel code 中也普遍存在着 race condition 的问题，例如：

    <figure markdown>
    <center> ![Race condition when assigning a pid.](img/22.png) </center>
    Race condition when assigning a pid.
    </figure>

    上例中 $P_0$ 和 $P_1$ 同时访问了 `next_available_pid` 这个临界资源，产生竞争，导致最后有两个进程使用了同一个 `pid`。

    欲解决 kernel code 中的 CS 问题，我们可以保证只有一个进程可以运行在 kernel mode，这样就可以保证在 kernel code 中访问临界资源的行为，从而解决 CS 问题。

    对于单处理器来说，我们只需要在 kernel code 中禁止中断，就可以保证只有一个进程可以运行在 kernel mode；而对于多处理器来说，这种方法就不那么合适了——我们需要同时告诉多个处理器中断被禁止，而这个过程中的时延仍然会产生问题；不仅如此，这个方法也会带来额外的开销。在多处理器语境下，我们需要实现**抢占式内核(preemptive kernels)**和**非抢占式内核(non-preemptive kernels)**，关键是后者实现了一段时间内只有一个进程可以运行在 kernel mode[^2]。

接下来我们探索更为通用的解决方案。

!!! info "说明"

    为了简化说明代码，我们用全大写来表示一个共享资源，例如 `READY`，它能够被若干进程访问。实际上这个功能应当由操作系统提供，并不是我们关注的重点。

### Peterson’s Algorithm

!!! quote "Links"

    - [Peterson's algorithm | Wikipedia](https://en.wikipedia.org/wiki/Peterson%27s_algorithm)

Peterson's algorithm 是对**只有两个进程参与**的同步问题的一个解法，具有一定的局限性，但其设计相对简单，所以先行给出。在本节中，我们假设 $P_0$ 和 $P_1$ 是参与同步问题讨论的两个进程。

> 基于 Peterson's algorithm 对多进程情况的扩展被称为 [filter algorithm](https://en.wikipedia.org/wiki/Peterson%27s_algorithm#Filter_algorithm:_Peterson's_algorithm_for_more_than_two_processes){target="_blank"}，但 filter algorithm 不满足 bounded waiting time 的条件，读者有兴趣可以自行了解。

#### 算法描述

为了保证处于临界态的进程至多只有一个，我们应当在进程处于就绪态时，确认没有其他进程处于临界态后再进入。其中最重要的一件事就是，当我们处在 $P_0$ 时，我们如何知道 $P_1$ 是否正处于临界态呢？Peterson’s Algorithm 通过如下方式实现了这件事：

```cpp linenums="1"
// `i` is 0 or 1, indicating current pid, while `j` is another pid.
process(i) {
    j = 1 - i;

    READY[i] = true;                    // ┐
    TURN = j;                           // │
    while (READY[j] && TURN == j) {}    // ├ entry section
        // i.e. wait until:             // │
        //  (1) j exits,                // │
        //  (2) j is slower, so it      // │
        //      should run now.         // ┘

    /* operate critical resources */    // - critical section

    READY[i] = false;                   // - exit section

    /* other things */                  // - remainder section
}
```

首先，我们说明 entry section 没有临界资源。`READY` 是一个共享的数组，每个进程只修改与自己一一对应的 element，所以本质上 `READY` 不会出现 race condition，因而也不是临界资源。而 `TURN`，我们这里只对 `TURN` 进行写的操作，但是 P1 和 P2 谁先跑到这一行会决定 `TURN` 最后的值，所以实际上这里有 race condition。

但这就是 Peterson’s Algorithm 巧妙的地方，Peterson's 利用 race condition 这个“后覆盖前”的性质，实现了标记了这两个进程的先来后到的效果。我们都向这个 `TURN` 写一个互异的值（比如自己的 id，或者对方的 id），等大家都写好后我们看看这个值最终是谁写的，于是就知道谁后到。

利用这个原理，Peterson's 这里做了一个非常有中国人气质的事情：$P_0$ 和 $P_1$ 上公交车后同时看上了一个座位，$P_0$ 说：“你坐吧。”， $P_1$ 自然也要客气一下，说：“还是你坐吧！”。现在两边都客气过了，$P_0$ 就可以心安理得地坐下了。对上述过程，我们给出 $P_0$ 获得椅子的准确条件有：

1. $P_0$ 想坐下，$P_1$ 也想坐下，否则就没有冲突了；
2. $P_0$ 发现 $P_1$ 在客气，但 $P_0$ **已经**客气过了；

对应到上面给出的代码里，这个条件可以翻译为：

1. `#!cpp READY[0]` = `#!cpp READY[1]` = `#!cpp true`；
2. `#!cpp TURN` ≠ `j`，但此前 $P_i$ 已经执行过 `TURN <- j`；

!!! advice "请读者仔细思考上面的过程，并适当进行全面的模拟以理解 Peterson's 是如何工作的。"

#### 性质证明

现在我们需要证明这个算法满足[性质](#r4s2csp){target="_blank"}。

> 我的证明比较详细和啰嗦，但我认为完整地模拟更加有利于直觉理解，如果你想要更简洁的证明，可以参考 [xyx 的笔记](https://xuan-insr.github.io/%E6%A0%B8%E5%BF%83%E7%9F%A5%E8%AF%86/os/III_process_sync/6_sync_tools/#%E6%80%A7%E8%B4%A8%E8%AF%81%E6%98%8E){target="_blank"}。

??? proof "mutual exclusion"

    ```cpp linenums="1" hl_lines="7"
    // `i` is 0 or 1, indicating current pid, while `j` is another pid.
    process(i) {
        j = 1 - i;

        READY[i] = true;                    // ┐
        TURN = j;                           // │
        while (READY[j] && TURN == j) {}    // ├ entry section
            // i.e. wait until:             // │
            //  (1) j exits,                // │
            //  (2) j is slower, so it      // │
            //      should run now.         // ┘

        /* operate critical resources */    // - critical section

        READY[i] = false;                   // - exit section

        /* other things */                  // - remainder section
    }
    ```

    !!! property "lemma"

        如果此时 i 和 j 同处于第 7 行，那么显然：
        
        1. 两个进程都想要进入 critical section，即 `READY[i]` 和 `READY[j]` 都为 `#!cpp true`；
        2. `TURN` 的值不再会被更改；
        3. 两个进程都尚未进入 critical section；
        
        由于 `TURN` 必定也只能为 i 或 j，所以 i 和 j 必然有且仅有一个进程接下来会 break loop 并进入 critical section，在它结束之前，即在 `READY[?]` 被改变之前，该条件持续成立。

        因此我们得到一个结论：如果此时 i 和 j 同处于第七行，那么从该时刻开始，到两个进程都离开 critical section 为止，互斥性质都成立。

    现在我们考虑 i 已经先行运行到第 7 行，而 j 还没运行到第 7 行：

    !!! section "Situation 1"
        
        如果 j 还没进入第 5 行，那么 `READY[j]` 为 `#!cpp false`，此时没有竞争，i 可以直接进入临界态。并且 j 之后运行到第 7 行时，`TURN == <another>` 始终成立。所以 j 何时进入 critical section 完全取决于 `READY[j]`，即 j 何时离开 critical section。

        显然，此时满足互斥性质。

    !!! section "Situation 2"

        如果 j 已经运行完第 5 行，还没执行第 6 行，那么对于 i 来说，`#!cpp (READY[j] && TURN == j)` 为 `#!cpp true`，此时 i 将等待 j，进入 Situation 3。

    也就是说，要么 i 和 j 不竞争，要么两者都运行到第 7 行后才会有进程进入 critical section

    > 这就好像两者在第 6 行比谁先举手，然后等两者都举过手（都跑完第 6 行，到达第 7 行）后，再判断谁进入 critical section，而进入第 7 行以后所有的判断条件都是相对静止的、不会再被修改的，因而避免甚至利用了 race condition 对 selection 的影响，保证了互斥的性质。

??? proof "progress"
    
    这条性质的成立比较符合直觉，唯一需要说明的就是不会出现两个进程同时在 `while ()` 被阻塞住的情况。但是这点非常显然，`#!cpp TURN == i && TURN == j` 必然是 false，所以两个循环总有一个会被 break。

??? proof "bounded waiting time"

    在 Peterson's 中，等待时间主要指这部分的运行时间，尤其指第七行的 `while` 循环。

    ```cpp linenums="1" hl_lines="5-7"
    // `i` is 0 or 1, indicating current pid, while `j` is another pid.
    process(i) {
        j = 1 - i;

        READY[i] = true;                    // ┐
        TURN = j;                           // │
        while (READY[j] && TURN == j) {}    // ├ entry section
            // i.e. wait until:             // │
            //  (1) j exits,                // │
            //  (2) j is slower, so it      // │
            //      should run now.         // ┘

        /* operate critical resources */    // - critical section

        READY[i] = false;                   // - exit section

        /* other things */                  // - remainder section
    }
    ```

    我们可以发现，不断循环的条件是：`#!cpp READY[j] && TURN == j`，如果该循环一开始就不成立，那么显然是符合 bounded waiting time 的，所以我们考虑这个条件最多能持续多久。

    !!! section "A. `#!cpp READY[j]` 为 `#!cpp true`"

        这需要 process j 已经运行过第 5 行，并且还没运行第 15 行，即 process j 也**想要**进入临界态。

        这一条是在判断是否有冲突存在，如现在只有 process i 想要进入临界态，那无需等待直接进入即可。通过**改变这个条件**而进入临界态有两种可能：

        1. 一开始冲突就不存在；
        2. process j 刚离开临界态，释放了临界资源；
        
    !!! section "B. `#!cpp TURN == j` 为 `#!cpp true`"

        有两种可能：
            
        3. process j 还没运行第 6 行；
        4. process j 在 process i 之前就运行了第 6 行；

        对于第一种情况，由于 A. 成立后才会判断这条，所以 process j 的状态其实是刚运行完第 5 行还没运行完第 6 行，显然这个时间是有界的。

        而对于第二种情况，说明 i 是后来者，j 已经客气过一次了，所以应当让 j 运行，i 等待 j 离开临界态释放资源，此时通过 A.2. 来进入临界态。而 process j 操作临界资源的时间也应当有限的。

    综上所述，waiting time 的最大值基本上取自：

    1. process j 执行第 6 行的时间；
    2. process j 操作临界资源的时间；

    通过之前的论述我们知道，这两个都是有界的，于是该性质得证。

!!! bug "Oops!"

    但是，**Peterson's 实际上无法适用于现代计算机中**。上述做法有一个关键，也是我们在证明过程中一直默认成立的事情：进程总是先执行 `READY[i] = true;`，然后才会执行 `TURN = j;`，即先进入就绪态，再申请使用资源，这看起来是个非常合理的条件。但在现代计算机中，编译器可能会通过重排列部分语句来更好地利用 CPU 资源（参考计组的[各种竞争](https://xuan-insr.github.io/computer_organization/4_processor/#422-structure-hazards){target="_blank"}）。而**对编译器来说**，这两个操作（就绪和请求）并没有操作相同内容，因而交换顺序是不会影响结果的，所以可能被编译器交换。而这就有可能导致出现问题，例如：

    <figure markdown>
    <center> ![](img/23.png) </center>
    The effects of instruction reordering in Peterson’s solution.
    </figure>

    在棕色标记时刻，process 1 进行 `while` 循环判断，发现 `READY[0]` 为 `#!cpp false`，但此时 `TURN` 指向对方，所以按照我们先前的分析，此时 process 1 会认为 process 0 是已经运行完 critical section，已经释放了临界资源，所以进入临界态；然而，在绿色标记时刻，对于 process 0，此时 `TURN` 指向自己，process 1 还没运行完所以 `READY[1]` 还是 `#!cpp true`，根据我们之前的分析，此时 process 0 会认为 process 1 在等待自己，所以也进入了临界态。于是，两个进程同时进入了临界态，违反了 mutual exclusion 的性质。

所以，实际上 Peterson's Algorithm 仍然没有解决问题。

### Memory Barriers

该方法实际上是对软件方法的补足。我们先前提到，Peterson's Algorithm 失效的原因是编译器会根据需求重排列一些内存操作，而 memory barriers 保证 barrier 之前的 S/L 指令必须在 barrier 之后的 S/L 指令之前完成，使我们能够主动禁止编译器做这种重排。

```cpp linenums="1" hl_lines="6"
// `i` is 0 or 1, indicating current pid, while `j` is another pid.
process(i) {
    j = 1 - i;

    READY[i] = true;                    // ┐
    memory_barrier();                   // │
    TURN = j;                           // │
    while (READY[j] && TURN == j) {}    // ├ entry section
        // i.e. wait until:             // │
        //  (1) j exits,                // │
        //  (2) j is slower, so it      // │
        //      should run now.         // ┘

    /* operate critical resources */    // - critical section

    READY[i] = false;                   // - exit section

    /* other things */                  // - remainder section
}
```

---

!!! definition "Memory Model"

    不同的计算机架构可能会对用户程序操作内存的保证有所不同，这种保证被称为 memory model。我们可以将它分为两大类：

    1. 强有序(strongly ordered)：进程对内存做的修改立刻对其它处理器可见；
    2. 弱有序(weakly ordered)：进程对内存做的修改不立刻对其它处理器可见；

    我们知道，为了提高内存操作的效率，我们引入了 cache，在多处理器情况下，cache 机制的存在可能导致进程 A 对内存的写无法对进程 B 立刻可见，这就是弱有序的一种体现。

> 这部分我没有完全搞清楚，书本的逻辑非常的诡异：书本认为 memory barrier 是弱有序问题的解决方案，但是我始终没明白它们之间的逻辑在哪里，以及“有序”和“立刻可见”的根本联系在哪里。这里一定是存在不清楚的地方的。但是这部分看起来不是很重要，所以我就先放着不管了。

### Hardware Instructions

硬件可能会提供一些指令支持对数据进行**原子性(atomic)**的操作，我们这里将它们抽象为 `test_and_set()` 和 `compare_and_swap()` 两类来介绍。

#### `test_and_set()`

!!! quote "Links"

    - [Wikipedia](https://en.wikipedia.org/wiki/Test-and-set){target="_blank"}

```cpp
bool test_and_set(bool * target) {
    bool ret = *target;
    *target = true;
    return ret;
}
```

该指令的功能就类似上面这段代码：将目标设为 `#!cpp true`，同时返回其旧值。但除此之外，这个指令需要保证**原子性**，即如果有若干 `test_and_set()` 同时发生，那么无论并发还是并行，它们都应当一个一个地执行，而不能产生时间上的交集。

可以发现，这种 atomic 的操作天然保证了 mutual exclusion，因而对于实现了 `test_and_set()` 的机器，我们可以使用 `test_and_set()` 来解决 CS 问题。

```cpp linenums="1" hl_lines="2"
process(i) {
    while ( test_and_set(&lock) ) {}    // - entry section

    /* operate critical resources */    // - critical section

    lock = false;                       // - exit section

    /* other things */                  // - remainder section
}
```

在第 3 行，循环等待的条件变为 `#!cpp test_and_set(&lock)`，如果 `lock` 的旧值是 `#!cpp false`，则可以继续，并且此时 `lock` 的值被原子性地修改为 `#!cpp true`；而如果 `lock` 的旧值是 `#!cpp true`，那么它经过 `#!cpp test_and_set(&lock)` 后的值仍然是 `#!cpp true`，且需要等待，直到：将 `lock` 改成 `#!cpp true` 的那个进程在 exit section 将 `lock` 改回 `#!cpp false`，即释放锁。

但是请注意，与我们讨论 Peterson's Algorithm 时的语境不同，我们现在不再假设参与竞争的进程只有两个（这是 Peterson's 的局限性之一）。在这个语境下，我们再来考虑它是否满足[三条性质](#r4s2csp){target="_blank"}。

!!! proof "mutual exclusion"

    由于 `#!cpp test_and_set()` 是原子性的，所以同时执行的一系列 `#!cpp test_and_set()` 中，只有一个能返回 `#!cpp false`，即只有一个能通过锁，因而天生满足了 mutual exclusion。

!!! proof "progress"

    代码中对 `lock` 的修改操作是闭合的，即进入 critical section 会导致 `lock` 变为 `#!cpp false`，但离开 critical section 必定导致 `lock` 变为 true。因此，只要没有进程处于 critical section，那么 `lock` 必定为 `#!cpp false`，则一定有就绪的进程能够进入 critical section，而运行 critical section 的时间是有限的，因此 `lock` 又一定会在有限时间内变为 `#!cpp false`，从而满足 progress。

!!! bug "bounded waiting time"

    如果只有两个进程参与竞争，那么通过类似证明 progress 的过程可以得到 bounded waiting time 是可以成立的。A 离开临界态后处于就绪态等待的 B 立刻就能进入 critical section，即只有两个人排队是不会被插队的。

    但在参与竞争的进程变多以后，就很有可能出现类似于调度中“饥饿”的现象：

    ```
        ┌────┐      ┌────┐      ┌────┐      ┌────┐      
    P0  │ CS │   ───┤ CS │   ───┤ CS │   ───┤ CS │   ─── ···
        └────┘      └────┘      └────┘      └────┘      
              ┌────┐      ┌────┐      ┌────┐      ┌────┐
    P1  ──────┤ CS │   ───┤ CS │   ───┤ CS │   ───┤ CS │ ···
              └────┘      └────┘      └────┘      └────┘

    P2  ──────────────────────────────────────────────── ···

    ```

    可以发现，由于 `P0` 和 `P1` 总是轮流获得锁，导致 `P2` 始终处于就绪态等待锁，因而对于 `P2` 来说 waiting time 就不再有限了。

糟了，看起来很酷的一个方法貌似不能满足 CS 解法的性质，但仔细分析，这是由于锁的分配机制是不可控的——在一个锁被释放后，接下来将拿到锁的进程应当是接下来第一个实际执行 `test_and_set()` 的进程，然而由于 ❶ 我们对每个进程的运行速度，不应当有假设，❷ 我们对同时产生的 `test_and_set()` 将按何顺序被处理，不应当有假设，所以我们必须手动用某种方法来实现这种“锁的调度”：

```cpp linenums="1"
// `i` is process id in [0, n), where `n` is the count of related process. 
process(i) {
    waiting[i] = true;                                  // ┐
    while ( waiting[i] && test_and_set(&lock) ) {}      // ├ entry sec.
                                                        // │
    waiting[i] = false;                                 // ┘

    /* operate critical resources */                    // - critical sec.

    // i.e. find next waiting process j                 // ┐
    j = (i + 1) % n;                                    // │
    while (i != j && !waiting[j]) {                     // ├ exit sec.
        j = (i + 1) % n;                                // │
    }                                                   // │
    // release j's lock or release whole lock           // │
    if (i == j)     lock = false;                       // │
    else            waiting[j] = false;                 // ┘

    /* other things */                                  // - remainder sec.
}
```

我们引入了一个 `#!cpp waiting[]` 数组来辅助 `lock` 细化锁的粒度，此时 `lock` 表示的“是否存在竞争”，而 `#!cpp waiting[]` 则标识了所有正在等待的进程。区别于之前直接释放整个锁，让剩下的进程去“拼手速”，我们这次由释放锁的进程来选择下一个进入 critical section 的是谁。

在 11-14 行，通过一个循环找到下一个 `#!cpp waiting[j]` 为 `#!cpp true` 的 j，❶ 如果找到了这个 j，那么就将 `#! waiting[j]` 设为 `#!cpp false`（19 行），这样 j 马上就会在第 4 行 break，进入 critical section；❷ 而如果找不到这个 j，即找了一圈又找回了 i，那么说明 i 是最后一个了，所以可以直接释放整个锁（17 行）。

通过使用这种方法，我们保证了等待中的进程最多只需要等待 n-1 个进程运行完 critical section（类似于实现了“FCFS”）。

#### `compare_and_swap()`

!!! quote "Links"

    - [Wikipedia](https://en.wikipedia.org/wiki/Compare-and-swap)

`compare_and_swap()` 也被简写为 CAS 指令，它的功能如下：

```cpp linenums="1"
int compare_and_swap(int * target, int expected, int new_val) {
    int ret = *target;

    // *value = (*target == expected) ? new_val : *value;
    if (*target == expected) {
        *value = new_val;
    }

    return ret;
}

```

CAS 接受三个值：

1. `target` 待修改的数据的地址；
2. `expected` 预期中待修改的数据的旧值；
3. `new_val` 希望将数据修改为的新值；

而当且仅当 `*target` 符合预期，与 `expected` 相同时候，才会将它改为 `new_val`。同样，CAS 也应当保证原子性，即若干 CAS 同时发生时，也应当一个一个的执行，而不能存在时间上的交集。

我们注意到，实际上 `#!cpp test_and_set(target)` 就是 `#!cpp compare_and_swap(target, false, true)`，因而实际上 CAS 解决 CS 问题的方法以及问题和上一节的内容没什么差别。

但是我们发现，`compare_and_swap()` 相比于 `test_and_set()`，显然有更大的操作空间，也更泛用，考虑到 CAS 指令自身已经能够支持原子性的修改值，我们考虑能否跳出 CS 问题的范式来考虑问题。

## Atomic Variables

**原子变量(atomic variables)**是一种用原子性操作维护的变量。我们所有对原子变量的操作可以通过 CAS 来实现，例如自增操作：

```cpp
void increment(atomic_int * v) {
    int tmp;
    do {
        tmp = *v;
    } while ( tmp != compare_and_swap(v, tmp, tmp+1) );
}
```

使用 atomic variables 后实际上就不太符合 CS 问题的模型了，可以发现，这里并不再需要维护类似 `lock` 的东西，而是以 `*target` 是否符合 `expected` 的预设来判断是否有竞争出现，作为一个同步工具，我们可以直接使用这种封装后的原子性操作来解决 race condition，而不需要再区分 entry section 或是 critical section 等。

> 书本上特地提到，在例如 producer&consumer 的模型中，使用 atomic variables 维护 count 并不能解决 race condition，但我认为这种讨论是有失偏颇的，所谓的“原子性”应该包括所有操作临界资源的部分，书中只维护 count 不维护 buffer 的假设我觉得对于 atomic 这个概念来说实在不够公平。所以我在这里就不着重说明这个问题。

## Mutex Locks

















[^1]: [The Critical Section Problem](https://crystal.uta.edu/~ylei/cse6324/data/critical-section.pdf){target="_blank"}

[^2]: 书本中对 preemptive kernels 和 non-preemptive kernels 的定义并不准确，两者最本质的区别是后者实现了 [Giant Lock](https://en.wikipedia.org/wiki/Giant_lock){target="_blank"}。同时读者可以参考这个链接：[What was the reason of the non-preemptivity of older Linux kernels?](https://unix.stackexchange.com/questions/412806/what-was-the-reason-of-the-non-preemptivity-of-older-linux-kernels){target="_blank"}