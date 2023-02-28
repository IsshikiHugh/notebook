# [5.x] 大数定律及中心极限定理

## 依概率收敛

**依概率收敛**<br />设$\{Y_n,n\geq1\}$为一**随机变量序列**，$c$为一常数。若$\forall\varepsilon>0\;\;\;s.t. \;\;\lim_{n\to+\infty}P\{|Y_n-c|\geq\varepsilon\}=0$，则称$\{Y_n,n\geq1\}$**依概率收敛(Convergence in Probability)**于$c$，记做$Y_n\xrightarrow{P} c\;,\;\;n\to+\infty$。<br />等价的，也可以将条件写成$\forall\varepsilon>0\;\;\;s.t. \;\;\lim_{n\to+\infty}P\{|Y_n-c|<\varepsilon\}=1$。

- 这种收敛不是数学意义上的一般收敛，而是概率意义下的一种收敛
- 其含义是：$Y_n$对$c$的绝对偏差不小于任何一个给定量的可能性随$n$的增大而越来越小；或者绝对偏差$|Y_n-c|$小于任何一个给定量的可能性随$n$的增大时而越来越接近于$1$


依概率收敛有如下重要**性质**：<br />若：

1. $\left\{
\begin{aligned}
X_n\xrightarrow{P} a\\
Y_n\xrightarrow{P} b
\end{aligned}
\right.
\;\;,\;\;n\to+\infty\;\;,\;\;a,b\in\mathbf{R}$；
2. 二元函数$g(x,y)$在点$(a,b)$连续（例如**四则运算**）；

则有：

- $g(X_n,Y_n)\xrightarrow{P}g(a,b)$。

该性质即依概率收敛可以在双目运算符中进行下放。


**马尔可夫(Markov)不等式**<br />若随机变量$Y$的$k$阶（原点）矩存在（$k\geq1$），则$\forall \varepsilon > 0$，有：<br />$P \{ |Y| \geq \varepsilon \}\leq \frac{E(|Y|^k)}{\varepsilon^k}\;\; or \;\; P\{|Y| < \varepsilon \} \geq 1 - \frac{E(|Y|^k)}{\varepsilon^k}$
特别地，当$Y$取非负值的随机变量且它的$k$阶矩存在时，有：$P\{Y\geq \varepsilon\} \leq \frac{E(Y^k)}{\varepsilon^k}$


**切比雪夫(Chebyshev)不等式**是马尔可夫不等式的推论<br />若随机变量$X$的数学期望和方差存在，分别记$E(X)=\mu\;,\; Var(X) = \sigma^2$，则$\forall \varepsilon > 0$，有：<br />$P\{ |X-\mu|\geq \varepsilon \} \leq \frac{\sigma^2}{\varepsilon^2}\;\;or\;\;P\{ |X-\mu|< \varepsilon \} \geq1- \frac{\sigma^2}{\varepsilon^2}$
可以记忆为$P\{ \sigma^2\geq \varepsilon^2 \} \leq \frac{\sigma^2}{\varepsilon^2}\;\;or\;\;P\{ \sigma^2< \varepsilon^2 \} \geq1- \frac{\sigma^2}{\varepsilon^2}$ 


## 大数定理

- 主要讨论什么条件下，随机变量序列的算术平均依概率收敛到其均值的算术平均。

**大数定理**（一般形式）<br />设$\{Y_i,i\geq1\}$为一随机变量**序列**，若存在**常数**序列${c_n,n\geq 1}$，使$\forall \varepsilon > 0$，有;<br />$\lim_{n\to+\infty}P\{|\frac{1}{n}\sum_{i=1}^{n}Y_i-c_n|\geq \varepsilon\}=0 \;\; or \;\; \lim_{n\to+\infty}P\{|\frac{1}{n}\sum_{i=1}^{n}Y_i-c_n|< \varepsilon\}=1$
即：$(\frac{1}{n}\sum_{i=1}^{n}Y_i-c_n)\xrightarrow{P}0\;\;,\;\;n\to+\infty$，则称随机变量序列$\{Y_i,i\geq1\}$服从**弱大数定理(Weak Law of Large Numbers)**，简称服从**大数定律**。<br />观察到如果令$Z_n=\frac{1}{n}\sum_{i=1}^{n}Y_i$，则表达式的含义为$Z_n\xrightarrow{P}c\;\;,\;\;n\to+\infty$，即大数定律也可以表述为：

- 随机变量序列前$n$个变量的**算术平均**依概率收敛于$c$， 则这个随机变量序列服从大数定律。

**橙书**给出的定义式是：<br />$\lim_{n\to \infty}P\big(\big|  
\frac{1}{n}\sum_{i=1}^{n}X_i-\frac{1}{n}\sum_{i=1}^{n}E(X_i)
 \big|<\varepsilon\big)=1$

- 接下来给出的大数定律的区别体现在**条件**上：有些是相互独立的随机变量，有些是相依的随机变量，有些是同分布的随机变量，有些是不同分布的随机变量。


**伯努利(Bernoulli)大数定律**<br />设$n_A$表示$n$重贝努力实验中事件$A$发生的次数，并记$P(A)=p$，则$\forall \varepsilon > 0$，有：<br />$\lim_{n\to+\infty}P\{|\frac{n_A}{n}-p|\geq \varepsilon\}=0$


**辛钦(Khinchin)大数定律**<br />_*即使随机变量的方差不存在，期望存在即可_<br />设$\{X_i,i\geq 1\}$为独立同分布的随机变量序列，且数学期望为$\mu$，则$\forall\varepsilon>0$，有：<br />$\lim_{n\to+\infty}P\{|\frac{1}{n}\sum_{i=1}^{n}X_i-\mu|\geq \varepsilon\}=0\;\;\;or\;\;\;\frac{1}{n}\sum_{i=1}^{n}X_i\xrightarrow{P}\mu\;\;,\;\;n\to+\infty$


辛钦大数定律有如下**推论**：<br />设$\{X_i,i\geq 1\}$为独立同分布的随机变量序列，若$h(x)$为连续函数，且$E(|h(X_1)|)<+\infty$，则$\forall\varepsilon>0$，有：<br />$\lim_{n\to+\infty}P\{|\frac{1}{n}\sum^{n}_{i=1}h(X_i)-a|\geq\varepsilon\}=0\;\;\;or\;\;\;\frac{1}{n}\sum_{i=1}^{n}h(X_i)\xrightarrow{P}a\;\;,\;\;n\to+\infty
\\
where\;\;\;a=E(|h(X_1)|)$


---


## 中心极限定理

- 讨论什么条件下，独立随机变量和的分布函数$Y=\sum X_i$的分布函数会收敛于正态分布。

### 独立同分布时

**林德伯格-莱维中心极限定理**<br />设$\{X_i,i\geq 1\}$为独立同分布的随机变量序列，且$E(X_i)=\mu\;\;,\;\;Var(X_i)=\sigma^2\;\;(\sigma>0)$，则$\forall x\in \mathbf{R}$，有：<br />

$$
\begin{aligned}
\lim_{n\to+\infty}P\left\{
\frac{
\begin{aligned}
    \sum_{i=1}^{n}X_i-E(\sum_{i=1}^{n}X_i)
\end{aligned}
}{\begin{aligned}
    \sqrt{\mathrm{Var}(\sum_{i=1}^{n}X_i)}
\end{aligned}}\leq x\right\}&=
\lim_{n\to+\infty}P\left\{
\frac{
\begin{aligned}
    \sum_{i=1}^{n}X_i-n\mu
\end{aligned}
}{\begin{aligned}
    \sigma\sqrt{n}
\end{aligned}}\leq x\right\}
\\
&=\frac{1}{\sqrt{2\pi}}\int_{-\infty}^{x}e^{-\frac{t^2}{2}}\mathrm{d}t
\\
&=\Phi(x)
\end{aligned}
$$

换句话来说，$E(X_i)=\mu\;\;,\;\;Var(X_i)=\sigma^2\;\;(\sigma>0)$的独立同分布的随机变量序列的部分和$\sum_{i=1}^{n}X_i$的标准化量

$$
\frac{
\begin{aligned}
    \sum_{i=1}^{n}X_i-n\mu
\end{aligned}
}{\begin{aligned}
    \sigma\sqrt{n}
\end{aligned}}
\overset{\text{approximately}}{\sim} N(0,1)\;\;,\;\;\text{where }n\text{ is big enough}
$$

，当然也可以写成：

$$
\frac{
\begin{aligned}
    \frac{1}{n}\sum_{i=1}^{n}X_i-\mu
\end{aligned}
}{\begin{aligned}
    \frac{\sigma}{\sqrt{n}}
\end{aligned}}
\overset{\text{approximately}}{\sim} N(0,1)\;\;,\;\;\text{where }n\text{ is big enough}
$$ 

### 二项分布的正态近似

林德伯格-莱维中心极限定理有如下**推论**：<br />**棣莫弗-拉普拉斯中心极限定理**<br />设$n_A$表示$n$重贝努力实验中事件$A$发生的次数，并记$P(A)=p$，则

$$
\forall x\in\mathbf{R}$，有：<br />$\lim_{n\to+\infty}P\{\frac{n_A-np}{\sqrt{np(1-p)}}\leq x\}=\frac{1}{\sqrt{2\pi}}\int_{-\infty}^{x}e^{-\frac{t^2}{2}}\mathrm{d}t=\Phi(x)
$$

### 独立不同分布时(不要求)

**李雅普诺夫中心极限定理**<br />设$\{X_i,i\geq 1\}$为相互独立的随机变量序列，且$E(X_i)=\mu_i\;\;,\;\;Var(X_i)=\sigma_i^2\;\;(\sigma>0)$，若$\exists\varepsilon>0$使得：<br />$\lim_{+\infty}\frac{1}{B_n^{2+\varepsilon}}\sum_{i=1}^{n}E|X_i-\mu_i|^{2+\varepsilon}=0\;\;\;where\;\;\;B_n^{2}=\sum_{i=1}^{n}\sigma_i^2$
则：<br />
$$
\lim_{n\to+\infty}P\{
\frac{1}{B_n}   \sum_{i=1}^n(X_i-\mu_i)\leq x
\}
=
\frac{1}{\sqrt{2\pi}}\int_{-\infty}^{x}e^{-\frac{t^2}{2}}\mathrm{d}t=\Phi(x)
$$
