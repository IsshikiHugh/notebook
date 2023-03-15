# [7.x] 参数估计

## 点估计

设总体$X$的分布函数为$F(x;\theta)$，$\theta$是待估参数，$X_1,X_2,...,X_n$是$X$的一个样本。<br />点估计就是要构造一个适当的统计量$\hat{\theta}(X_1,X_2,...,X_n)$，用来估计未知参数$\theta$，我们称$\hat{\theta}(X_1,X_2,...,X_n)$为$\theta$的**估计量**。<br />如果把其中的样本值用$x_1,x_2,...,x_n$代替，则称$\hat\theta(x_1,x_2,...,x_n)$为$\theta$的一个**估计值**。<br />在不导致混淆的情况下，两者都可以被称为“估计”，并都可以简记为$\hat\theta$。


### 矩法

**做题步骤**：

1. 假设有$k$个待求未知参数；
2. 列关于$\mu_1,\mu_2,...,\mu_k$的方程组；
3. 从方程组中解出这$k$个参数；
- 如果方程中存在恒等式，则可以顺延求$\mu_{k+1}$；
- 理论上任意$k$个关于$\mu_i$的方程组都可以，但考试要求前$k$个才算对；


### 极大似然法

**做题步骤**：

1. 构造**对数似然函数(Likelihood Function)**$L(\theta)=\ln p(x_1,...,x_n,\theta)$；
2. 求$\hat\theta\;\;s.t.\;\;L(\hat\theta;x_1,x_2,...,x_n)=\max_{\theta\in\Theta}L(\theta;x_1,x_2,...,x_n)$；
   1. 解**对数似然方程(Log-likelihood Equation)**$\frac{\mathrm{d}L(\theta)}{\mathrm{d}\theta}=0$，检验极大值点；
   2. 检验端点；
   3. 求最大值点；

**性质**：

- 极大似然估计的不变性
   - 设参数$\theta$的极大似然估计为$\hat\theta$，$\theta^*=g(\theta)$是$\theta$的连续函数，则参数$\theta^*$的极大似然估计为$\hat\theta^*=g(\hat\theta)$；


## 估计量的评价准者

### 无偏性准则

设$\theta$是总体$X$的待估参数，$X_1,X_2,...,X_n$ 是来自总体$X$的样本，若估计量$\hat\theta=\hat\theta(X_1,X_2,...,X_n)$的数学期望存在，满足$E(\hat\theta)=\theta,\;\;\forall\theta\in\Theta$，则称$\hat\theta$是$\theta$的**无偏估计量**或**无偏估计(Unbiased Estimation)**。

- 若$E(\hat\theta)\not=\theta$，则称$E(\hat\theta)-\theta$为估计量$\hat\theta$的**偏差**；
- 若$E(\hat\theta)\not=\theta$，但若满足$\lim_{x\to+\infty}E(\hat\theta)=0$，则称$\hat\theta$是$\theta$的**渐进无偏估计(Asymptotic Unbiased Estimation)**；


### 有效性准则

设$\theta_1$和$\theta_2$ 是参数$\theta$的无偏估计，若$\forall \theta\in\Theta$，$Var_\theta(\hat\theta_1)\leq Var_\theta(\hat\theta_2)$，且不恒取“=”，则称$\hat\theta_1$比$\hat\theta_2$**有效**。


### 均方误差准则

$E[(\hat\theta-\theta)^2]
=Var(\hat\theta)+(E(\hat\theta)-\theta)^2$是估计量$\hat\theta$的**均方误差(Mean Square Error)**，记为$Mse(\hat\theta)$。<br />若$Mse(\hat\theta_1)\leq Mse(\hat\theta_2)$且不恒取“=”，则称$\hat\theta_1$优于$\hat\theta_2$。

- 若$\hat\theta$是参数$\theta$的无偏估计量，则有$Mse(\hat\theta)=Var(\hat\theta)$；
- 因而均方误差准则常用于有偏估计量之间，或有偏估计量与无偏估计量之间的比较；


###  相合性准则

若$\lim_{n\to+\infty}P\{|\hat\theta_n-\theta|<\varepsilon\}=1$，即$\hat\theta _n \xrightarrow{P}\theta$，则称$\hat\theta_n$是$\theta$的**相合估计量(Consistent Estimation)。**<br />有如下定理：

- 设$\hat\theta_n=\hat\theta_n(x_1,x_2,...,x_n)$是$\theta$的一个估计量，若$\lim_{n\to \infty}E(\hat\theta)=\theta,\;\;\;\lim_{n\to\infty}Var(\hat\theta_n)=0,$则$\hat\theta_n$是$\theta$的相合估计。


---


##  区间估计

- 橙书 P300
- 绿书 P190
- 这里只给出特定估计的表达式

### 单个正态总体参数的置信区间
采用上侧分位数<br />$X\sim N(\mu,\sigma^2)$

$\sigma$**已知时**$\mu$**的置信区间**<br />$\overline x \sim N(\mu,\sigma^2/n)\;\;\rightarrow\;\;
\frac{\overline x-\mu}{\sigma/\sqrt{n}}\sim N(0,1)$
$[\hat\theta_L,\hat\theta_U]=[\;\;\overline x-\frac{z_{\alpha/2}·\sigma}{\sqrt{n}}\;\;,\;\;\overline x + \frac{z_{\alpha/2}·\sigma}{\sqrt{n}}\;\;]$
$\sigma$**未知时**$\mu$**的置信区间**<br />$\frac{\sqrt{n}(\overline x - \mu)}{\sqrt{s^2}
}\sim t(n-1)$
$[\hat\theta_L,\hat\theta_U]=\left[\;\;
\overline x - \frac{t_{\alpha/2}(n-1)s}{\sqrt{n}}
\;\;,\;\;
\overline x + \frac{t_{\alpha/2}(n-1)s}{\sqrt{n}}
\;\;\right]$
$\sigma^2$**的置信区间（当作**$\mu$**未知）**<br />$\frac{(n-1)s^2}{\sigma^2}\sim \chi^2(n-1)$
$[\hat\theta_L,\hat\theta_U]=\left[\;\;
\frac{(n-1)s^2}{\chi^2_{\alpha/2}(n-1)}
\;\;,\;\;
\frac{(n-1)s^2}{\chi^2_{1-\alpha/2}(n-1)}
\;\;\right]$


### 两个正态总体下的置信区间

$\sigma_1^2,\sigma_2^2$**已知时**$\mu_1-\mu_2$**的置信区间**<br />$\overline x - \overline y \sim N(\mu_1-\mu_2,\frac{\sigma_1^2}{n_1},\frac{\sigma_2^2}{n_2})$
$[\hat\theta_L,\hat\theta_U]=\left[\;\;\overline x - \overline y+ z_{\alpha/2}\sqrt{\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2}}\;\;,\;\;\overline x - \overline y- z_{\alpha/2}\sqrt{\frac{\sigma_1^2}{n_1}+\frac{\sigma_2^2}{n_2}}\;\;\right]$
$\sigma_1^2,\sigma_2^2$**未知但相同(**$\sigma_1^2=\sigma_2^2=\sigma^2$**)时**$\mu_1-\mu_2$**的置信区间**<br />取$\sigma^2$的无偏估计量$S^2_w=\frac{(n_1-1)S_1^2+(n_2-1)S_2^2}{n_1+n_2-2}$
$\frac{(\overline x -\overline y)-(\mu_1-\mu_2)}{S_w\sqrt{\frac{1}{n_1}+\frac{1}{n_2}}}\sim t  (n_1+n_2-2)$
$[\hat\theta_L,\hat\theta_U]=\left[\;\;
\overline x - \overline y\pm
t_{\alpha/2}(n_1+n_2-2)S_w\sqrt{\frac{1}{n_1}+\frac{1}{n_2}}
\;\;\right]$
$\sigma_1^2,\sigma_2^2$未知且不同($\sigma_1^2\not=\sigma_2^2$)时$\mu_1-\mu_2$的置信区间

- 当样本容量$n_1,n_2$足够大时，有$\frac{(\overline x -\overline y)-(\mu_1 - \mu_2)}{\sqrt{\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2}}}\sim N(0,1)$
   - $[\hat\theta_L,\hat\theta_U]=\left[\;\;
\overline x - \overline y\pm
z_{\alpha/2}\sqrt{\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2}}
\;\;\right]$
- 而对于容量不大的小样本，有如下结论：
   - $\frac{(\overline X-\overline Y)-(\mu_1-\mu_2)}{\sqrt{\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2}}}\sim t(k)\;\;where \;\; k=\frac{(\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2})^2}{\frac{(S_1^2)^2}{n_1^2(n_1-1)}+\frac{(S_2^2)^2}{n_2^2(n_2-1)}}$；
   - $[\hat\theta_L,\hat\theta_U]=\left[\;\;
\overline x - \overline y\pm
t_{\alpha/2}(k)\sqrt{\frac{S_1^2}{n_1}+\frac{S_2^2}{n_2}}
\;\;\right]$

$\frac{\sigma^2_1}{\sigma_2^2}$**的区间估计**<br />$\frac{S_1^2/S_2^2}{\sigma^2_1/\sigma_2^2}\sim F(n_1-1,n_2-1)$


$$
[\hat\theta_L,\hat\theta_U]=\left[\;\;
\frac{S_1^2/S_2^2}{F_{\alpha/2}(n_1-1,n_2-1)}
\;\;,\;\;
\frac{S_1^2/S_2^2}{F_{1-\alpha/2}(n_1-1,n_2-1)}
\;\;\right]
$$

