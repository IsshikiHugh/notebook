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



## Training Neural Networks







## Network Architectures





