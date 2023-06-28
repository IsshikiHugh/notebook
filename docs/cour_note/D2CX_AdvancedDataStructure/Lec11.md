# Lecture 11 | Approximation

## 近似算法

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Approximation_algorithm


在上一章中我们介绍了 P/NP 问题，而大家普遍认为 P ≠ NP，这就意味着对于某些问题，我们无法使用多项式时间解决，而在问题规模变大时，越发不可接受。

因此，我们考虑能否退而求其次，在多项式时间内求一个**比较优**的解。更具体的来说，我们尝试寻找一种多项式算法，使得其结果始终在关于准确解的可接受偏差范围内，对于这种算法，我们称之为**近似算法(approximation algorithm)**。

我们设 $f(n, x)$ 是对输入大小为 $n$ 的情况下，对结果 $x$ 的**最坏情况**的一个直观量化（例如 dist, weight...），若设 $x^*$ 为准确解，$x$ 为给定算法结果，则我们定义**近似比(Approximation Ratio)**$\rho$：

$$
\forall n \rho = \max\{\frac{f(n, x)}{f(n, x^*)}, \frac{f(n, x^*)}{n, f(x)}\}
$$

则称给定算法为 $\rho$ 近似算法($\rho$-approximation algorithm)。

!!! question "近似算法 v.s. 随机算法"
    在看到近似算法时，我脑子里一下子浮现出了[随机算法](./Lec13.md)的概念，同样是求准确解的近似解，两者有何区别呢？

    ??? key-point "hint: 最坏情况"
        近似算法和随机算法最大的区别就是，当我们设计、分析、讨论近似算法的时候，**我们关注的都是它的最坏情况**。也就是说，近似算法是完全可控的，而纯粹的随机算法则是通过概率来减少坏情况出现的可能，并没有严格的约束。近似算法最坏也就坏到 $\rho$，而随机算法最坏可以坏到海拉鲁大陆。

---

### 近似范式

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Polynomial-time_approximation_scheme

**近似范式(approximation scheme)**指的是对于某个优化问题的一族相同模式的算法，它们满足对于确定的 $\epsilon > 0$，算法的近似比为 $1+\epsilon$。

> 可以粗糙地理解为：“范式”是一个输出为算法的特殊函数，而 $\epsilon$ 是“范式”的一个参数，对于特定的 $\epsilon$，“范式”输出一个特定的算法（这些算法有着相同的模式），而这些“范式”输出的算法，都解决同一个问题，并且对于任意固定的 $\epsilon$ 其近似比为 $1+\epsilon$。
>
> 而关于 $\epsilon > 0$ 这个约束，是因为近似比必定大于 1。

而此时，这一族的算法的复杂度可以表示为 $O(f(n, \epsilon))$，如 $O(n^{2/\epsilon}), O((\frac{1}{\epsilon})^2n^3)$。当 $f(n, \epsilon)$ 关于 $n$ 是多项式时，我们称其为**多项式时间近似范式(polynomial-time approximation scheme)PTAS**。当 $f(n, \epsilon)$ 关于 $n$ 和 $\frac{1}{\epsilon}$ 都是多项式时，我们称其为**完全多项式时间近似范式(fully polynomial-time approximation scheme)FPTAS**。

为什么要区分 PTAS 和 FPTAS 呢？我们观察 $\epsilon$ 对算法的影响：随着 $\epsilon$ 的减小，近似比逐渐变小，即准确度提高；而 $\frac{1}{\epsilon}$ 变大，而通常来说 $\frac{1}{\epsilon}$ 与算法复杂度都是正相关的，因此会导致算法复杂度升高。如果说这个近似范式是 FPTAS，那么为了提高准确度而缩小 $\epsilon$，导致的复杂度变化是相对可接受的（多项式级的变化，如 $(\frac{1}{\epsilon})^2n^3$ 关于 $\frac{1}{\epsilon}$ 是多项式级的）；然而如果它不是 FPTAS，那么 $\epsilon$ 的缩小可能带来恐怖的复杂度增加（如 $n^{2/\epsilon}$ 关于 $\epsilon$ 是指数级的）。

---

!!! note ""
    接下来，我们以若干具体例子做分析，以便更好地理解近似算法。

---

## [案例] Approximate Bin Packing

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Bin_packing

装箱问题指的是，给定 $N$ 个 item，第 $i\in [1,N]$ 个 item 的 size 为 $S_i \in (0,1]$，一个 bin 的大小为 $1$，尝试寻找最少的，能够装载所有 item 的 bin 的数量。

??? eg "🌰 例子"
    给定 7 个 item，size 分别为 $0.2, 0.5, 0.4, 0.7, 0.1, 0.3, 0.8$，则最少需要 3 个 bin（准确解）：

    - bin 1: $0.2 + 0.8$;
    - bin 2: $0.7 + 0.3$;
    - bin 3: $0.4 + 0.1 + 0.5$;

这是一个 NP hard 问题，现在我们考虑三种近似解法。需要注意的是，这三种都是**在线(online)**解法，即处理 $item_i$ 时我们不知道 $item_{i+1}\sim item_{N}$ 的情况。之后我们会再讨论**离线(offline)**做法，也就是我们知道所有 item 的情况以后再给出策略。

---

### (online) Next Fit (NF)

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Next-fit_bin_packing

NF 策略总是选择当前最后一个 bin，若能够容纳，则将当前 item 放入其中，否则新开一个 bin。

NF 策略总是使用不超过 $2M-1$ 个 bin，其中 $M$ 表示准确解的 $\#bin$。

??? proof "proof for 2M-1"
    我们从 NF 的结果出发，证明当 NF 的结果为需要 $2M-1$ 或 $2M$ 个 bin 时，准确解为至少需要 $M$ 个 bin。

    假设 $S(B_i)$ 表示第 $i$ 个 bin 的 size，则根据 NF 的定义，有：$S(B_{i}) + S(B_{i+1}) > 1$（是 NF 的必要不充分条件）。稍作解释，使用反证法，假设 $S(B_{i}) + S(B_{i+1}) \leq 1$，这说明无论 $B_{i+1}$ 中有多少 item，都一定能放进 $B_i$，而这与 NF “$B_i$ 放不下了才开始放 $B_{i+1}$” 的性质相违背。于是我们将所有桶两两配对：

    1.当 NF 的结果是需要 $2M-1$ 个 bin 时：

    $$
    \left\{
    \begin{aligned}
        S(B_1) + S(B_2) &> 1 \\
        S(B_3) + S(B_4) &> 1 \\
        \vdots \\
        S(B_{2M-3}) + S(B_{2M-2}) &> 1 \\
        S(B_{2M-1}) &\leq 1
    \end{aligned}
    \right. \\
    \begin{aligned}
        &\therefore \sum_{i=1}^{2M-1} > \sum_{i=1}^{2M-2} > M-1 \\
        &\therefore \sum_{i=1}^{2M-1} \geq M
    \end{aligned}
    $$

    即 item 的总 size 至少为 M，即至少需要 $M$ 个 bin。

    2.而当 NF 的结果是需要 $2M$ 个 bin 时，可以转化为 $2M-1$ 的情况。

---

### (online) First Fit (FF)

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/First-fit_bin_packing

FF 策略总是选择第一个能放下当前 item 的 bin，若所有 bin 都无法容纳当前 item，则新开一个 bin。

NF 策略总是使用不超过 $\lfloor 1.7M \rfloor$ 个 bin，并且存在一族能对边界取等的输入，其中 $M$ 表示准确解的 $\#bin$。

---

### (online) Best Fit (BF)

!!! quote "links"
    Wikipedia: https://en.wikipedia.org/wiki/Best-fit_bin_packing

BF 策略总是选择能够容纳当前 item 且剩余空间最小的 bin（即 tightest），若所有 bin 都无法容纳当前 item，则新开一个 bin。

NF 策略也总是使用不超过 $\lfloor 1.7M \rfloor$ 个 bin，并且存在一族能对边界取等的输入，其中 $M$ 表示准确解的 $\#bin$。

---

> 虽然在线做法由于对信息把握的不全面，在不特殊构造输入的情况下甚至几乎不可能达到最优解，但是现实世界中有很多能建模为装箱问题的问题，都要求使用在线做法解决。因此，研究在线做法还是有其意义的。

此外，关于在线做法，有一个结论：

!!! property "theorem"
    对于装箱问题，如果限定使用在线做法，则**最优**的近似解法，其**最坏情况**的结果也至少需要准确解的 $\frac{5}{3}$。

    > PPT 上的原话是，无论哪种在线做法也至少需要使用 $\frac{5}{3}$ 的准确解给出的数量，但是显然这个 $\frac{5}{3}$ 是针对最坏解的讨论。回顾「近似算法 v.s. 随机算法」这个 block 里的内容，我们分析近似解，都是针对其最坏情况来说的。

---

### (offline) First Fit Decreasing (FFD)

离线做法的优势在于它能够获得所有 item 的信息以求统筹规划。这里给出的近似做法是，将 item 按照 size 降序排序，而后使用 FF（或 BF，由于单调性，两者等价）。

??? eg "🌰 例子"
    给定 7 个 item（同之前的 🌰），经过排序后，它们的 size 分别为 $0.8, 0.7, 0.5, 0.4, 0.3, 0.2, 0.1，则最少需要 3 个 bin（准确解）：

    - bin 1: $0.8 + 0.2$;
    - bin 2: $0.7 + 0.3$;
    - bin 3: $0.5 + 0.4 + 0.1$;

FFD 策略总是使用不超过 $\frac{11}{9}M + \frac{6}{9}$ 个 bin（为啥就连 wiki 也不约 6/9），并且存在一族能对边界取等的输入，其中 $M$ 表示准确解的 $\#bin$。

---

## [案例] Knapsack Problem

!!! quote "link"
    Wikipedia: https://en.wikipedia.org/wiki/Knapsack_problem

一个与装箱问题很像的问题是背包问题。其大致描述如下：给定一个容量为 $M$ 的背包，以及 $N$ 个 item，第 $i$ 个 item 的重量为 $w_i$，其利润为 $p_i$。要求在不超过背包容量的前提下，使得背包中的利润最大化。（我也不知道为什么 PPT 上会把容量和重量关联起来，anyway，容量限制了 item 的重量和。）

!!! warning "注意"
    或许在学习 dp 的时候你已经接触过背包问题了，但是请注意，我们这里讨论的背包问题有一个非常重要的特点就是，容量和利润都是**实数**，更直白的来说，你没办法通过将容量或利润作为状态来 dp 求解。

而根据每一个物品能否自由拆分，背包问题分为 fractional version 和 0-1 version 两类。

---

### Fractional Version

如果我们记 $x_i\in[0,1]$ 为第 $i$ 个 item 的选中量（即假设 item 都是连续可分的），则约束条件可以表述为 $\sum_{i}^N w_ix_i \leq M$，现在求 $\sum_{i}^{N} p_ix_i$ 的最大值。

??? eg "🌰 例子"
    假设现在 $M = 20.0$，并且 $N = 3$，分别是：

    - item 1: $w_1 = 18.0, p_1 = 25.0$; 
    - item 2: $w_2 = 15.0, p_2 = 24.0$;
    - item 3: $w_3 = 10.0, p_3 = 15.0$;

    则最优解为 $x_1 = 0, x_2 = 1, x_3 = \frac{1}{2}$，此时 $\sum_{i}^{N} p_ix_i = 31.5$。

由于 $x_i\in[0,1]$，给了我们极大的选择自由，我们可以选择任意多的某个物品。那么非常朴素的一个想法就是，尽可能多地选择“性价比”高的物品。也就是说，我们可以按照 $\frac{p_i}{w_i}$（PPT 称之为 profit density）降序排序，而后从大到小依次选择物品，直到背包装满为止。

不过该做法已经是准确解了，所以我们不对它进行关于近似算法的讨论。

---

### 0-1 Version

相较于 fractional version，0-1 version 要求 $x_i \in \{0,1\}$，换句话说每一个物品要么选要么不选。这是一个经典的 NPC 问题，我们尝试使用近似算法来求较优解。

---

#### 贪心做法

我们可以使用贪心算法，贪心策略可以是总是选可以放得下的、还没放入中的，**利润最大**的或 $\frac{p_i}{w_i}$ **最大**的。这些做法的近似比都是 2。

??? proof "proof for rho = 2"
    我们用 $p_\text{max}$ 表示所有 item 中最大的利润，用 $P_\text{optimal}$ 表示准确解，$P_\text{greedy}$ 表示我们使用贪心做法得到的答案。在该问题中，近似比的计算表达式为：

    $$
    \rho = \max(
        \frac{P_\text{optimal}}{P_\text{greedy}},
        \frac{P_\text{greedy}}{P_\text{optimal}}
    )
    $$

    下面是证明过程：

    $$
    \left\{
    \begin{aligned}
        & p_\text{max} \leq P_\text{greedy} & (1)\\
        & P_\text{optimal} \leq P_\text{greedy} + p_\text{max} & (2)
    \end{aligned}
    \right.
    $$

    将 $(1)$ 式两侧同除以 $P_\text{greedy}$ 得：

    $$
    \frac{p_\text{max}}{P_\text{greedy}} \leq 1 \quad (3)
    $$

    将 $(2)$ 式两侧同除以 $P_\text{greedy}$，并代入 $(3)$ 得：

    $$
    \frac{P_\text{optimal}}{P_\text{greedy}} \leq 1 + \frac{p_\text{max}}{P_\text{greedy}} \leq 2
    $$

    > PPT 的证明过程中还有一个不等式，虽然成立，但是好像没起到作用，我就扩展一下写在这里求个眼熟了：
    > 
    > $$
    > p_\text{max} \leq P_\text{greedy} \leq P_\text{optimal} \leq P_\text{frac}
    > $$
    > 
    > 其中 $P_\text{frac}$ 指的是同样的数据下 fractional version 的答案。

> 补充结论：背包问题具有 FPTAS。

---

#### 动态规划做法



---

## [案例] The K-center Problem