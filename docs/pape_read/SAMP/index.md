# Stochastic Scene-Aware Motion Prediction

!!! info "文章信息"
    - 文章题目：*Stochastic Scene-Aware Motion Prediction*
    - 作者：[Mohamed Hassan](https://mohamedhassanmus.github.io/), [Duygu Ceylan](http://www.duygu-ceylan.com/), [Ruben Villegas](https://rubenvillegas.github.io/), [Jun Saito](https://research.adobe.com/person/jun-saito/), [Jimei Yang](https://research.adobe.com/person/jimei-yang/), [Yi Zhou](https://research.adobe.com/person/yi-zhou/), and [Michael Black](https://ps.is.tuebingen.mpg.de/person/black)
    - 论文地址：[🔗](https://ps.is.mpg.de/uploads_file/attachment/attachment/652/samp.pdf)
    - 项目主页：[🔗](https://samp.is.tue.mpg.de/)
    - Demo 代码：[🔗](https://github.com/mohamedhassanmus/SAMP)
    - 训练代码：[🔗](https://github.com/mohamedhassanmus/SAMP_Training)

---

## 代码阅读

### MotionNet

读入数据的时候使用了 `numpy.loadtxt()`，根据资料查找，可以大致根据输入数据得到读入的数据的最多是二维的。

---

公式推导：

!!! note "正态分布的熵公式"
    假设 $x\sim N(\mu, \sigma^2)$，于是有：

    $$
    p(x) = \frac{1}{\sqrt{2\pi \sigma^2}}   \exp\left[
        -\frac{(x-\mu)^2}{2\sigma^2}
    \right]
    $$
    并且有结论：

    $$
    \int_{-\infty}^{\infty} e^{-x^2} \mathrm{d}x = \sqrt{\pi}
    $$

    那么有其熵公式：

    $$
    \begin{aligned}
        -\int_{-\infty}^{\infty} p(x)\ln p(x) \mathrm{d}x
        &=
        -\int_{-\infty}^{\infty}\frac{1}{\sqrt{2\pi\sigma^2}}\exp\left(
            -\frac{(x-\mu)^2}{\sqrt{2\sigma^2}} 
        \right)
        \ln\left[
        \frac{1}{\sqrt{2\pi\sigma^2}} \exp\left(
            -\frac{(x-\mu)^2}{2\sigma^2}
        \right)
        \right]
        \mathrm{d}x \\
        &= 
        \frac{1}{2}\left(
            \ln\left(
                2\pi\sigma^2
            \right) + 1
        \right)
    \end{aligned}
    $$

