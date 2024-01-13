# Lecture 9 | Greedy Algorithms

~~果然越来越宽泛了~~

## 概念

> **贪心算法(Greedy Algorithms)**是一种在求解优化问题时采用的策略，它在每个决策阶段都选择当前看起来最优的解决方案，从而希望能够达到全局最优解。贪心算法的核心思想是局部最优选择，通过一系列局部最优的选择，来达到全局最优的目标。贪心算法易于实现，但并不总是能够得到全局最优解，因此在使用贪心算法时需要分析问题的特性以确保其适用性。
>
> ——ChatGPT

贪心思想和它的名字一样简单暴力，就是在每一个步骤中都采取局部最优解，最终求得最优解。但是显然这个方法并不总能“最终求得最优解”。因此虽然这个方法看起来直接暴力，但是如何找到用「贪心」解决问题的路径，往往是需要动动脑子的。

和 dp 一样，贪心是一个比较思想性质的东西，所以我们需要借助许多案例来进行分析。

---

### [案例] Activity Selection Problem

在课件上，**活动选择问题(Activity Selection Problem)**的陈述如下：

!!! definition "Activity Selection Problem"
    > Given a set of activities $S = { a_1, a_2, ..., a_n }$ that wish to use a resource (e.g. a classroom).  Each $a_i$ takes place during a time interval $[s_i, f_i)$.
    > 
    > Activities $a_i$ and $a_j$ are compatible if $s_i \geq f_j$ or $s_j \geq f_i$ (i.e. their time intervals do **not overlap**).

    > **Goal:** Select a maximum-size subset of mutually compatible activities.

    > - Assume $f_1\geq f_2 \geq ... \geq f_n$.

    抽象来说就是一个一维的密铺问题。给定时间线上的若干区间 $[s_i, f_i)$，求出最多能不重叠地在这个时间线上放置多少个区间。题目额外保证了输入数据是根据 $f_i$ 有序的，不过这不是很重要。

!!! not-advice "bad try 1"
    一个非常 naive 的想法就是，哪门课先开始我先选哪门课，这个想法非常的节省脑细胞，但是显然不对。我随随便便来个最早开始最晚结束的课，就能直接 hack 掉这个方法。

!!! not-advice "bad try 2"
    再来一个天真的想法，我每次都选区间长度最少的，虽然看起来能让它“相对比较多”，但是显然也无法保证结果的最优性，也非常好 hack。

!!! not-advice "search"
    而另外一个暴力的想法就是，我去枚举每一种可能，也就是我们俗称的暴搜，还可以用上剪枝等操作，虽然可以，但是太不优雅了，而且时间复杂度未必是我们能接受的。

!!! advice "dp"
    既然暴搜不行，那试试 dp 呢？在这个问题中，我们可以写出如下转移方程：

    $$
    dp_i = \left\{
        \begin{aligned}
            &1 & i = 1 \\
            &\max\{
                dp_{i-1},
                dp_{f(i)} + 1
            \} & i > 1
        \end{aligned}
    \right.
    $$

    其中，$dp_i$ 表示到第 $i$ 个区间截止的时间为止，最多有多少个项目可以被安排；$f(i)$ 是最大的满足 $f_j \leq s_i$ 的区间的编号 $j$，也就是能够不重叠放下的，最晚的那个活动。

    我们发现，这么做是可以的。只不过这样做的话，其时间复杂度为 $O(N^2)$。

!!! advice "greedy"
    显然，这个案例放在这个地方肯定是有贪心解的。而且题目的 “Assume” 提示性已经很强了。我们只需要按照结束时间，遍历这些区间，能塞下就塞，即可 $O(N)$ 贪心求解。

TODO: