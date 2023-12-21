# [5.x] 大数定律及中心极限定理

## 大数定律

### 依概率收敛

设 $\{Y_n,n\geq1\}$ 为一**随机变量序列**，若对于 $\forall\varepsilon>0$，均有 $\lim_{n\to+\infty}P\{|Y_n-Y|\geq\varepsilon\}=0$（或者 $\lim_{n\to+\infty}P\{|Y_n-c|<\varepsilon\}=1$），则称 $\{Y_n,n\geq1\}$ **依概率收敛(Convergence in Probability)**于 $Y$，记做 $Y_n\xrightarrow{P} Y\;,\;\;n\to+\infty$。

特别地，当 $Y=c$ 为一常数时，称 $\{Y_n,n\geq1\}$ 依概率收敛于常数 $c$。

- 这种收敛不是数学意义上的一般收敛，而是概率意义下的一种收敛；
- 其含义是：$Y_n$ 对 $Y$ 的绝对偏差不小于任何一个给定量的可能性随 $n$ 的增大而越来越小；或者绝对偏差 $|Y_n-Y|$ 小于任何一个给定量的可能性随 $n$ 的增大时而越来越接近于 $1$；

---

依概率收敛有如下重要**性质**：

若 $X_n \xrightarrow{P} a$，$Y_n \xrightarrow{P} b$，当 $n\to+\infty$ 时，函数 $g(x,y)$ 在点 $(a,b)$ 连续，则：

$$
g(X_n,Y_n) \xrightarrow{P} g(a,b) \;,\;\; n\to+\infty
$$

特别地，若 $X_n \xrightarrow{P} a$，$f(x)$ 在点 $a$ 连续，则：

$$
f(X_n) \xrightarrow{P} f(a) \;,\;\; n\to+\infty
$$

### 两个重要不等式

**马尔可夫(Markov)不等式**

若随机变量 $Y$ 的 $k$ 阶（原点）矩存在（$k\geq1$），即 $E(Y^k)$ 存在，则对于 $\forall \varepsilon > 0$，均有：

$$
P \{ |Y| \geq \varepsilon \}\leq \frac{E(|Y|^k)}{\varepsilon^k} \;\; \text{or} \;\; P\{Y\geq \varepsilon\} \leq \frac{E(Y^k)}{\varepsilon^k}
$$

特别地，当 $Y$ 取非负值的随机变量且它的 $k$ 阶矩存在时，有：

$$
P\{Y\geq \varepsilon\} \leq \frac{E(Y^k)}{\varepsilon^k}
$$

---

**切比雪夫(Chebyshev)不等式**

若随机变量 $X$ 具有数学期望 $E(X)=\mu$，方差 $Var(X) = \sigma^2$，则对于 $\forall \varepsilon > 0$，均有：

$$
P\{ |X-\mu|\geq \varepsilon \} \leq \frac{\sigma^2}{\varepsilon^2} \;\; \text{or} \;\; P\{ |X-\mu|< \varepsilon \} \geq1- \frac{\sigma^2}{\varepsilon^2}
$$

- 切比雪夫不等式是马尔可夫不等式的推论；
- 切比雪夫不等式应用范围更广，但是计算结果更粗糙；

### 常见的几种大数定律

- 大数定律主要讨论什么条件下，随机变量序列的算术平均依概率收敛到一个稳定值（伯努利大数定律中的概率，辛钦大数定律中的均值）。

---

**大数定律**（一般形式）

设 $\{Y_i,i\geq1\}$ 为一随机变量**序列**，若存在**常数**序列 $\{c_n,n\geq 1\}$，使得 $\forall \varepsilon > 0$，均有：

$$
\lim_{n\to+\infty}P\{|\frac{1}{n}\sum_{i=1}^{n}Y_i-c_n|\geq \varepsilon\}=0 \;\; \text{or} \;\; \lim_{n\to+\infty}P\{|\frac{1}{n}\sum_{i=1}^{n}Y_i-c_n|< \varepsilon\}=1
$$

成立，即有 $(\frac{1}{n}\sum_{i=1}^{n}Y_i-c_n)\xrightarrow{P}0\;\;,\;\;n\to+\infty$，则称随机变量序列 $\{Y_i,i\geq1\}$ 服从**弱大数定理(Weak Law of Large Numbers)**，简称服从**大数定律**。

特别地，若 $c_n$ 与 $n$ 无关，则可以写为：

$$
\frac{1}{n}\sum_{i=1}^{n}Y_i \xrightarrow{P} c \;\;,\;\; n\to+\infty
$$

---

关于服从大数定律，**橙书**给出的定义式是：

$$
\lim_{n\to \infty}P\big(\big|\frac{1}{n}\sum_{i=1}^{n}X_i-\frac{1}{n}\sum_{i=1}^{n}E(X_i) \big|<\varepsilon\big)=1
$$

---

接下来给出几种常见的大数定律，它们的区别体现在**条件**上：有些是相互独立的随机变量，有些是相依的随机变量；有些是同分布的随机变量，有些是不同分布的随机变量。

**伯努利(Bernoulli)大数定律**

设 $n_A$ 表示 $n$ 重伯努利试验中事件 $A$ 发生的次数，并记事件 $A$ 在每次试验中发生的概率为 $p$，则对于 $\forall \varepsilon > 0$，有：

$$
\lim_{n\to+\infty}P\{|\frac{n_A}{n}-p|\geq \varepsilon\}=0 \;\; \text{or} \;\; \frac{n_A}{n} \xrightarrow{P} p \;\;,\;\; n\to+\infty
$$

- 伯努利大数定律建立了在大量重复试验中事件出现频率的稳定性，正因为这种稳定性，**概率**的概念才有客观意义；
- 伯努利大数定律还提供了通过试验来确定事件概率的方法：既然频率 $\frac{n_A}{n}$ 与概率 $p$ 有较大偏差的可能性很小，因此可以通过做试验来确定某事件发生的**频率**，并把它作为相应的**概率**估计。这是一种参数估计法，该方法的重要理论基础之一就是大数定律。

---

**辛钦(Khinchin)大数定律**

设 $\{X_i,i\geq 1\}$ 为独立同分布的随机变量序列，且数学期望为 $\mu$，则对于 $\forall\varepsilon>0$，有：

$$
\lim_{n\to+\infty}P\{|\frac{1}{n}\sum_{i=1}^{n}X_i-\mu|\geq \varepsilon\}=0 \;\; \text{or} \;\; \frac{1}{n}\sum_{i=1}^{n}X_i\xrightarrow{P}\mu\;\;,\;\;n\to+\infty
$$

注意，辛钦大数定律的条件中，只要求期望存在，不要求方差存在。<br />
此外，辛钦大数定律有如下**推论**：

设 $\{X_i,i\geq 1\}$ 为独立同分布的随机变量序列，若 $h(x)$ 为连续函数，且 $E(|h(X_1)|)<+\infty$，则对于 $\forall\varepsilon>0$，有：

$$
\lim_{n\to+\infty}P\{|\frac{1}{n}\sum^{n}_{i=1}h(X_i)-a|\geq\varepsilon\}=0 \;\; \text{or} \;\; \frac{1}{n}\sum_{i=1}^{n}h(X_i)\xrightarrow{P}a\;\;,\;\;n\to+\infty
$$

其中 $a=E(|h(X_1)|)$，即随机变量 $\{ h(X_i) , i \geq 1 \}$ 也服从大数定律。



## 中心极限定理

- 中心极限定理讨论什么条件下，独立随机变量的和的分布函数 $Y=\sum X_i$ 会收敛于正态分布。

### 独立同分布时

**林德伯格-莱维中心极限定理**

设 $\{X_i,i\geq 1\}$ 为独立同分布的随机变量序列，且 $E(X_i)=\mu\;\;,\;\;Var(X_i)=\sigma^2\;\;(\sigma>0)$，则 $\forall x\in \mathbf{R}$，有：

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

换句话来说，$E(X_i)=\mu\;\;,\;\;Var(X_i)=\sigma^2\;\;(\sigma>0)$ 的独立同分布的随机变量序列的部分和 $\sum_{i=1}^{n}X_i$ 的标准化量近似于一个正态变量：

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

等价地，也可以写成如下形式：

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

**棣莫弗-拉普拉斯中心极限定理**是林德伯格-莱维中心极限定理的**推论**：

设 $n_A$ 表示 $n$ 重伯努利试验中事件 $A$ 发生的次数，并记 $P(A)=p$，则对于 $\forall x\in\mathbf{R}$，均有：

$$
\lim_{n\to+\infty}P\{\frac{n_A-np}{\sqrt{np(1-p)}}\leq x\}=\frac{1}{\sqrt{2\pi}}\int_{-\infty}^{x}e^{-\frac{t^2}{2}}\mathrm{d}t=\Phi(x)
$$

也就是说，当 $n$ 很大时，二项分布可以用正态分布去近似（期望与方差不变）：

$$
n_A \overset{\text{approximately}}{\sim} N(np,np(1-p)) \;\;,\;\;\text{where }n\text{ is big enough}
$$

其中 $n_A = \sum_{i=1}^{n} X_i$。

### 独立不同分布时(不要求)

**李雅普诺夫中心极限定理**

设 $\{X_i,i\geq 1\}$ 为相互独立的随机变量序列，且 $E(X_i)=\mu_i\;\;,\;\;Var(X_i)=\sigma_i^2\;\;(\sigma>0)$，若 $\exists\varepsilon>0$ 使得：

$$
\lim_{n\to+\infty}\frac{1}{B_n^{2+\varepsilon}}\sum_{i=1}^{n}E|X_i-\mu_i|^{2+\varepsilon}=0\;\;\;\text{where}\;\;\;B_n^{2}=\sum_{i=1}^{n}\sigma_i^2
$$

则有：

$$
\lim_{n\to+\infty}P\{
\frac{1}{B_n}   \sum_{i=1}^n(X_i-\mu_i)\leq x
\}
= \frac{1}{\sqrt{2\pi}}\int_{-\infty}^{x}e^{-\frac{t^2}{2}}\mathrm{d}t=\Phi(x)
$$