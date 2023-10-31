# Lecture 15 | External Sorting

!!! quote "link"
    Wikipedia: https://en.wikipedia.org/wiki/External_sorting

外排序与数据库系统中的相关内容有交叉关系，当需要排序的数据过大，而无法被完全放在内存时，普通的排序算法无法被应用。此时需要使用外排序，简单来说就是在更大的尺度上进行类似归并的操作。

而正因为此，外部排序的过程与硬件设计有一定关系。

???+ section "与硬件相关的一些说明"
    具体来说，普通的排序算法排序的对象都是放在内存里的一些数据，例如一个 `int` 数组。然而外部排序排序的对象，或者说要排序的那个“数组”，没法被完整地存在内存里，它们都被存储在硬盘之类的非易失介质中，而从这种介质里读取数据往往具有较大的开销，所以我们总是“一块一块”从里面那数据。

    > 打个比方，你现在需要对一整个图书馆（硬盘）的书做排序，但是你的桌子（内存）上最多放下三十本书，换句话来说，你一次最多处理三十本书。而为了从图书馆中获取需要排的书，你得先找到这些书在哪（seek），然后再把连续的三十本书拿出来（block transfer），放到你的桌子（内存）上再排序，而为了给接下来三十本书腾位置，你还得把排好的三十本书再放回去（即记录下排序结果，同样也是一次 block transfer）。

    综上所述，外部排序主要解决的就是，按照怎样的策略来对这些数据进行排序。

!!! info "导读"
    由于 ADS 介绍的外排序和同时期数据库系统这门课介绍的外排序有同有异，所以我打算先在大概讲外排序的核心思路，再展开 ADS 课程中的具体过程。

---

## 概述

外排序的基本思路就是将数据分为若干个小块，然后对每个小块进行排序，最后再将这些小块合并起来。而我们常说的归并排序，指的是递归地将两块合成一块，而所谓的 $k$ **路（$k$-way）**归并，就是将 $k$ 块合成一块。

那么如何归并呢？我将从两个维度来简单阐述。

---

### 逻辑维度

外部排序所使用的归并排序从逻辑上来讲和普通的归并排序一致，总是将 $k$ 个有序序列合并为 1 个有序序列。

而这里的“有序序列”，在外排序中被称为“run”，即每次归并我们另 $k$ 个 run 变成一个 run。正着说就是：

!!! definition "run"
    一个 run 指的是一段过程中的数据，在本文中特指待归并的有序的序列，在 $k$-way merge 中，我们总是将 $k$ 个 run 合并为 1 个 run。

    !!! warning "说明"
        这里的 run 的定义是我自己脑补出来的，并不确定是否严格，但是可以保证的是： 一个 run 在参与 merge 之前肯定已经有序了，可以理解为 "have already run"，而为了不搅糊读者的脑子，我这里就以这个定义为准。

从执行的顺序来说，**内**排序中的归并排序是一个自上而下不断 $\frac{1}{k}$ 地划分，再自下而上不断归并的过程。相反，**外**排序由于其特性限制，其“归并段”并不是自上而下 $\frac{1}{k}$ 划分出来的，而是根据硬件处理能力，直接划分好最小的归并段，然后直接自下而上归并。

而这样一个将 $k \cdot c$ 个 run merge 成 $c$ 个 run 的过程，我们称之为一个 `pass`。（在归并树上体现为一层。）

---

### 物理维度

> 关于物理维度，涉及到一些硬件知识，在 ADS 中为了方便说明会将其简化，有关 block 的概念将被抽象化为“数据单位”。

我们知道，内存的大小是有限的，划分给归并数据的内存也应当是有限的，我们用 $M$ 来记它，即内存中一次只能处理 $M$ 个单位的数据。

> 更细节的，我们应当更具物理大小来计算 $M$，例如一条数据的大小是 $l \text{Bytes}$，而内存的大小是 $m \text{Bytes}$，那么一个内存能够容纳的数据数量应当为 $\lfloor \frac{m}{l} \rfloor$。

但是既然要归并，我们就需要将 $k$ 路的数据读入到内存中，最理想的情况下我们肯定希望这 $k$ 路都能读入到内存中，但是显然这是不切实际的，我们最多公平地读入每一路的前 $\lfloor \frac{M}{k} \rfloor$ 个数据——但这已经足够——对于 $k$ 个有序序列的合并操作，其合并过程中也恰好只与最靠前的、未排序的一部分数据有关。

!!! warning "说明"
    之后所提到的，有关于排序数据的“内存”，指的都是划分给算法，用来存放归并数据的内存！

!!! eg "example"

    举例来说，假设现在有两个 run，分别为：

    1. `1` `3` `5` `7` `9`
    2. `0` `2` `4` `6` `8`

    但是内存只能放 4 个单位数据，所以对于每个 run 总是只有前 2 个数据是可见的。但是这并不影响我们可以确定这两个 run 合并的结果中，前一部分是 `0` `1` `2`，而至于 `2` 后面排什么，则要从 `run2` 中取出之后的数据，再与 `run1` 余下的 `_` `3` 合并。

    !!! key-point "易错点"
        注意，当其中一个段的 buffer 空了以后，我们不能直接把其他段的 buffer 直接排序进去，而必须先填充这个空 buffer 的内容，再继续排序。

        想象这样一个情况，空 buffer 将要载入的下一段数据是 `3` `4` `5`，而另外一个 buffer 剩下的数据是 `7`，那么显然，`3` `4` `5` 应该先于 `7` 被排序。

而这个过程也正是外排序能够进行的一个重要基础。

---

其中比较特别的步骤就是，最开始的排序，即第一个 pass。先前我们在[#逻辑维度](#逻辑维度){target="_blank"}里提到了，外排序的第一个 pass 会直接划分好最小的归并段，而这个“最小归并段”的大小就是 $M$。用语言描述，就是最早的 run 的大小就是平均每一路能够在内存中处理的最大数据单位量。

然而问题出现了，根据我之前给出的定义，run 应当是有序的，但是从原始数据里读出来的“最小归并段”是无序的。但是对于最初的 run，它必然能够整段放到内存里（更进一步的，也只有最初的 run 能够完整地放到内存里），因此直接对其进行内排序即可。

!!! advice "逻辑联系"
    - 因为内排序很快，所以要尽可能利用内排序；
    - 所以一开始就要将能内排序做的事情都用内排序解决；
    - 所以最初的 run 的大小是 $M$。

---

!!! info "中继"
    以上内容是对外排序核心思想的一个简单介绍，接下来我们将以 ADS 所介绍的外排序范式，来介绍一下具体的过程和一些改进。

---

## 具体分析

ADS 中相比上面介绍的部分，又引入了一个叫 tape 的概念，tape 的中文是磁带，而在这个框架中，我更倾向于把它当作一个抽象的概念。

相对应的，其实际过程与上面描述的方法可能有一些感受上的差别，如果只是了解思想的话上半部分已经足够（当然后面还有一些基于如下模型的优化讨论），但是毕竟还是面向考试，所以还是需要以 ADS 课件的方法再介绍一次。

!!! warning "说明"
    我之后会以 run 为单位，来描述合并过程。但是实际发生在计算机里的步骤更加复杂：

    需要先将每一条 tape 的一部分数据读入内存的 buffer 中，然后利用这些 buffer 来进行排序；当某个 buffer 空了以后要立刻将对应 tape 的下一部分数据读入，直到没有数据可以填充为止。

    也正是[#物理维度](#物理维度)所说的那些。

---

### 朴素过程分析

我们以 2-way merge 为例，结合 ADS 课件中的配图来说明。

???+ section "准备"
    <center>
    ![](img/66.png)
    </center>

    图中 $T_1$ 是一条 tape 的编号，我们可以理解为一个序列的物理地址，或更通俗的来说，可以当作一个数组，只不过它的实际数据是在硬盘中。换句话来说，这里的 tape 表示的都是硬盘中的数据。

    这条 tape 中有 13 个元素，我们记其为 $N = 13$。而这条原始的 tape 被划分为了 5 段，每一段都有不超过 3 个元素，此时 $M = 3$。即有 $\lceil \frac{N}{M} \rceil = 5$。

???+ section "Pass 1"

    现在我们要开始 merge 了。对于这段数据来说，这是意义重大的“人生第一次”，相比于其他归并都是从 2 个 tape 开始的 pass，这一次显得有些特殊。

    在第一轮中，面对全部都是无序的数据，我们将这 $\lceil \frac{N}{M} \rceil = 5$ 个段均分到两条 tape 上（2-way），这里经历两个步骤：

    1. 依次读取 $T_1$ 中每一段数据（刚好占满内存），并对它们进行内排序；
    2. 将排序完的段，追加写到 $T_2$ 或 $T_3$ 中（具体每一个 tape 写几条，会有专门策略做调整，目前先平分着放）；

    于是，$T_1$ 中的数据便被转移到了 $T_2$ 和 $T_3$。为了重复利用 tape，此时的 $T_1$ 被看作可以用的空磁盘了。

    <center>
    ![](img/67.png)
    </center>

    于是，完成了第一个 pass。

???+ section "Pass 2"

    之后的 pass 则基本遵循同样的规则，不断取每一路的第一个 run 并 merge，并且将结果写到两个（k 个）闲置的 tape 上（和前面说过的一样，这里暂且将分配策略定为平分到每一个 tape 上）。
    
    例如，我们要取 $T_2$ 和 $T_3$ 的第一段，执行归并操作，得到一个新的，有 6 个数据的 run，并写到闲置的 $T_1$ 上；接下来取 $T_2$ 和 $T_3$ 的第二段，归并得到新的 run，此时我们发现，$T_1$、$T_2$、$T_3$ 都不是闲置的，所以我们需要一个新的 tape，写到 $T_4$ 上。

    <center>
    ![](img/68.png)
    </center>

    于是，完成了第二个 pass。

???+ section "Pass 3"
    
    pass 3 和 pass 2 的过程基本一致。现在的 tape 状态是 $\{T_2, T_3\}$ 闲置，我们取 $T_1$ 和 $T_4$ 的第一段，得到一个新的 run，包含 12 个元素；取 $T_1$ 和 $T_4$ 的第二段，得到一个新的 run，包含 1 个元素。这两段被分配到两条空闲 tape 上，即 $T_2$ 和 $T_3$。

    <center>
    ![](img/69.png)
    </center>

    于是，完成了第三个 pass。

???+ section "Pass 4"

    同样，pass 4 和前面两个 pass 的过程也是一致性的，不做过多解释，对于规模更大的数据也是一样，除了第一个 pass 比较特殊，其它 pass 都是一样的。最终得到只剩下一个 tape 中包含唯一的 run 时，排序就结束了。

    <center>
    ![](img/70.png)
    </center>

    至此，排序结束。

---

### 优化空间

可以优化的部分主要有这么几个：

- 一个 pass 意味着若干次 seek，所以减少 pass 可以是一个方向；
    - [#pass-数量分析与优化](#pass-数量分析与优化){target="_blank"}
- merge 的过程中会多次读取 tape 中的数据，而对于计算机来说单次大量读取比多次小量读取更高效，如何优化数据读取也是一个方向；
    - [#tape-数量分析与优化](#tape-数量分析与优化){target="_blank"}
- 如何更高效的在 $k$-way merge 过程中，归并 M 个分别来自 k 个序列的数据，即内排序的策略，也上优化的一个方向；
    - [#k-路内排序优化](#k-路内排序优化){target="_blank"}
- 读入、内排序、输出，这三个事务目前是停机串行的，考虑将其并行化也是一个方向；
    - [ ] TODO

---

### pass 数量分析与优化

例子中一共经过了 4 次 pass。如果我们记 $max(\#run)$ 为 $\#run$ 最多的 tape 的 $\#run$，则每一次 pass 会令 $max(\#run)$ 缩小一半，直到 $max(\#run)$ 变为 1，且只有它一条 tape 还有数据，标志着排序结束。

如果专注于 $\#run$ 的变化，那么上面的模拟步骤大致是这么一个过程：

!!! section "Pass 1"
    原先 $T_1$ 上 $\#run = 5$，现将它分配到两条 tape 上，于是有：

    - $T_2$ 上 $\#run = 3$；
    - $T_3$ 上 $\#run = 2$；

!!! section "Pass 2"
    依次取 $T_2$ 和 $T_3$ 的第一段，归并得到新的 run，均分到另外两条 tape 上（未优化的做法，优化做法参考[#tape-优化](#tape-数量分析与优化){target="_blank"}），于是有：
    
    - $T_2$ 上 $\#run = 3-1 = 2$；
    - $T_3$ 上 $\#run = 2-1 = 1$；
    - $T_1$ 上 $\#run = 0+1 = 1$；
    - $T_4$ 上 $\#run = 0$；

    继续取，即：
    
    - $T_2$ 上 $\#run = 2-1 = 1$；
    - $T_3$ 上 $\#run = 1-1 = 0$；
    - $T_1$ 上 $\#run = 1$；
    - $T_4$ 上 $\#run = 0+1 = 1$；

    $T_3$ 上已经没有了，但是 $T_2$ 还没取完，所以只从 $T_2$ 拿：

    - $T_2$ 上 $\#run = 1-1 = 0$；
    - $T_3$ 上 $\#run = 0$；
    - $T_1$ 上 $\#run = 1+1 = 2$；
    - $T_4$ 上 $\#run = 1$；

模拟到从这里其实已经可以看出来了，对于 2-way merge 来说，排除末段情况，从第二个 pass 开始，基本上每次都是从 2 路中各取 1 个 run，并合并为 1 个 run。换句话来说，每一个 pass 会让 $total(\#run)$ 缩小为原来的 $\frac{1}{2}$。

那么，对于 $k$-way merge 来说，就是从第二个 pass 开始，每次从 $k$ 路中各取 1 个 run，并合并为 1 个 run，每一个 pass 会让 $total(\#run)$ 缩小为原来的 $\frac{1}{k}$。

因此，我们可以归纳得到如下计算式：

$$
\begin{aligned}
\#pass &= \underbrace{
        1
    }_{\text{pass 1}}
    + 
    \underbrace{
        \lceil \log_{k}{(\#run)}\rceil
    }_{\text{rest passes}} \\
    &= \underbrace{
        1
    }_{\text{pass 1}}
    + 
    \underbrace{
        \lceil \log_{k}{
            \lceil \frac{N}{M} \rceil
        }\rceil
    }_{\text{rest passes}} 
\end{aligned}
$$

其中，$k$ 表示归并路数，$N$ 表示数据量，$M$ 表示内存一次能处理的数据量。

那么，减少 pass 的方法也很直观了，只需要增加 $k$ 即可，即采取更多路的归并，就能减少 pass。

然而，其中必然存在一个 trade-off 的关系，虽然 $k$ 增加可以减少 $\#pass$，但是在接下来一节中我们会知道，$k$ 过大会导致 tape 需求量增加，此外，$k$ 的增加也会导致内排序的复杂度增加，也会增加 pass 内的 seek 次数。

当然，除了暴力的增加 $k$ 以外，我们还可以通过使用**替换选择(Replacement Selection)**算法，来生成比 $M$ 大的初始 run，以相对减少 pass 数量。

#### 替换选择算法

**替换选择(Replacement Selection)** 在 hw15 中被布置为编程题，所以其实现过程可以结合那道题目来学习。

??? section "Replacement Selection @ PTA"
    When the input is much too large to fit into memory, we have to do external sorting instead of internal sorting. One of the key steps in external sorting is to generate sets of sorted records (also called runs) with limited internal memory. The simplest method is to read as many records as possible into the memory, and sort them internally, then write the resulting run back to some tape. The size of each run is the same as the capacity of the internal memory.

    **Replacement Selection** sorting algorithm was described in 1965 by Donald Knuth. Notice that as soon as the first record is written to an output tape, the memory it used becomes available for another record. Assume that we are sorting in ascending order, if the next record is not smaller than the record we have just output, then it can be included in the run.

    For example, suppose that we have a set of input { 81, 94, 11, 96, 12, 99, 35 }, and our memory can sort 3 records only. By the simplest method we will obtain three runs: { 11, 81, 94 }, { 12, 96, 99 } and { 35 }. According to the replacement selection algorithm, we would read and sort the first 3 records { 81, 94, 11 } and output 11 as the smallest one. Then one space is available so 96 is read in and will join the first run since it is larger than 11. Now we have { 81, 94, 96 }. After 81 is out, 12 comes in but it must belong to the next run since it is smaller than 81. Hence we have { 94, 96, 12 } where 12 will stay since it belongs to the next run. When 94 is out and 99 is in, since 99 is larger than 94, it must belong to the **first run**. Eventually we will obtain two runs: the first one contains { 11, 81, 94, 96, 99 } and the second one contains { 12, 35 }.

    Your job is to implement this replacement selection algorithm.

利用替换选择策略以后，每一次生成的 run 一定不小于 $M$（末端余数除外），于是相对来说 $\#pass$ 就会减少。

---

### tape 数量分析与优化

如果使用[#朴素过程分析](#朴素过程分析){target="_blank"}中的方法，那么我们使用 $k$-way merge 至少需要 $2k$ 个 tape。

这其实很好理解，我们每一个 pass 需要 $k$ 个 tape 来存放每一路的序列，而其结果要平分放复制到下一个 pass 所需要的 $k$ 个 pass 中，所以至少需要 $2k$ 个 tape 轮换着来存储数据。

而这不利于我们通过增加 $k$ 来减少 $\#pass$，因此我们考虑某种策略来优化 tape 的使用。

在[#朴素过程分析](#朴素过程分析){target="_blank"}中我多次暗示，之后会对「将归并后的 run 平分到各 tape」这件事做优化。

我们可以考虑，不平均的将归并后的 run 分配到各个 tape 上，即总有一些 tape 比别的 tape 多一些 run。虽然在平分的策略中，也有可能会有多出来的 run，但是只会多一个（也就是将 $x \mod k$ 的余数分配到其中几个 tape 上）。此时这些多出来的 run 可能就是单纯的从一个 tape 别复制到另外一个 tape 上，看起来是个非常没必要的操作，为什么不直接留下它，将当前 tape 拿到下一轮用呢？

但是由于平分策略下，这个情况的出现并不可控，而且总是会引起悬殊的 tape 间的数量差，所以我们考虑能不能主动利用这个性质。

~~实在想不到怎么过度了，而且急急急，所以直接上结论。~~

我们按照 Fibonacci 数列的项来分配每个 tape 的 $\#run$，此时每一个 pass 只需要一个有一个空闲的 tape 即可。

!!! eg "example"
    $$
    \text{Fibonacci}: {1,1,2,3,5,8,13,21,...}
    $$

    假设我们现在有两个 tape，分别有 23 个 run 和 13 个 run，则：

    |$T_1$|$T_2$|$T_3$| 说明 |
    |:---:|:---:|:---:|:----|
    | 21  | 13  | -   | 初始情况 |
    | 8   | -   | 13  | $T_1$ 的前 13 个与 $T_2$ 归并，结果写入 $T_3$ |
    | -   | 8   | 5   | $T_3$ 的前 8 个与 $T_1$ 归并，结果写入 $T_2$|
    | 5   | 3   | -   | 略 |
    | 2   | -   | 3   | 略 |
    | -   | 2   | 1   | 略 |
    | 1   | 1   | -   | 略 |
    | 0   | -   | 1   | 略 |

使用 Fibonacci 我们总可以滚动着将 $\#run$ 的规模缩小。

???+ extra "k-way merge with k-order Fibonacci Sequence"
    对于 $k$-way merge，我们只需要构造 k 阶 Fibonacci 数列，然后按照这个数列来分配每个 tape 的 $\#run$ 即可。

    !!! definition "k-order Fibonacci Sequence"
        给出 k 阶 Fibonacci 数列（与 PPT 略有不同，主要体现在下标从谁开始，无伤大雅）：

        $$
        \left\{
        \begin{aligned}
            F^k_1 &= 1 \\
            F^k_2 &= 1 \\
            & \vdots\\
            F^k_n &= F^k_{n-1} + F^k_{n-2} + \cdots + F^k_{n-k} \quad (n > k)
        \end{aligned}
        \right.
        $$

    这个结论看起来很自然，但是实际上是怎么操作的呢？PPT 压根没讲，因此，我在询问 ch 老师以后，写下了这个部分，旨在补充 $k$-way merge 使用 k 阶 Fibonacci 优化的方法。

    > 首先，做一些强调：
    > 
    > 1. 该方法陈述过程中，k 路始终直接合并成一路（千万不要用“iterative”的思路来考虑，就算 iterative，迭代完了也还是 k 路归为 1 路）；
    > 2. 我们的目的是优化每一个 pass 中每个 tape 的 $\#run$ 不一样带来的性能问题（例如尴尬的 $n$ 和 $n+1$ 归，下一个 pass 就得 $1$ 和  $n$ 归了）；

    对于第 $i$ 个 pass，有 $k$ 个 tape，我们记每一个 tape 的 $\#run$ 为 $r_i$，则有：

    - $\max\{r_i\} = F^k_j$;
    - $\min\{r_i\} = F^k_{j-1}$;

    也就是说，每个 pass 最大和最小的 $\#run$ 分别有 k 阶 Fibonacci 中相邻的两项。

    > 这里分开用 i 和 j 是想表达这个匹配关系不重要，重要的是最大值最小值由 Fibonacci 相邻项所确定。

    那么夹在最大和最小的中间的其他 $\#run$ 要如何确定呢？首先我们进行一段推导：

    假设 $\{r_i\}$ 经过排序，并且刚好能凑上我们所需要的数量，有：
    
    $$
    r_k > r_{k-1} > ... > r_{2} > r_{1}
    \text{where } r_k = F^k_j \text{ and } r_1 = F^k_{j-1}
    $$
    
    在这一个 pass 中，我们将所有 tape 的前 $r1$ 个 run 拿出来 merge，这样，除了 $r_1$ 这个 tape，其他 tape 的 $\#run$ 都变为 $r_i-r_1$。此时有不等关系：
    
    $$
    r_1 > r_k - r_1 > r_{k-1} - r_1 > ... > r_{2} - r_1
    $$
    
    这里唯一需要说明的就是 $r_1 > r_k - r_1$：

    ??? proof "proof of the relation"
        $$
        \begin{aligned}
            &\begin{aligned}
                \because r_1 
                &= F^k_{j-1} \\
                &= F^k_{j-2} + \cdots + F^k_{j-k} + F^k_{j-k-1}
            \end{aligned}  & (1)\\
            &\begin{aligned}
                \text{and } r_k
                &= F^k_{j} \\
                &= F^k_{j-1} + F^k_{j-2} + \cdots + F^k_{j-k}
            \end{aligned}  & (2)\\
            &\begin{aligned}
                \therefore r_k - r_1 
                &= F^k_{j} - F^k_{j-1} \quad \text{ i.e. } (2) - (1)\\
                &= F^k_{j-2} + \cdots + F^k_{j-k}
            \end{aligned}  & (3)\\
            &\begin{aligned}
                \therefore r_1 - (r_k - r_1)
                &= F^k_{j-k-1} > 0 \quad \text{ i.e. } (1) - (3) \\
            \end{aligned} \\
            &\begin{aligned}
            \therefore r_1 > r_k - r_1
            \end{aligned} \\  
        \end{aligned}
        $$

    如果我们将现在这个排序后的数列记为 $\{r_i'\}$，则有：

    $$
    \left\{
    \begin{aligned}
        r_1' &= r_2 - r_1 \\
        r_2' &= r_3 - r_1 \\
        \vdots \\
        r_{k-1}' &= r_k - r_1 \\
        r_k' &= r_1
    \end{aligned}
    \right.
    $$

    此时根据我们关于最大最小值的陈述，又有：

    $$
    \left\{
    \begin{aligned}
        r_1' &= F^k_{j-2} \\
        r_k' &= F^k_{j-1}
    \end{aligned}
    \right.
    $$

    于是可以推得：$r_2 = r_1 + F^k_{j-2} = F^k_{j-1} + F^k_{j-2}$。关于 $r_3, r_4$，也是一样的办法，将 $r_2$ 的结论迁移到 $r_2'$，再回过头得到 $r_3 = r_1 + r_2'= F^k_{j-1} + F^k_{j-2} + F^k_{j-3}$，以此类推，可以得到最终结论：

    $$
    \left\{
    \begin{aligned}
        r_1 &= F^k_{j-1} \\
        r_2 &= F^k_{j-1} + F^k_{j-2} \\
        r_3 &= F^k_{j-1} + F^k_{j-2} + F^k_{j-3} \\
        \vdots \\
        r_k &= F^k_{j-1} + F^k_{j-2} + ... + F^k_{j-k} = F^k_{j}
    \end{aligned}
    \right.
    $$
 
!!! question "思考题"
    可以感受思考一下这个特性（考虑 2-way 即可）与黄金比例的关系！

    hint: 如何理解 $\frac{a_n}{a_{n-1}} \approx \frac{a_{n-1}}{a_n - a_{n-1}}$ 与这个性质的关系？

当然，刚好能凑上 Fibonacci 的情况自然是少数，对于无法凑上 Fibonacci 的情况，我们可以将多余的部分均匀的分到较多若干 tape 上，以相对的利用 Fibonacci 数列的性质（联系思考题理解）。

!!! warning "注意"
    或许你已经开始产生疑问了，如果这样来做，前面对 $\#pass$ 的分析是不是不成立了呢？

    我想应该确实不再完全一样了，但是并不影响我们之后利用那个结论做定性分析，我们只需要知道，采取 Fibonacci 策略来优化会导致 $\#pass$ 增多即可。

---

### k 路内排序优化

随着 $k$ 的增加，我们不能再像两路归并那样直接输出较小的那个，而是需要维护数据结构来总是输出 k 个中最小的那个——我们用堆来维护每一个 run 在内存中的数据的队首元素（同时也是最小元素），每当堆顶元素被输出，就需要从对应的 run 中读入下一个元素。

!!! warning "注意"
    需要注意，这里的堆是额外维护的，而每次推入堆中的元素都是从对应的 run 的 buffer 中拿的，而不是每次都从硬盘中拿。

---

#### 霍夫曼树优化

当然，我们也可以不使用直接 $k$ 路合并，而是采用两两归并的方法，也就是 wiki 中提到的[迭代归并](https://en.wikipedia.org/wiki/K-way_merge_algorithm#Iterative_2-way_merge)（注意，该条目中提到的归并并没有说明是外排序背景，但是可以迁移）。 

假设我们现在有若干个 run，并且我们将要进行两两归并，那么我们可以根据每一个 run 的大小，根据霍夫曼树的规律来进行归并，即总是选最小的两个进行归并。

---

### 并行优化

这里并行的目标主要是使算法支持数据的读-用-写的流水线，也就是说我们要想办法让读不阻塞用，用不阻塞写。

先前我们需要先读入数据，**然后**进行排序，排序**完了**再写入磁盘，腾出内存空间以供下一次读入。那为什么会阻塞呢？因为我们没法读一个正在写的数据块，所以我们只需要在不同的数据块读和写就行了。对于 $k$-way 中的每一路，我们都提供两个 input buffer，一个用于写，一个用于排序。当排序 buffer 空了的时候，就和读满了的 input buffer 交换，无缝衔接继续输出。于此同时，刚刚被交换过去的 buffer 则可用于继续读入。

因此，如果我们执行 direct $k$-way merge，就需要 $2k$ 个 input buffer（这里强调 direct 是因为，如果使用 iterative 的话，input buffer 只需要 4 个）。

而对于输出，我们只需要 2 个 output buffer 交替使用即可，一个用来接收来自排序算法的输出，一个用来将数据写入磁盘。

但是，并行优化的缺点就是占据了更多的内存空间——原先 $k + 1$ 个 buffer 平分的用于处理数据的内存，现在需要被 $2k + 2$ 个 buffer 平分，所以每一个 buffer 的大小会变小。进而导致每一次从 disk 中读取的数据变少，所以要读完数据所需要的读取次数就增加，即 seek 次数增加。
