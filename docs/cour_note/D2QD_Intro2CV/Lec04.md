# Lecture 4 | Model Fitting and Optimization

!!! warning "注意"
    本文尚未整理好！

## 优化 

首先我们来定义一个 **优化(Optimization)** 问题的模型：

!!! info ""
    设 **目标函数** $f_0(\vec x)$ 满足 **约束条件**：
    
    $$
    \left\{
    \begin{array}{ll}
        &f_i(\vec x) \leq 0,  &i = 1,...,m & \text{inequality constraint functions} \\
        &g_i(\vec x) = 0,  &i = 1,...,p & \text{equality constraint functions}&
    \end{array}
    \right.
    $$

    求 $\vec x\in \mathrm{R}^n$ ，使 $f_0(\vec{x})$ 最小（即最优）。
    
> 很显然，这和我们高中接触的线性规划很像，实际上线性规划就是其中一种优化问题。

而接下来，我们需要尝试将一些复杂问题转化为优化问题，即根据问题，写出目标函数和约束条件，并通过一些方法来得到我们需要的 $\vec x$。


!!! example "🌰 图像去模糊问题"
    在这个 🌰 中，我们已知模糊图像 $Y$ 和模糊滤波器(卷积核) $F$，需要通过优化的方法来求卷积运算之前的清晰图像 $X$。

    进一步来说，就是找到清晰的图像 $X$，使得它做模糊处理后与已知的模糊图像 $Y$ 差别尽可能小，于是问题转化为：

    - 目标函数为 $\min\limits_{X} || Y - F * X ||^2_2$ 的优化问题。

---

### 模型拟合 

为了研究分析实际问题，我们需要对问题进行一个建模，更具体的来说就是根据实际情况，寻找数据之间的关系，并建立数学模型。

一个数学 **模型(model)** 描述问题中输入和输出的关系，例如：线性模型(linear model) $b = a^T x$ 就描述了输入(input) $a$ 和输出(output) $b$ 关于模型参数(model parameter) $x$ 的关系。

而实际的结果很难严格满足数学模型，这是由多方原因导致的，所以我们往往做的是对实际情况进行 **模型拟合(model fitting)**。

更具体的来说，我们可能已经有一个先验的假设，即数据符合哪种模型，接下来根据数据来分析得到合适的 model parameters，而这个步骤也常常被称为 learning。

一种比较经典的逼近方法（[最小二乘法](https://zh.wikipedia.org/wiki/%E6%9C%80%E5%B0%8F%E4%BA%8C%E4%B9%98%E6%B3%95)）是求使 **[均方误差(mean square error)MSE](https://zh.wikipedia.org/wiki/%E5%9D%87%E6%96%B9%E8%AF%AF%E5%B7%AE)** 最小的 model parameters：

$\hat{x} = \mathop{\arg min}\limits_x \sum\limits_i(b_i - a_i^Tx)^2$

而如果我们假设数据中的噪声是高斯分布的（实际上大部分噪声在基数足够大的情况下都可以看作为高斯分布的），那么可以与统计学的 **极大似然估计(maximum likelihood estimation)MLE** 相统一.

!!! tip "MSE vs. MLE"
    [MSE vs MLE for linear regression](https://medium.com/analytics-vidhya/mse-vs-mle-for-linear-regression-f4ce3f6b990e)

具体来说，$b_i = a_i^T x + n, \;\; n \sim G(0,\sigma)$，而对于给定的 $x$，其 **似然(likehood)** $P[(a_i,b_i)|x] = P[b_i-a_i^Tx] \propto \exp - \frac{(b_i-a_i^Tx)^2}{2\sigma^2}$，表示在 model parameter 为 $x$ 的情况下，数据符合 $(a_i,b_i)$ 的可能性。

!!! note "Maximum Likelihood Es(ma(on"
    <!--Copy from https://github.com/sakuratsuyu/Note/blob/master/docs/Computer_Science_Courses/ICV/4_Model_Fitting_and_Optimization.md?plain=1-->
	If the data points are **independent**,
	
	$$
	\begin{align}
	P[(a_1, b_1)(a_2, b_2)\dots|x] & = \prod\limits_iP[(a_i, b_i)|x] = \prod\limits_iP[b_i - a_{i^{Tx]}} \\
	& \propto \exp\left(-\frac{\sum_i(b_i - a_i^Tx)^2}{2\sigma^2}\right) = \exp\left(-\frac{||Ax-b||^2_2}{2\sigma^2}\right)
	\end{align}
	$$
	
    That is, maximize the likelihood to find the best $x$.

	$$
	\begin{align}
	\hat x &= \mathop{\arg max}\limits_x P[(a_1, b_1)(a_2, b_2)\dots|x] \\ &= \mathop{\arg max}\limits_x \exp\left(-\frac{||Ax-b||^2_2}{2\sigma^2}\right) 
	= \mathop{\arg min}\limits_x||Ax - b||_2^2
	\end{align}
	$$

!!! tip "MSE = MLE with Gaussian noise assumption"

!!! question "需要补数学知识，完善这部分内容"

---

## 数值方法

上一小节介绍了如何对实际问题进行数学建模，接下来需要介绍的是如何求解数学模型。

我们知道，对于一些比较简单的模型，我们可以直接求其 **解析解(analytical solution)**，比如使用求导等方法。

!!! example "🌰"
    以刚才的线性 MSE 为例，$\hat{x} = \mathop{\arg min}\limits_x \sum\limits_i(b_i - a_i^Tx)^2$ 等效于求解等式 $A^TAx=A^Tb$。

然而，实际情况是大部分问题过于复杂，我们没法直接求其解析解，所以我们需要采用一些即采用一些 **数值方法(numerical methods)**。

---

### 梯度下降

![](56.png){ width=300px align=right }
> Sourece: https://commons.wikimedia.org/w/index.php?curid=2283984

> 由于相关领域的“函数”等基本上都是高维的，所以我们一般使用二维函数图像的方法来形象表示函数，即使用“等高线”的形式来可视化函数。

虽然没法直接求解析解，但是一般函数都具有一些局部性质，例如极值点临域的梯度都指向极值点。模糊地来说，只要我们随着“梯度”去“下降”，就有可能找到极值点，这就是通过 **梯度下降(gradient descent)** 的方法来解决优化问题。

简单描述梯度下降的过程：

1. 初始化起点坐标 x；
2. 直到 x 收敛到我们满意的程度之前：
   1. 计算下降方向 p；
   2. 决定下降步长 ⍺；
   3. 更新 x = x + ⍺p；

其中有三件事需要特殊说明：

- 如何确定下降方向 $\vec p$
- 如何确定下降步长
- 最值与极值

#### 确定下降方向

对于我们以前接触过的函数，即形式相对简单的函数，我们当然可以直接求其梯度得到下降方向。然而实际问题中的函数可能非常复杂，或梯度很难得到。这时候我们就只能退而求其次，求其“近似”梯度方向。换句话来说，我们希望能够找到一个和原函数在局部和该函数很像的拟合函数，并且用这个拟合函数的梯度方向来决定梯度下降的方向。

于是我们想到泰勒展开，它将函数展开为多项式，而多项式的梯度是相对容易得到的。

其中比较常用的是：

- first-order approximation: $F(x_k + \Delta x) \approx F(x_k) + J_F \Delta x$
- second-order approximation: $F(x_k + \Delta x) \approx F(x_k) + J_F\Delta x + \frac{1}{2}\Delta x^T H_F \Delta x$

其中 $J_F$ 是 [雅各比矩阵](https://zh.m.wikipedia.org/wiki/%E9%9B%85%E5%8F%AF%E6%AF%94%E7%9F%A9%E9%98%B5)，可以理解为多维向量函数的导数；$H_F$ 是 [海森矩阵](https://zh.m.wikipedia.org/zh-hans/%E9%BB%91%E5%A1%9E%E7%9F%A9%E9%99%A3)，可以理解为多位向量函数的二阶导数。

接下来以 first-order approximation 为例继续分析。

观察 $F(x_k + \Delta x) \approx F(x_k) + J_F \Delta x$，发现当 $J_f\Delta x < 0$ 时， $F(x_0 + \Delta x)$ 大概率会比 $F(x_0)$ 小，即“下降”，所以在 first-order approximation 的情况下，一般选择方向 $\vec p = -J_F^T$，即 **最速梯度下降法(steepest descent method)**。

#### 确定下降步长

即使但从下降速率来考虑，步长太长或太小也都有明显的问题：

![](70.png)

所以步长的选择对下降速率的十分关键。

- 确定步长：
    - 理论最优：使 $\phi(\alpha) = F(x+\alpha h)$ 最小的 $\alpha$
    - Backtracking algorithm 的方法：设置较大的 $\alpha$ 初值，不断减小到使 $\phi(\alpha) \leq \phi(0) + \gamma\phi'(0)\alpha,\;\; 0 <\gamma < 1$ 成立。
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
    - 然而 $J_R^TJ_R$ 不是正定的，即未必可以求逆，所以我们使用Levenberg-Marquardt 算法，即 LM 算法，将 $J_R^TJ_R$ 修正为$$J_R^TJ_R$ + \lambda I$ 以保证正定；

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
