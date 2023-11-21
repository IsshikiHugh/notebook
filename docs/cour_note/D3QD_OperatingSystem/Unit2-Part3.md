# U2 Part 3: 死锁 | Deadlocks [未完成]

!!! info "引入"

    死锁问题广泛存在于计算机软件系统中，而我们本节**只讨论操作系统中的死锁问题**。

## 死锁建模

我们在[上一节](./Unit2-Part2.md#the-dining-philosophers-problem){target="_blank"}中已经提到了一个死锁情况。本节我们专注于如何解决操作系统中的**死锁(deadlock)**问题。

!!! definition "deadlock"

    A **deadlock** is a situation in which every process in a set of processes is waiting for an event that can be caused only by another process in the set.

    即存在一个进程/线程的集合，它们**互相**等待对方持有的资源。

    > 与之对应的，其实还有一个叫**活锁(livelock)**[^1]的东西。

死锁产生于资源的使用过程，而且通常只在特定情况下才会发生，而正是因为这种不确定性，死锁问题才异常棘手。为了解决死锁，我们首先需要理解死锁产生的原因，以方便对它进行建模，进而更好地描述死锁。

从资源使用的角度来看，我们可以将系统的行为分成三个部分：

1. 申请资源；
2. 使用资源；
3. 释放资源；

其中，申请资源和释放资源通常通过不同的系统调用实现。而部分资源是有限且互斥的，因而如果在缺乏资源的情况下，进程/线程仍然想要申请资源，就只能陷入等待。而正在等待的资源也可能持有一些资源，一旦恰好出现了互相等待的情况，就会出现死锁。例如，互斥锁和信号量这些东西就是死锁产生的一大重要来源。

> 计算机资源分为很多类，每一类中可能有若干**平等**的“实例(instance)”。对于一个合理的“资源分类”来说，一个进程/线程需要某种资源时候，这个资源类别中的任意空闲实例都应当可以被用于满足这个进程/线程的需求。

### 资源分配图

根据上面的描述，我们可以知道，建模死锁可以从讨论进程/线程与资源的求取关系入手。我们可以用**资源分配图(resource-allocation graph)**来描述这件事。

!!! section "静态"

    资源分配图是一种有两类节点的有向图，我们用圆节点 $T_i$ 表示进程/线程，用方节点 $R_j$ 表示资源，方节点中的实心点表示一个资源类别的一个实例。同时，我们称从进程/线程指向**资源类别**的有向边为**请求边(request edge)**，表示进程/线程 $T_i$ 正在等待这种资源；称从**资源实例**指向进程/线程的有向边为**分配边(allocation edge)**，表示资源 $R_j$ 被分配给进程/线程 $T_i$，即目前进程/线程 $T_i$ 持有一个（一条边表示一个）资源 $R_j$ 的实例，例如下图：

    <figure markdown>
        <center> ![](img/24.png) </center>
        Resource allocation graph.
    </figure>

    - 当资源分配图中不存在环时，说明不会出现死锁状态；
    - 当资源分配图中存在环时，系统可能处于死锁状态，也可能不处于死锁状态；
        - 「特例」如果与环相关的节点都只有一个实例时候，系统处于死锁状态；

    换句话来说，资源分配图中存在环，是系统处于死锁状态的**必要条件**。

!!! section "动态"

    - 进程/线程申请某个资源时，在图中添加一条对应的 request edge；
    - 当资源索取成功时，这条 request edge 被替换为 allocation edge；
    - 当进程释放这个资源时，则需要将该 allocation edge 消除；

> 在之后的内容中，我们还将看到一些资源分配图的变体：引入 claim edge 以及只保留进程/线程等待关系的 wait for graph。


## 死锁的条件

要想死锁出现，下面四个条件必须**同时满足**：

1. **互斥(mutual exclusion)**：死锁中至少有一个资源必须是非共享的，即一次只能被一个进程/线程使用；
    - 正因为互斥资源无法被同时使用，所以需要资源的进程/线程需要等待持有目标资源的进程/线程释放该资源以后才能使用目标资源；
2. **持有并等待(hold & wait)**：死锁中的进程/线程在等待资源的同时，也必须持有至少一个资源；
    - 为了促成循环等待，一个等待其它资源（有出边）的进程/线程必须持有至少一个资源，这样才能让其它资源也等待它（有入边）；
3. **非抢占(no preemption)**：死锁中的进程/线程只能在使用完资源后主动释放资源，其持有的资源无法被其它进程/线程抢占；
    - 为了保证等待关系不会被强行破坏；
4. **循环等待(circular wait)**：死锁中的进程存在环状的等待资源关系，即 wait for graph 中存在环$；
    - 逻辑上导致死锁出现的直接原因，互相等待导致没有资源会被释放，导致死锁状态无法被打破；

> 可以发现，这四个关系并不完全独立。

## 死锁的处理

我们很容易认识到，死锁的危害是巨大的，那么如何解决**操作系统中的**死锁问题呢？主要有这么几个思路：

1. 不做额外处理，要求程序员保证逻辑上不会出现死锁；
2. **死锁预防(deadlock prevention)**：使用某种规范或协议来保证死锁不会出现；
3. **死锁避免(deadlock avoidance)**：禁止可能产生死锁的行为的发生；
    - 与 2. 的最主要的区别是，2. 在规范下的所有行为都不会出现死锁问题；而 3. 则是不约束行为，但是禁止可能产生死锁的行为执行，在稍候介绍具体内容后会更容易理解；
4. **死锁检测(deadlock detection)和死锁解除(deadlock recovery)**允许死锁的出现，但是当检测到死锁时，需要去消除死锁问题；

> 事实上，在主流操作系统中，一般选择使用第一种，将问题交给开发者去解决。

接下来我们来介绍上面提到的后三个方法中的四块内容。其中有部分内容有较大交集，它们可能属于同一纲领下在不同时刻做的处理。

## 死锁预防

deadlock prevention




## 死锁避免

deadlock avoidance



## 死锁检测

deadlock detection



## 死锁解除

deadlock recovery





[^1]: [What's the difference between deadlock and livelock?](https://stackoverflow.com/a/6155978/22331129){target="_blank"}


## sketch

死锁预防 | Deadlock Prevention

死锁预防指破坏之前提到的四个必要条件，只要保证某个条件始终不成立，就可以避免死锁的发生。

- mutual exclusion
    - 这个东西显然没法不成立，很多资源天然互斥
- hold and wait
    - 一次性拿走所需要的所有资源，就不会有“有一部分等一部分”资源的情况，效率显然很低
- no preemption
    - 拿不到所有的就需要主动释放正占有的
    - 任务没完成之前就释放资源可能导致任务失败，总之很难实现而且效率很低
    - 感觉和上面那个分不清到底破坏了哪个，但是毕竟很难区分
- circular wait
    - 通过给资源编号，规定线程只能按编号递增的顺序申请资源，就不会出现循环等待的情况
    - 限制很大（限制了添加新的资源、有些逻辑顺序与要求顺序也可能冲突）

死锁避免 | Deadlock Avoidance

> 死锁预防是保证死锁在逻辑上不会产生；死锁避免是阻止可能产生死锁的情况。

- 安全状态
    - 充要条件：safe sequence
    - 需要保证 Ti 所需要的资源可以由余下资源和之前的资源已经持有的资源满足
    - 按照 safe sequence 的顺序分配资源和执行
    - 在 safe sequence 下，所有资源都足够使用，没必要“争夺”资源


<figure markdown>
    <center> ![](img/25.png) </center>
    Safe, unsafe, and deadlocked state spaces.
</figure>


! eg "放一个例子"

- 资源分配图算法(了解即可)
    - 当所有资源都只有一个的时候可以使用
    - 引入 claim edge，如果未来 Ti 可能需要申请 Rj，那么有一条 Ti->Rj 的 claim edge
    - 如果真的分配了，那么改成 assignment edge
    - 我们需要保证在 Ti 参与算法之前，所有的 claim edge 都已经在图中出现
        - 我们可以约束当且仅当 Ti 的所有相关边都是 claim edge 时，Ti 才能进入图
    - 如果将 request edge 从 Ti->Rj 变为 assignment edge Rj->Ti 时，图中出现了环（使用图论环检测算法），那么会让图进入 unsafe 状态；反之是 safe 的。如果 safe，则这个分配是允许的
- 银行家算法
    - 银行家算法支持每个资源类别不止一个的情况，但是效率不如分配图
    - 每个进程/线程进入以后都需要先声明自己需要（各类资源）最多多少资源
    - 每次有用户请求资源的时候系统都会检测，这个请求会不会导致系统进入 unsafe 的状态，如果会就需要等待其他进程/线程释放足够多资源以后再允许
    - 为了实现这个算法，我们需要维护一些数据结构：
        - `n` = number of threads
        - `m` = number of resource types
        - `Available[m]` = number of available resources of each type
        - `Max[n][m]` = maximum demand of each thread
        - `Allocation[n][m]` = number of resources of each type currently allocated to each thread
        - `Need[n][m]` = remaining resource need of each thread
            - `Need[i][j] = Max[i][j] - Allocation[i][j]`
    - Safety Algorithm 步骤：
        - 判断系统是否在 safe 状态
        1. `Work[m]` <- `Available[m]`, `Finish[n]` <- False
        2. 找到一个 `i` 使得：
           - `Finish[i]` == False
           - `Need[i]` <= `Work`
           - 如果没有这个 `i`，则 goto 4
        3. `Work` <- `Work` + `Allocation[i]`, `Finish[i]` <- True, goto 2（即表示了进程/线程运行结束后，资源会被释放）
        4. 如果所有进程/线程都满足 `Finish[i]` == True，则系统处于 safe 状态；否则，系统处于 unsafe 状态
    - Resource Request Algorithm
        - 判断请求是否能被安全地允许（两个步骤，先判断能不能分配，再看分配之后安不安全）
        - 用 `Request[n][m]` 表示进程/线程想要请求的资源的数量
        1. 如果 `Request[i]` <= `Need[i]`，goto 2；否则，出错，因为它请求的量超过了它之前说的最大预期
        2. 如果 `Request[i]` <= `Available`，goto 3，即资源足够；否则，进程/线程必须等待，因为没有足够的资源
        3. 假设系统分配了资源，即 
           - `Available` <- `Available` - `Request[i]`
           - `Allocation[i]` <- `Allocation[i]` + `Request[i]`
           - `Need[i]` <- `Need[i]` - `Request[i]`
         - 如果这样之后的状态是 safe 的（上面那个算法），那么就允许这个请求；否则，进程/线程必须等待，因为没有足够的资源

    - 有一个关键问题是，为什么这里看似“贪心”的做法是成立的？
        - 考虑一个进程/线程，释放的资源总是不比索取的资源少，所以贪心的使用不会带来问题。

> 缺陷： from Wiki
> 
> Like the other algorithms, the Banker's algorithm has some limitations when implemented. Specifically, it needs to know how much of each resource a process could possibly request. In most systems, this information is unavailable, making it impossible to implement the Banker's algorithm. Also, it is unrealistic to assume that the number of processes is static since in most systems the number of processes varies dynamically. Moreover, the requirement that a process will eventually release all its resources (when the process terminates) is sufficient for the correctness of the algorithm, however it is not sufficient for a practical system. Waiting for hours (or even days) for resources to be released is usually not acceptable.

死锁检测 | Deadlock Detection

- 如果系统既没有预防也没有避免死锁，那么可能需要一个死锁检测和恢复机制

- 对于一个资源类型只有一个实例的情况
    - 使用 wait for graph：折叠资源分配图里适当的边，并删掉资源（只有圆形）
    - 系统需要维护 wait for graph，并时不时调用算法检测环，如果有环，则说明有死锁
- 对于一个资源类型可以有多个实例的情况
    - 类似银行家算法（一般只考银行家算法）

- 算法使用
    - 检测算法的使用要多频繁？
    - 出现死锁以后有多少进程/线程要 roll back？

死锁解除 | Deadlock Recovery

- 终止
    - 不容易，开销都很大
    - 终止所有死锁进程/线程
    - 一个一个终止，直到死锁消失
        - 考虑终止顺序
- 抢占资源
    - 抢占资源需要考虑的几个问题：
        - 选择受害者
            - 考虑顺序
        - 回滚
            - 资源被抢占之前需要让进程/线程回到一个相对安全的状态下。但是由于‘安全’难以界定，所以一般都是直接杀死。如果想要更经济地回滚到比较新的状态，则需要操作系统维护更多资源以支持恢复。
        - 饥饿避免
            - 回滚次数纳入优先级的考虑范畴


