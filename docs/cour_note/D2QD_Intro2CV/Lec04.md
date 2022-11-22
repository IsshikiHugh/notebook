# Lecture 4 | Model Fitting and Optimization

!!! warning "注意"
    本文尚未整理好！

优化 Optimization

- 目标函数
- 约束条件
- 求目标函数的最优化

一种特殊情况：线性优化（规划）

eg：图像去模糊问题

模糊 -> 清晰

$$
\min_{X} ||Y-F*X||^2_2\\
\text{ where Y is the blurred image, F is the blur kernel and X is the sharp image}
$$

---

模型拟合 Model Fitting

一个数学模型描述问题中输入输出的关系

构成：

- 输入
- 输出
- 参数

最小二乘法

均方误差 / Mean Square Error / MSE

$\argmin$


Maximum likelihood Estimation 极大似然估计

- Details

如果我们假设噪声是高斯分布的，那么可以与统计学的极大似然估计统一

---

数值方法 Numerical methods

给定优化问题，如何求最优解

- 求解析解（比如通过求导）
    - 以刚刚的线性 MSE 为例

然而大部分问题我们没法求解析解

- 梯度下降 GD
    - 确定下降方向 p ：
        - 局部范围内可以让我值下降；
        - 如果形式简单，可以直接求解析解；
        - 在局部去逼近函数，使用泰勒展开，雅可比矩阵&海森矩阵；
            - $F(x_k+\Delta x) \approx F(x_k) + J_F \Delta x + \frac{1}{2}\Delta x^TH_F\Delta x$；
        - 使用一阶导数来决定减小方向：
            - Taypor expansion at $x_0$: $F(x_0+\Delta x) \approx F(x_0) +J_F\Delta x$；
            - 当 $J_F\Delta x < 0$ 时，此函数会减小。
            - 于是当 $Delta x$ 的方向与 $-J_F^T$ 相同时候，能快速下降；
            - 这种方法即 最速梯度下降法（Steepest descent method）
    - 确定步长：
        - 理论最优：使 $\phi(\alpha) = F(x+\alpha h)$ 最小的 $\alpha$
        - Backtracking algorithm 的方法：设置较大的 $\alpha$ 初值，不断减小直到使 $\phi(\alpha) \leq \phi(0) + \gamma\phi'(0)\alpha,\;\; 0 < \gamma < 1$ 成立。
        - 改进：一阶近似不够好，所以使用二阶近似，即牛顿法；
          - 二阶泰勒展开得到 $F(x_k+\Delta x) \approx F(x_k) + J_F \Delta x + \frac{1}{2}\Delta x^TH_F\Delta x$；
          - 对它求导得到 $\frac{\partial F}{\partial \Delta x} = J_F^T+H_F\Delta x = 0$;
          - 于是最佳的 $\Delta x = -H_F^{-1}J_F^T$；
          - 优点：下降快；
          - 缺点：难解；
              - 如何解决计算量大的问题：
                  - 根据实际问题决定
        - Gauss-Newton method
            - 最小二乘，找一阶倒的平方做近似，得到最佳的 $\Delta x = -(J_R^TJ_R)^{-1}J_R^TR(x_k)$；
            - 优点就是没有海森矩阵，只有雅可比矩阵；
            - 本方法的特点是，使用 $(J_R^TJ_R)^{-1}R(x_k)$ 来近似了海森矩阵的逆；
            - 但是成立的前提是函数的形式是最小二乘的形式；
        - 然而 $J_R^TJ_R$ 不是正定的，即未必可以求逆，所以我们使用 Levenberg-Marquardt 算法，即 LM 算法，将 $J_R^TJ_R$ 修正为 $$J_R^TJ_R$ + \lambda I$ 以保证正定；

对于带约束的优化问题，需要 **根据实际问题** 求解。

局部最优和全局最优

- 可能转化问题，使用更简单的表达式去拟合原来的表达式，来求解；
- 其中，（凹）凸函数是一定能找到最优解的，我们称这种问题为凸优化问题(Convex optimization)(推荐同名读物https://web.stanford.edu/class/ee364a)
  

## 鲁棒估计 Robust estimation

inlier / outliers i.e. 内点 / 外点

- 前者指符合我们的预期模型拟合的点；
- 外点为完全不符合我们预期的模型拟合的点；

由于外点偏离很大，而最小二乘法中存在平方操作，所以最小二乘法拟合收这些外点影响很大

于是我们考虑，更换拟合的目标函数，比如使用 L1 loss(即求绝对值)，不过更好的是一种叫 huber loss，它在距离远点较远的时候比较接近 L1 loss；

另外一种方法是 RANSAC，即 Random Sample Consensus，随机采样一致；

RANSAC procedure:

- 首先随机找两个点拟合一条直线，然后检查有多少点符合这条直线，并对其进行 vote；
- 重复这个步骤，最后选择票数最高的拟合；

正确性证明：

- 首先有结论，outlier拟合出来的直线一般votes比较少，因为outlier之间很难一致，但是inlier之间容易一致；

## 病态问题(ill-posed problem)

- 如果一个问题的解不唯一，那么这个问题是一个病态问题；
- 在线性问题中，一个线性方程的解不唯一，则同样是一个病态问题；

解决办法：

- 增加方程，即增加约束，而这种约束一般来自于对变量的先验约束；
- L2 regularization
    - 可以让我们没有用的解尽可能接近0，以减小没用的变量的影响
    - 抑制冗余变量
- L1 regularization
    - L1 可视化中可以发现，坐标轴上比较容易抓住解，此时意味着有些变量是0，换句话来说能让解变得“稀疏sparse”，即在维度上的分布比较集中

不过，将他们作为约束条件参与求解，不如直接加进去作为一个项，其效果是等价的

$$
\min_{x}||Ax-b||^2_2+\lambda ||x||_2^2  (或者\lambda ||x||_1)\\
s.t. ||x||_2 \leq 1
$$

Overfitting and underfitting 过拟合和欠拟合


## Interpolation

线性拟合、二次样条插值（每一段都是一个二次函数）、三次样条插值（一阶导二阶导连续，但最终是个病态问题，需要额外再约束起点和终点二阶导为零或者限定给定斜率等，就需要俩额外约束条件）、


上面是连续优化问题，下面是离散优化问题

## Graphcut图割 and MRF马可夫随机场

- image labeling problems
    - 强先验：相邻pixel的label很可能相同，关键在于如何建模这种空间连续性
        - 实现：用图(graph)来描述图片，假设每个像素都是一个node，像素之间建edge，以相似性或关联性作为边权；
        - 一般这个权重为 
            - 例如，$f$ 是颜色，则：
            - 像素差异为 $s(f_i,f_j)=\sqrt{\sum_k(f_{ik},f_{jk})^2}$
            - 则相似性权重 affinity $w(i,j) = A(f_i,f_j) = e^{\frac{-1}{2\sigma^2}s(f_i,f_j)}$；
        - 然后做图割问题，割成两个图，图割的代价为断的边权之权重和 $cut(V_A,V_B)= \sum_{u\in V_A, v\in V_B} w(u,v)$；
            - 这个问题等效于最大流问题；
        - 但这样的分割也是有问题的，所以可能不太联通的两个点被分在了一起；
        - 我们还需要衡量这个子集是否足够稠密 (normalized cut)

- Markov Random Field （更通用）
    - Markov chains
    - 听不懂
