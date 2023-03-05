# Lecture 9 | Deep Learning

!!! warning "注意"
    本文尚未完全整理好！

## Machine Learning

- What is machine learning
  - Learning a program (model) from data
- What is supervised learning
  - Supervision signal from labeled data
- How to solve a problem
  - Modeling: describe the problem by a mathematical model
  - Training: find the optimal model parameters (model fitting)
  - Testing: apply the trained model to new data
- Next: how to solve the classification problem?

重要的概念：

- Model
  - 回归 / 分类
- 监督学习 Supervised learning
    - 训练数据的标签是给定的
    - 阶段：训练(模型拟合) / 测试(模型推理)

通常的工作流

- 定义问题
- 收集数据集
- 设计模型
- 模型训练
  -  损失函数
  -  优化问题
- 测试


### Image Classification

难就难在很难定义这样一个东西，或者说很难用硬编码来描述一个识别“猫”的程序。

解决办法是 data-driven approach

pipeline

## Linear Classifier

最早叫感知机

简单 & 基本

$$
f(x,W) = W x + b
$$

合适比较大？

- $x$ 与 $W$ 的对应行相似时
- 决策边界：$w^Tx+b = 0$ ~ A line in 2D, a plane in 3D or hyperplane ...

### Training

如何找到最佳的参数？

- loss function
- optimization problem

最小二乘法的缺点

- 容易收到噪声影响
- 对于 classifier 的问题，很难用“做差”来描述得分与类别的关系——让他从任意数映射到一个 `[0,1]`，sigmoid，可以理解成“概率”。i.e. softmax operator: $.....$

评价两个概率分布是否相似，常用的是交叉差，cross entropy as loss function

$$
...
$$


## Neural Networks

线性分类最早叫感知机，perceptron

然而有些分类可能是非线性的，如图

![]()

这种时候我们可能会使用一个函数将它与线性分类映射起来，这种函数一般叫激活函数 activation functions

- ReLU
- Sigmoid

多类别表示

### 多层感知机 Multi-layer perceptron

$$
...
$$

hidden layers

> 如果没有非线性激活函数，最后等价于一个单层线性感知机

Neural Networks

深度神经网络 Deep Neural Networks 层数多 => 

- 表达能力 ⬆️
- 参数 ⬆️
- 训练数据 ⬆️ 成本 ⬆️ 
- 优化问题求解难度 ⬆️

全连层 Fully connected layer 

- 单层参数量巨大（W 大）

## Convolution Neural Networks

> What is CNN?
> What is convolution?
> Layer Types:
> 1. Convolutional layer
> 2. Pooling layer
> 3. Fully-connected layer

![]()

在 CV 中，有时候图像的局部特征就够我们进行分类。这意味着我们可能不需要让网络连上所有的部分。

1 个网络 -> 3 个网络，with weight sharing，因为 3 个网络都是用来识别同样的东西的，或者说功能相同。

$$
... P58
$$

padding & pooling & stride

好处是参数比全连层少很多

感受野 Receptive fields

- 层数越多，一般越大
- ![]() P69

### 池化层

把不同地饭的结果结合在一起，将响应图的多个结果合并为同一个

---

CNN 一般过程 

![]() P71

CNN 经典网络：AlexNet, VGG, 

---

不同 channel 单独做 ----> [Batch Normalization](#batch-normalization)

## Training Neural Networks

虽然我们没法找到一个非常好的方法设计一个“最佳”的网络，但是如何寻找其中最好的参数则是有一系列严格的方法。

loss function

- classification: cross-entropy
- regression: L2 loss

optimization

最小化 loss function，使用各种梯度下降

This training method is called 后向/反向传播 back-propagation

$$
... P83
$$

求梯度-》复合函数求导-》链式法则

对于现在的深度学习工具来说，反向传播与求导等过程都可以自动实现，也就是说我们只需要设计好网络结构和 loss function 即可，而优化部分则可以通过工具实现。

随机梯度下降，随机的采样一部分点，$\Omega$ @P86，

### Architecture & hyper-parameters

无法通过那些能够自动计算的权重，涉及到网络设计的一些内容的一些参数，成为超参数 hyper-parameters。

方法：试（当然不是用手试x）！

How to prevent overfitting?
• Cross validation and early stop
• Regularization or dropout
• Data augmentation


> 如何评价结果“好”还是“不好”？
>
> 如何分割数据集？(cross validation: train & validation & test)

Data split idea * 3

![]() P89（cs231n also）

> 一种违和感，validation 参与自动反馈，test 难道不算一种人为反馈吗？

### 正则化

增加约束以减少 over fit [](Lec04.md)

### Dropout

训练时忽略一部分响应，测试的时候仍然使用

> 旭宝：Dropout说的简单一点就是：我们在前向传播的时候，让某个神经元的激活值以一定的概率p停止工作，这样可以使模型泛化性更强，因为它不会太依赖某些局部的特征。

> 统计上等效于 L2
>
> 我：因为每个点都有可能概率性失效，泛化性更强，这也要求某一个特征的contributes会被“分摊”开来，所以效果上有点像L2的那种让权重更小

### 数据增广 Data augmentation

overfit 及数据太少训练太多，所以我们可以通过对已有数据变换来“造”一些数据出来，比如翻转、拉伸……

### Batch Normalization

对多个 channel 对结果进行归一化操作

Reduce internal covariate shift，以减少 channal 之间的发散性，更稳定更收敛

> For more: https://web.eecs.umich.edu/~justincj/teaching/eecs498/FA2020/

### Deep Learning Frameworks

- Caffe 老东西
- TF 开发者更喜欢
- PyTorch 研究者更喜欢

## Network Architectures


早期不受欢迎：效果差 & 可接受性差

### ResNet

假设数据量够大，是不是层数越多越好？

- 难训练，“梯度消失”，层数太多以后，到后面梯度就很小了，下降不下去了
- 但是为什么会变差呢？
  - 如何设计增加层数而至少不变差呢？
    - ResNet: $H(x) = F(x) + x$
    - 残差学习 residual learning

### DenseNet

更加稠密的链接，本层取决于前面所有层

### MobileNets

速度快

---

NAS: Neural Architecture Search 自动化网络结构设计，learning to learn