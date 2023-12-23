# [7.x] 参数估计

## 点估计

设总体 $X$ 的分布函数为 $F(x;\theta)$，$\theta=(\theta_{1},\theta_{2},...,\theta_{k})$ 是未知的待估参数，$X_1,X_2,...,X_n$ 是 $X$ 的一个样本。点估计就是要对每一个未知参数 $\theta_{i}$ 构造一个适当的统计量 $\hat{\theta_{i}}=\theta_{i}(X_1,X_2,...,X_n)$，用作对未知参数 $\theta_{i}$ 的估计，称为 $\theta_{i}$ 的**估计量**。

若已知样本的观察值为 $x_1,x_2,...,x_n$，则称 $\hat{\theta_{i}}=\theta_{i}(X_1,X_2,...,X_n)$ 为 $\theta$ 的一个**估计值**。

### 矩法

思想：用样本矩去估计相应的总体矩，换言之，用原点矩 $A_k$ 去估计 $\mu_{k}$，用中心距 $B_k$ 去估计 $\nu_{k}$。

具体步骤如下（假设有 $k$ 个待求未知参数）：

1. 列出总体的前 $k$ 阶矩<br />
   $\mu_{i}=E(X^i)=h_i(\theta_{1},\theta_{2},...,\theta_{k})\;\;,\;\;i=1,2,...,k$；
2. 从方程组中解出这 $k$ 个参数<br />
   $\theta_{i}=g_i(\mu_{1},\mu_{2},...,\mu_{k})\;\;,\;\;i=1,2,...,k$；
3. 将上一步解出的参数的表达式中出现的总体矩用相应的样本矩替换<br />
   $\hat{\theta_{i}}=g_i(A_{1},A_{2},...,A_{k})\;\;,\;\;i=1,2,...,k$；

值得注意的是：

- 如果方程中存在恒等式，则可以顺延求 $\mu_{k+1},\mu_{k+2},...$；
- 理论上任意 $k$ 个关于 $\mu_{i}$ 的方程组都可以，但考试要求前 $k$ 个才算对；

### 极大似然法

思想：用“最像” $\theta$ 真值的值去估计 $\theta$，换言之，在参数空间中找一个 $\theta$，使得 $L(\theta)$ 达到最大。

具体步骤如下（若待估参数不止一个，则对每个待估参数 $\theta_{i}$ 均执行如下操作）：

1. 构造似然函数 $L(\theta)=L(\theta;x_1,x_2,...,x_n)=\prod_{i=1}^{n}f(x_i;\theta)$；
2. 求解 $\theta$，使得 $L(\theta)$ 达到最大值，称这个 $\theta$ 为极大似然估计量，记作 $\hat{\theta}$；

**求解似然函数最大值点**的常用方法：

- 解似然方程 $\frac{\partial L(\theta)}{\partial \theta_i}=0$，检验极大值点；
- 或者也可以解对数似然方程 $\frac{\partial \ln L(\theta)}{\partial \theta_i}=0$，检验极大值点；
- 若 $L(\theta)$ 关于某个 $\theta_i$ 是单调的，则最大值在边界取得；

极大似然估计法的性质：

- 不变原则：设参数 $\theta$ 的极大似然估计为 $\hat\theta$ 若 $g(\cdot)$ 为连续函数，则 $g(\theta)$ 的极大似然估计为 $g(\hat{\theta})$；

## 估计量的评价准则

### 无偏性准则

若参数 $\theta$ 估计量 $\hat{\theta}=\theta(X_1,X_2,...,X_n)$ 的数学期望存在，且满足 $E(\hat{\theta})=\theta$，则称 $\hat{\theta}$ 是 $\theta$ 的一个**无偏估计量**或**无偏估计(Unbiased Estimation)**。

- 若 $E(\hat{\theta})\not=\theta$，则称 $|E(\hat{\theta})-\theta|$ 为估计量 $\hat\theta$ 的**偏差**；
- 若 $\lim_{n\to+\infty}E(\hat{\theta})=0$，则称 $\hat{\theta}$ 是 $\theta$ 的**渐进无偏估计(Asymptotic Unbiased Estimation)**；

### 有效性准则

设 $\theta_1$ 和 $\theta_2$ 是参数 $\theta$ 的两个无偏估计，如果对于 $\forall \theta\in\Theta$，$Var(\theta_1)\leq Var(\theta_2)$，且不恒取等，则称 $\theta_1$ 比 $\theta_2$ **有效**。

### 均方误差准则

$E[(\hat\theta-\theta)^2]$ 是估计量 $\hat\theta$ 的**均方误差(Mean Square Error)**，记为 $Mse(\hat\theta)$。

在均方误差准则下，估计量的均方误差越小越好。若 $Mse(\hat\theta_1)\leq Mse(\hat\theta_2)$ 且不恒取等，则称 $\hat\theta_1$ 优于 $\hat\theta_2$。

- 若 $\hat\theta$ 是参数 $\theta$ 的无偏估计量，则有 $Mse(\hat\theta)=Var(\hat\theta)$；
- 均方误差有分解式 $E[(\hat\theta-\theta)^2]=Var(\hat\theta)+(E(\hat\theta)-\theta)^2$；
- 均方误差准则常用于有偏估计量之间，或有偏估计量与无偏估计量之间的比较；实际应用中，有时均方误差准则比无偏性准则更加重要；

###  相合性准则

若对于 $\forall \varepsilon >0$，有 $\lim_{n\to+\infty}P\{|\hat\theta_n-\theta|<\varepsilon\}=1$，即 $\hat\theta _n \xrightarrow{P}\theta$，则称 $\hat\theta_n$ 是 $\theta$ 的**相合估计量(Consistent Estimation)**或**一致估计量**。

有如下定理：

- 设 $\hat\theta_n$ 是 $\theta$ 的一个估计量，若 $\lim_{n\to \infty}E(\hat\theta)=\theta$，$\lim_{n\to\infty}Var(\hat\theta_n)=0$，则 $\hat\theta_n$ 是 $\theta$ 的相合估计。

##  区间估计

**点估计**是由样本求出未知参数 $\theta$ 的一个估计值 $\hat{\theta}$，而**区间估计**则要由样本给出参数 $\theta$ 的一个估计范围，并指出该区间包含 $\theta$ 的可靠程度。

下面给出区间估计的一些基本概念：

- 置信区间：设总体 $X$ 的分布函数 $F(x;\theta)$ 含有一个未知参数 $\theta$，对于给定的值 $\alpha$，如果有两个统计量 $\theta_{L}=\theta_{L}(X_1,X_2,...,X_n)$，$\theta_{U}=\theta_{U}(X_1,X_2,...,X_n)$，$\theta_{L}<\theta_{U}$，使得 $P\{ \theta_{L}(X_1,X_2,...,X_n) < \theta < \theta_{U}(X_1,X_2,...,X_n) \}\geq 1-\alpha \;\;,\;\; \forall \theta \in \Theta$，则称随机区间 $[\theta_{L},\theta_{U}]$ 是 $\theta$ 的置信水平为 $1-\alpha$ 的**双侧置信区间**，简称**置信区间**；
- 置信下限和置信上限：分别是 $\theta_{L}$ 和 $\theta_{U}$；
- 置信度（置信水平）：$1-\alpha$；
- 单侧置信区间：在置信区间的定义中，如果修改为 $P\{ \theta_{L}(X_1,X_2,...,X_n) < \theta \}\geq 1-\alpha \;\;,\;\; \forall \theta \in \Theta$，则称随机区间 $[\theta_{L},+\infty]$ 是 $\theta$ 的置信水平为 $1-\alpha$ 的**单侧置信区间**；
    - 相应地，我们还可以定义单侧置信下限，以及具有单侧置信上限的单侧置信区间 $(-\infty,\theta_{U})$；

双侧置信区间和单侧置信区间的关系：

设 $\theta_{L}=\theta_{L}(X_1,X_2,...,X_n)$，$\theta_{U}=\theta_{U}(X_1,X_2,...,X_n)$ 分别是 $\theta$ 的置信水平为 $1-\alpha_{1}$ 和 $1-\alpha_{2}$ 的单侧置信下限及上限，且对于任何样本都满足 $\theta_{L}<\theta_{U}$，则 $(\theta_{L},\theta_{U})$ 是 $\theta$ 的置信水平为 $1-\alpha_{1}-\alpha_{2}$ 的双侧置信区间。

### 评价区间估计的原则

- **置信度原则**：<br />
  希望随机区间 $[\theta_{L},\theta_{U}]$ 包含真值 $\theta$ 的概率越大越好；
- **精确度原则**：<br />
  可以用随机区间的平均长度 $E(\theta_{U}-\theta_{L})$ 去衡量，希望其越短越好；并称二分之一区间的平均长度为置信区间的**误差限**；
- 这是一对矛盾的标准，现实应用中我们通常希望在保证置信度的前提下，尽可能提高精确度；

### 枢轴量法

枢轴量法是寻求区间估计的常用方法。

**枢轴量**是样本 $X=(X_1,X_2,...,X_n)$ 和待估参数 $\theta$ 的函数，即 $G=G(X_1,X_2,...,X_n;\theta)$，并且要求 $G$ 的分布已知且不依赖于任何未知参数。

具体步骤如下：

1. 构造枢轴量 $G(X;\theta)$；
2. 对于给定的置信度 $1-\alpha$，确定两个常数 $a,b$，使得：<br />
   $P\{ a<G(X;\theta)<b \}\geq 1-\alpha$；
3. 若能从 $a<G(X;\theta)<b$ 反解出不等式：<br />
   $\theta_{L}(X)<\theta<\theta_{U}(X)$，<br />
   那么 $[\theta_{L},\theta_{U}]$ 就是 $\theta$ 的置信水平为 $1-\alpha$ 的置信区间，也称**同等置信区间**；

值得注意的是：

- 若要求单侧置信限，只需要将 $P\{ a<G(X;\theta)<b \}\geq 1-\alpha$ 相应地改为 $P\{ a<G(X;\theta) \}\geq 1-\alpha$ 或 $P\{ G(X;\theta)<b \}\geq 1-\alpha$ 即可；
- 枢轴量和统计量的区别：
    - 枢轴量是样本和待估参数的函数，其分布不依赖于任何未知参数；
    - 统计量只是样本的函数，其分布常依赖于未知参数；

## 正态总体参数的区间估计

### 单个正态总体的情形

设 $X_1,X_2,...,X_n$ 来自总体 $N(\mu,\sigma_{2})$，$\overline{X}$ 和 $S^2$ 分别为样本均值和样本方差，置信度为 $1-\alpha$：

1.&nbsp;$\sigma^2$ 已知时 $\mu$ 的置信区间：

取枢轴量 $\frac{\overline X-\mu}{\sigma/\sqrt{n}}\sim N(0,1)$，置信区间为 $\left(\overline X-\frac{\sigma}{\sqrt{n}}z_{\alpha/2},\overline X + \frac{\sigma}{\sqrt{n}}z_{\alpha/2}\right)$。

若只考虑单侧置信限，以单侧置信下限为例，单侧置信区间为 $\left(\overline X-\frac{\sigma}{\sqrt{n}}z_{\alpha},+\infty\right)$。

---

2.&nbsp;$\sigma^2$ 未知时 $\mu$ 的置信区间:

取枢轴量 $\frac{\overline X-\mu}{S/\sqrt{n}}\sim t(n-1)$，置信区间为 $\left(\overline X - \frac{S}{\sqrt{n}}t_{\alpha/2}(n-1),\overline X + \frac{S}{\sqrt{n}}t_{\alpha/2}(n-1)\right)$。

---

3.&nbsp;$\sigma^2$ 的置信区间（当作 $\mu$ 未知）：

取枢轴量 $\frac{(n-1)S^2}{\sigma^2}\sim \chi^2(n-1)$，置信区间为 $\left(\frac{(n-1)S^2}{\chi^2_{\alpha/2}(n-1)},\frac{(n-1)S^2}{\chi^2_{1-\alpha/2}(n-1)}\right)$。

### 两个正态总体的情形

设 $X_1,X_2,...,X_{n_1}$ 来自 $N(\mu_{1},\sigma_{1}^{2})$，$Y_1,Y_2,...,Y_{n_2}$ 来自 $N(\mu_{2},\sigma_{2}^{2})$，这两个样本相互独立，$\overline{X}=\frac{1}{n_1}\sum_{i=1}^{n_1}X_i$，$\overline{Y}=\frac{1}{n_2}\sum_{i=1}^{n_2}Y_i$，$S_1^2$ 和 $S_2^2$ 分别为它们的样本均值和样本方差，置信度为 $1-\alpha$：

- 比较均值（估计 $\mu_1-\mu_2$，也称为 Behrens-Fisher 问题）；
- 比较方差（估计 $\frac{\sigma_1^2}{\sigma_2^2}$）；

1.&nbsp;$\sigma_1^2,\sigma_2^2$ 已知时 $\mu_1-\mu_2$ 的置信区间：

取枢轴量 $\frac{(\overline{X}-\overline{Y})-(\mu_{1}-\mu_{2})}{\sqrt{\frac{\sigma_{1}^{2}}{n_1}+\frac{\sigma_{2}^{2}}{n_2}}} \sim N(0,1)$，置信区间为 $\left(\overline X - \overline Y\pm z_{\alpha/2}\sqrt{\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2}}\right)$。

---

2.&nbsp;$\sigma_1^2=\sigma_2^2=\sigma^2$ 未知时 $\mu_1-\mu_2$ 的置信区间：

取枢轴量 $\frac{(\overline X - \overline Y) - (\mu_1-\mu_2)}{S_\omega\sqrt{\frac{1}{n_1}+\frac{1}{n_2}}}\sim t(n_1+n_2-2)$，置信区间为 $\left(\overline X - \overline Y\pm t_{\alpha/2}(n_1+n_2-2)S_w\sqrt{\frac{1}{n_1}+\frac{1}{n_2}}\right)$。

---

3.&nbsp;$\sigma_1^2\not =\sigma_2^2$ 且未知时 $\mu_1-\mu_2$ 的置信区间：

当样本容量 $n_1$ 和 $n_2$ 都充分大时（一般要大于 $50$），取枢轴量 $\frac{(\overline{X}-\overline{Y})-(\mu_{1}-\mu_{2})}{\sqrt{\frac{S_{1}^{2}}{n_1}+\frac{S_{2}^{2}}{n_2}}} \sim N(0,1)$，置信区间为 $\left(\overline X - \overline Y\pm z_{\alpha/2}\sqrt{\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2}}\right)$。

对于有限小样本，仍取枢轴量 $\frac{(\overline{X}-\overline{Y})-(\mu_{1}-\mu_{2})}{\sqrt{\frac{S_{1}^{2}}{n_1}+\frac{S_{2}^{2}}{n_2}}}$，可以证明其近似服从自由度为 $k$ 的 $t$ 分布，其中 $k=\frac{(\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2})^2}{\frac{(S_1^2)^2}{n_1^2(n_1-1)}+\frac{(S_2^2)^2}{n_2^2(n_2-1)}}$，置信区间为 $\left(\overline X - \overline Y\pm t_{\alpha/2}(k)\sqrt{\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2}}\right)$。

实际使用中，也常用 $min(n_1-1,n_2-1)$ 近似代替上述自由度 $k$。

---

4.&nbsp;$\frac{\sigma_1^2}{\sigma_2^2}$ 的置信区间（当作 $\mu_1,\mu_2$ 未知）：

取枢轴量 $\frac{S_1^2/S_2^2}{\sigma_1^2/\sigma_2^2}\sim F(n_1-1,n_2-1)$，置信区间为 $\left(\frac{S_1^2/S_2^2}{F_{\alpha/2}(n_1-1,n_2-1)},\frac{S_1^2/S_2^2}{F_{1-\alpha/2}(n_1-1,n_2-1)}\right)$。

## 非正态总体参数的区间估计

通常把这个非正态分布根据中心极限定理近似成一个正态分布，从而利用上文的方法构造枢轴量，并求解置信区间。