# [大一暑假] Deep Learning for Computer Vision (CS231N)

## 前言 🎓

???+ summary "课程介绍"
    - 因为我只能找到 17 年的视频，所以是跟着 17 年的版本学。
    
    **Course Website**: [🔗](http://cs231n.stanford.edu/)
    
    **Course Video**: [🔗](https://www.youtube.com/playlist?list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv)
    
    **Course Description**
    
    - Computer Vision has become ubiquitous in our society, with applications in search, image understanding, apps, mapping, medicine, drones, and self-driving cars. Core to many of these applications are visual recognition tasks such as image classification, localization and detection. Recent developments in neural network (aka “deep learning”) approaches have greatly advanced the performance of these state-of-the-art visual recognition systems. This course is a deep dive into the details of deep learning architectures with a focus on learning end-to-end models for these tasks, particularly image classification. During the 10-week course, students will learn to implement and train their own neural networks and gain a detailed understanding of cutting-edge research in computer vision. Additionally, the final assignment will give them the opportunity to train and apply multi-million parameter networks on real-world vision problems of their choice. Through multiple hands-on assignments and the final course project, students will acquire the toolset for setting up deep learning tasks and practical engineering tricks for training and fine-tuning deep neural networks.
  
    **Assignments**

    - Assignment 1: [🔗](https://cs231n.github.io/assignments2022/assignment1/)
    - Assignment 2: [🔗](https://cs231n.github.io/assignments2022/assignment2/)
    - Assignment 3: [🔗](https://cs231n.github.io/assignments2022/assignment3/)

??? note "参考资料"
    - 学长笔记：[🔗](https://github.com/Zhang-Each/Awesome-CS-Course-Learning-Notes/tree/master/Stanford-CS231N-NeuralNetwork%26DL)

## Lecture 1: Introduction to Convolutional Neural Networks for Visual Recognition

!!! note ""
    - Video: [🔗](https://www.youtube.com/watch?v=vT1JzLTH4G4&list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv) 
    - Slides: [🔗](http://cs231n.stanford.edu/slides/2017/cs231n_2017_lecture1.pdf) 


![](1.png)
![](2.png)

- 一些早期的关于 CV 的思考

![](3.png)

- 早期对如何表示物体，超越「Block World」的表示方法

<figure markdown>
![](4.png)
其核心思想是将复杂的视觉信息简化为简单对象的组合。
</figure>

人们意识到直接识别物体比较困难，于是想到了 **分割图形(image segmentation)** ——即先做将像素分组：

![](5.png)

- 启发：视觉识别的重点可以从识别对象的一些具有识别力和不易变化的部分开始

![](6.png)

~~有端联想 FDS 的 Voting Tree~~

- 总的而言 **对象识别** 是 CV 领域的一个重要话题
- 该课程重点为 **卷积神经网络(Convolutional Neural Network / CNN)**
- 具体着眼点为 **图像分类问题(image classification)**
- 也将涉及 **对象检测(object detection)**、**图像字幕(image captioning)** 等问题

## Lecture 2: Image Classification Pipeline

!!! note ""
    - Video: [🔗](https://www.youtube.com/watch?v=OoUX-nOEjG0&list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv&index=2) 
    - Slides: [🔗](http://cs231n.stanford.edu/slides/2017/cs231n_2017_lecture2.pdf) 
    - CIFAR-10 & CIFAR-100: [🔗](https://www.cs.toronto.edu/~kriz/cifar.html) 
    - **前置**：Python Numpy Tutorial: [🔗](https://cs231n.github.io/python-numpy-tutorial/)

- **语义鸿沟(semantic gap)**

### Data-Driven Approach

1. Collect a dataset of images and labels;
2. Use Machine Learning to train a classifier;
3. Evaluate the classifier on new images;
- 得到的模型有两个核心 API：一个用于 **训练(train)**，一个用于 **预测(predict)**。
- 一般情况下，我们不介意训练时间长，但希望预测效率高。

> CIFAR-10 & CIFAR-100: [🔗](https://www.cs.toronto.edu/~kriz/cifar.html) 

<figure markdown>

**Distance Metric** to compare images

![](7.png)
> 我们将分类问题看作在“空间”中的染色问题，点表示训练数据，其颜色表示其被标记的分类；而画板中其他部分的颜色则表示当点落在这个位置时候会被分类为哪一种。

![](8.png)
> 中间“黄色部分”这种孤立的小岛在实际对数据进行预测工作时可能不是很好。

![](9.png)
> 这些部分可能有噪声或是虚假的。             

</figure>

=== "**L1 (Manhattan) distance**:  _(stupid in most cases)_"
    !!! info ""
        - $d_1(I_1,I_2)=\sum_{p}|I_1^{p}-I_2^{p}|$

        <center> ![](10.png)![](11.png) </center>
        
        - 如果图像旋转，预测结果会发生改变。

=== "**L2 (Euclidean ) distance**:  _(better by comparison)_"
    !!! info ""
        - $d_2(I_1,I_2)=\sum_{p}\sqrt{(I_1^p-I_2^p)^2}$

        <center> ![](12.png)![](13.png)</center>

---

**K-Nearest Neighbors**: [🔗](https://zh.wikipedia.org/wiki/K-%E8%BF%91%E9%82%BB%E7%AE%97%E6%B3%95)

> _Interactive Demo_: [🔗](http://vision.stanford.edu/teaching/cs231n-demos/knn/)

Instead of copying label from nearest neighbor, take **majority vote** from K closest points.

![](14.png)
> 例如，K=1 时中间的黄色区域由于附近都是绿点，所以在 K 增长的时候绿色在计算中的权重变大，所以最后被标记为绿色。s

- _当然，这种通过比较“距离”的分类方案并不仅限于图片等，对于任何需要分类的数据，例如文本，只要能定义能够量化的“距离”以及一系列相应的规则，就能使用这种方法来进行分类。_
- 然而，**K-临近算法** 在图像分类上几乎不怎么使用，主要是因为它实际使用起来，<u>预测效率较低</u>；且<u>“距离度量”并不非常适合图像处理</u>_（它无法完整描述图像上的距离信息或图像之间的差异）_；此外它还有一个比较严重的问题：**维数灾难(curse of dimensionality)** [🔗](https://zh.wikipedia.org/wiki/%E7%BB%B4%E6%95%B0%E7%81%BE%E9%9A%BE) _（因为只有训练样本足够密集，K-临近算法才能正常运行）_。

---

### Hyperparameters

- Choices about the algorithm that we **set rather than learn**.

- eg: best **k** to use; best **distance** to use (L1/L2);

**Setting Hyperparameters (调参)**

![](15.png)
> 即，我们需要确保足够的训练集，并通过验证集进行调参，并在一切都完成以后才使用测试集来验证模型的准确度。

![](16.png)

---

### Linear Classification

Parametric Approach

$$
f(x,W)=Wx+b
$$

![](17.png)
> 这里的 10 numbers 表示的是 CIFAR-10 中的 10 个类别对应的得分。

- 即，我们构造一个函数，输入包含图像数据 $x$ 和权重参数 $W$，满足其计算结果为各个类别的预测得分
- 最终得到一个模版，它将尝试性地适应该类里尽可能多的样本

![](18.png)

![](19.png)
> 如果将高维空间的情况映射到平面的几何角度来理解，就好像在划一道道直线来进行划分。

- 从这种角度来理解就很容易发现，单一的线性分类具有局限性，例如对于多模态的数据，使用单一的线性分类可能会比较吃力。

## Lecture 3: Loss Functions and Optimization

!!! note ""
    - Video: [🔗](https://www.youtube.com/watch?v=h7iBpEHGVNc&list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv&index=3) 
    - Slides: [🔗](http://cs231n.stanford.edu/slides/2017/cs231n_2017_lecture3.pdf) 

- Linear classifier is an example of parametric classifier.
- 我们可以这样理解 Linear Classifation 中的 $W$：矩阵中的每一个参数表示了每一个像素点(单个颜色通道)对于识别某个类的贡献权重。

- A loss function that quantifies our unhappiness with the scores across the training data, tells how good our current classifier is. 
- Given a dataset of examples $\{(x_1,y_i)\}_{i=1}^N$, where $x_i$ is image and $y_i$ is label. And loss over the dataset is a sum of loss over examples: $L = \frac{1}{N}\sum L_i(f(xi,W),y_i)$.
- Loss function 是用来度量 $W$ 的合适程度的，我们通过寻找在 $W$ 空间中损失函数取最值时的 $W$ 来找到我们认为最合适的 $W$。

### Multi-class SVM Loss

如何理解那张图？(hinge loss?)

Let $s = f(x_i,W)$, then SVM loss is:

$$
L_i = \sum_{j \not = y_i } \left\{
    \begin{align*}
        &0              &\text{if } s_{y_i} \geq s_j + 1\\
        &s_j-s_{y_i}+1  &\text{otherwise}
    \end{align*}
\right. = \sum_{j \not = y_i } \text{max}(0,s_j-s_{y_i}+1)
$$

- 也就是说，对于某一个样本，它实际类别对应的得分如果远大于（我们需要一个边界 ，就是上图中的$+1$）某个其他类别的得分，那么该“其他类别”对损失函数的贡献即为$0$；反之，如果并没有远大于其他某个类别的得分，则需要将这个偏差作为对损失函数的贡献。

![](20.png)
![](21.png)

```python
def L_i_Vectorized(x, y, W):
    scores = W.dot(x)
    margins = np.maximum(0, scores - scores[y] + 1)
    margins[y] = 0
    loss_i = np.sum(margins)
    return loss_i
```

- Overview

$$
f(x,W) = Wx\\
L = \frac{1}{N}\sum_{i=1}^{n}\sum_{j\not = y_i}\text{max}(0,f(x;W)_j-f(x_i;W)_{y_i}+1)
$$

![](22.png)

- However, for that we only calculate a loss in terms of the data, some strange things like **overfitting** will happen.

![](23.png)

- 蓝点为模型训练数据，绿色的为验证或者实际数据等。
- 蓝色的为过拟合后模型训练出来的预测趋势，他们完全符合训练模型的数据，但是可以发现，绿色的线条才是实际的我们希望得到的趋势。
- 这种预测结果过度拟合了训练数据的行为及为过拟合。

To solve it, we use **regularization**.

![](24.png)
> The regularization term.

![](25.png)
> Occam's Razor

- The regularization term encourages the model to somehow pick a simpler $W$ depending on the dask and the model.

So your standard loss function usually has two terms, a data loss and a regularization loss, and there's a **hyperparameter**(mentioned already in L2) here, lambda, which trades off between the two.

### Regularization

There are many regularizations used in practice, and the most common one is probably **L2 regularization** or **weight decay**. 

In common use:

- L2 regularization: $R(W) = \sum_{k}\sum_lW_{k,l}^2$;
- L1 regularization: $R(W) = \sum_k\sum_l |W_{k,l}|$;
- Elastic net (L1+L2): $R(W) = \sum_k\sum_l (\beta W_{k,l}^2+|W_{k,l}|)$;
- Max norm regularization
- Dropout
- Fancier: Batch normalization, stochastic depth...

The whole idea of regularization is just any thing that you do to your model, that sort of penalizes somehow the complexity of the model, rather than explicitly trying to fit the training data.
Each regularization has its own feature, you should choose them depends on the problems.

### Softmax Classifier (Multinomial Logistic Regression) 

- It normalizes the scores to a probability distribution.
   - Then we just want the probablity of the true class is high and as close to one.
- scores = unnormalized log probabilities of the classes
-  $P(Y=k|X=x_i)=\frac{e^{s_k}}{\sum_j e^{s_j}}\;,\;\;where\;s=f(x_i;W)$;
- That is $L_i=-\log P(Y=y_i|X=x_i)=-\log(\frac{e^{s_k}}{\sum_j e^{s_j}})$;

![](26.png)
> eg for Softmax Classifier.

![](27.png)
> Compare the two.


- 在实际使用中，SVM 在保证真实标签对应的得分高于其他得分一定量后就接受了，即存在一个明确的突变标准；而对于 Softmax 来说，它会在这个过程中不断将正确标签对应的概率向$1$逼近，不断优化自己。

![](28.png)

### Optimization

- Strategy #1: A first _very bad _idea solution: Random search
- Strategy #2: **Gradient Descent** / Follow the **slope**(gradient$\nabla$)
   - Always use analytic gradient, but check implementation with numerical gradient. This is called a **gradient check.**

```python
## Vanilla Gradient Descent

while True:
    weights_grad = evaluate_gradient(loss_fun, data, weight)
    weights += - step_size * weights_grad ## perform parameter update
```
`step_size` is a **hyperparameter** here, it's also called a **learning rate** sometimes.
**Stochastic Gradient Descent (SGD)**
- The basic Gradient Descent will be messy when $N$ is large!
- So we need to start with approximate sum using a **minibatch** of examples.
   - 32 / 64 / 128 common

```python
## Vanilla Gradient Descent

while True:
    data_batch = sample_training_data(data, 256) ## sample 256 examples
    weights_grad = evaluate_gradient(loss_fun, data_batch, weight)
    weights += - step_size * weights_grad ## perform parameter update
```

- **Online Demo**: [🔗](http://vision.stanford.edu/teching/cs231n-demos/linear-classify/)

### Aside: Image Features

![](29.png)
![](30.png)
![](31.png)
![](32.png)





---

# Things below not applied yet.

## Lecture 4: Introduction to Neural Networks

[🔗](https://www.youtube.com/watch?v=d14TUNcbn1k&list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv&index=4) Video
[🔗](http://cs231n.stanford.edu/slides/2017/cs231n_2017_lecture4.pdf) Slides

**Computational graphs**
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1661926558403-ceb752a5-8c67-44c0-9710-d695178096ca.png#clientId=u92d02bd5-69d0-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=244&id=ubdf6a28b&margin=%5Bobject%20Object%5D&name=image.png&originHeight=305&originWidth=848&originalType=binary&ratio=1&rotation=0&showTitle=true&size=65988&status=done&style=shadow&taskId=u93e3bb10-4af7-4863-86e2-70036ee8967&title=eg.%20for%20the%20linear%20classifier.&width=678.4 "eg. for the linear classifier.")
**Backpropagation**
通过将算式写成这种“节点图”的形式，可以进一步让我们看清计算过程并方便我们计算梯度。具体来说，例如$f(x,y,z)=(x+y)z$，将其写成节点图如下，并计算所需要的参数。
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094352514-ccc05dd7-9f2d-4373-96ad-cb538ed4ac71.png#clientId=u940a9301-d778-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=170&id=u6aff39f2&margin=%5Bobject%20Object%5D&name=image.png&originHeight=218&originWidth=476&originalType=binary&ratio=1&rotation=0&showTitle=false&size=33927&status=done&style=shadow&taskId=ud2fff276-4279-4736-a038-aad6b784d88&title=&width=371)     ![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094404407-789cc324-198b-438e-8682-ea1149902883.png#clientId=u940a9301-d778-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=170&id=u75333fad&margin=%5Bobject%20Object%5D&name=image.png&originHeight=253&originWidth=451&originalType=binary&ratio=1&rotation=0&showTitle=false&size=50212&status=done&style=shadow&taskId=u722d9937-32b7-4c64-8d39-d5ebad0ed80&title=&width=303)
然后我们从图的末端开始计算，得到这些节点数据：

$\left\{
\begin{aligned}
&\frac{\partial{f}}{\partial{f}}=1,\\
&\frac{\partial{f}}{\partial{z}}=q=3,\\
&\frac{\partial{f}}{\partial{q}}=z=-4,\\
&\frac{\partial{f}}{\partial{x}}=\frac{\partial{f}}{\partial{q}}\frac{\partial{q}}{\partial{x}}=-4,\\
&\frac{\partial{f}}{\partial{y}}=\frac{\partial{f}}{\partial{q}}\frac{\partial{q}}{\partial{y}}=-4
\end{aligned}
\right.$

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094787671-9428b3d4-e6ca-4f7e-8453-a6b827a7abc7.png#clientId=u940a9301-d778-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=106&id=CyxhW&margin=%5Bobject%20Object%5D&name=image.png&originHeight=320&originWidth=492&originalType=binary&ratio=1&rotation=0&showTitle=false&size=41320&status=done&style=shadow&taskId=u38e8ac2b-4ae1-4ade-9fb6-74a73e4a217&title=&width=163)![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094798526-b165d7ba-7361-415d-8ba2-0813f367ec77.png#clientId=u940a9301-d778-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=106&id=u8aa60156&margin=%5Bobject%20Object%5D&name=image.png&originHeight=338&originWidth=487&originalType=binary&ratio=1&rotation=0&showTitle=false&size=43056&status=done&style=shadow&taskId=u4dd0839b-d125-45d7-a171-8ed67b01999&title=&width=153)![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094841227-3bf6ad6b-d658-4858-9474-f9c9ca7432eb.png#clientId=u940a9301-d778-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=106&id=u34c509f2&margin=%5Bobject%20Object%5D&name=image.png&originHeight=342&originWidth=489&originalType=binary&ratio=1&rotation=0&showTitle=false&size=46360&status=done&style=shadow&taskId=u18bfcf23-f6ef-49a9-8236-b4296057635&title=&width=152)
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094949463-9efb77c5-9360-4c4e-8bfe-3e322bf774b9.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=106&id=u07a281fd&margin=%5Bobject%20Object%5D&name=image.png&originHeight=321&originWidth=490&originalType=binary&ratio=1&rotation=0&showTitle=false&size=47118&status=done&style=shadow&taskId=u7dc6d18c-9081-48f9-8075-29baefefd8e&title=&width=162)![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662094959583-24c94484-9504-4813-b357-feaa08315ba8.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=106&id=u8dda4ea8&margin=%5Bobject%20Object%5D&name=image.png&originHeight=314&originWidth=490&originalType=binary&ratio=1&rotation=0&showTitle=false&size=48929&status=done&style=shadow&taskId=u49fe4b6d-87e6-43c6-b0f3-5ea040056f9&title=&width=165)

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662095196409-e727181a-98ef-4e32-9ae5-328ee7b6f748.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=377&id=uf5deedcc&margin=%5Bobject%20Object%5D&name=image.png&originHeight=471&originWidth=960&originalType=binary&ratio=1&rotation=0&showTitle=true&size=129451&status=done&style=shadow&taskId=u7a87ccce-347e-41f9-b746-8c83c3768f1&title=backprop%20%28red%20lines%29&width=768 "backprop (red lines)")
可以发现，我们在计算过程中只需要将“相邻”梯度乘以"local gradient"即可计算出所需要的新的"local gradient"。而只需要再沿着路径再将所有的"local gradient"累乘起来，就能得到每一个变量关于表达式的梯度。
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662095551007-8758a9b5-6a11-4169-982e-98ddb1ef5b22.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&id=u73a3cc75&margin=%5Bobject%20Object%5D&name=image.png&originHeight=554&originWidth=1158&originalType=binary&ratio=1&rotation=0&showTitle=false&size=207665&status=done&style=shadow&taskId=uf611daf5-5775-43ac-b0a5-9970fe2376c&title=)
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662095644605-355df07d-77a8-4dc5-ba17-615a6d18f70a.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=195&id=u3b8ae8a9&margin=%5Bobject%20Object%5D&name=image.png&originHeight=350&originWidth=588&originalType=binary&ratio=1&rotation=0&showTitle=false&size=68127&status=done&style=shadow&taskId=ubf50001a-a11c-43bd-a2be-03efd55e5ce&title=&width=328)![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662095787716-82499f8d-e8dd-4b40-b744-f276b532a0a1.png#clientId=u75e002cd-f71b-4&crop=0.1742&crop=0&crop=0.9703&crop=1&from=paste&height=155&id=uffb2b043&margin=%5Bobject%20Object%5D&name=image.png&originHeight=256&originWidth=646&originalType=binary&ratio=1&rotation=0&showTitle=false&size=50817&status=done&style=shadow&taskId=u5b56d5bc-cca0-4134-99df-03acf05582f&title=&width=392)
特别的，由于节点是我们认为定义的，而且该方法所依赖“链式法则”也允许函数的自由组合，所以我们可以人为“合并/分割”一些节点，例如在上面那个例子中，我们可以将最后四个节点合并为一个"sigmoid function"(i.e. $\frac{1}{1+e^{-x}}$)。
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662096256516-8a201b6d-a028-4b36-8bfa-2007713196ec.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=422&id=u01e9dfa8&margin=%5Bobject%20Object%5D&name=image.png&originHeight=528&originWidth=1080&originalType=binary&ratio=1&rotation=0&showTitle=false&size=189451&status=done&style=shadow&taskId=u2869bd4c-67f2-43ca-81cf-2f8d88c61fd&title=&width=864)
**Patterns in backward flow**
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662096486759-666c3153-1716-421c-93b4-0e040cb94ebd.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=310&id=u273883e7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=388&originWidth=1111&originalType=binary&ratio=1&rotation=0&showTitle=true&size=146199&status=done&style=shadow&taskId=u8a07f74b-2776-404b-a756-93c53edbd10&title=%E5%8F%A6%E5%A4%96%E4%B8%80%E7%A7%8D%E7%90%86%E8%A7%A3%E7%AE%97%E7%AC%A6%E5%9C%A8%E8%AE%A1%E7%AE%97%E5%9B%BE%E4%B8%AD%E7%9A%84%E4%BD%9C%E7%94%A8%E7%9A%84%E6%80%9D%E8%B7%AF%E3%80%82&width=888.8 "另外一种理解算符在计算图中的作用的思路。")
可以发现，`max()`运算在梯度传递过程中只起到路由器的作用，也就是说将其传递到较大的那个变量那一侧，但不改变梯度的值；而对于较小的那个变量，梯度传递被阻断，目标变量的梯度为$0$。
将这个流程迁移到神经网络上，我们只需要将这些数字变为 Jacobian matrix 即可。
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662097315555-bc421009-62af-46e7-a83a-23ac210a7543.png#clientId=u75e002cd-f71b-4&crop=0&crop=0.0084&crop=1&crop=1&from=paste&height=176&id=ue7867603&margin=%5Bobject%20Object%5D&name=image.png&originHeight=562&originWidth=1144&originalType=binary&ratio=1&rotation=0&showTitle=false&size=133802&status=done&style=shadow&taskId=u77b5c463-8f22-4cbc-8cd2-e40e831e9ab&title=&width=359) ![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662097300960-2880c190-f74f-4f4c-a28d-5b1b764c9e91.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=175&id=aMjPy&margin=%5Bobject%20Object%5D&name=image.png&originHeight=563&originWidth=1148&originalType=binary&ratio=1&rotation=0&showTitle=false&size=181001&status=done&style=shadow&taskId=u29a62e1b-f8b0-48ae-b7ab-36df39f1e64&title=&width=357)
- Always check: The **gradient** with respect to a variable should have the **same shape** as the variable.
   - Because each element of your gradient is **quantifying** **how much** that element is **contributing** to your final output.

在具体实现中，我们一般会实现一个`forward()`用于计算函数的输出，以及一个`backward()`用于按照上面提到的方法计算梯度。
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662097899735-c76fadf6-326c-4cce-85e3-96438fbcaa31.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=192&id=u4e60e55e&margin=%5Bobject%20Object%5D&name=image.png&originHeight=447&originWidth=744&originalType=binary&ratio=1&rotation=0&showTitle=false&size=212801&status=done&style=shadow&taskId=u7a6adb3a-52f9-41c5-9045-5076578688c&title=&width=320) ![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662098058403-d9a228dc-d58e-40d0-af00-7741644aade6.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=192&id=u59b69b84&margin=%5Bobject%20Object%5D&name=image.png&originHeight=443&originWidth=913&originalType=binary&ratio=1&rotation=0&showTitle=false&size=127998&status=done&style=shadow&taskId=uae14eb05-1b7d-457d-a3e8-215fd8e881b&title=&width=396)
**Summary**
- Neural nets will be very large: impractical to write down gradient formula by hand for all parameters.
- **Backpropagation **= recursive application of the chain rule along a computational graph to compute the gradients of all inputs/parameters/intermediates.
- Implementations maintain a graph structure, where the nodes implement the `**forward()**` / `**backward()**` API.
   - **Forward**: compute **result **of an operation and save any intermediates needed for gradient computation in memory.
   - **Backward**: apply the chain rule to compute the **gradient **of the loss function with respect to the inputs.

**Neural Networks**
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662100500579-bcc57e07-9f5a-4c5d-b5fb-8b4458667ab5.png#clientId=u75e002cd-f71b-4&crop=0&crop=0.1307&crop=1&crop=1&from=paste&height=451&id=u3eed4861&margin=%5Bobject%20Object%5D&name=image.png&originHeight=564&originWidth=1112&originalType=binary&ratio=1&rotation=0&showTitle=false&size=256672&status=done&style=shadow&taskId=u61952589-7539-40af-8b01-c099cb4bbca&title=&width=890)
通过函数叠加的方式来实现神经网络。
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662100617343-1e86dcd4-6760-4857-9a4c-46b95f46cc2a.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=451&id=u76969c7d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=564&originWidth=1170&originalType=binary&ratio=1&rotation=0&showTitle=true&size=166137&status=done&style=shadow&taskId=u290f5796-e610-4a15-9beb-1cc072e5b60&title=%E4%B8%8E%E7%94%9F%E7%89%A9%E7%A5%9E%E7%BB%8F%E7%9A%84%E4%B8%80%E4%B8%AA%E7%B1%BB%E6%AF%94&width=936 "与生物神经的一个类比")
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662100753740-27277a19-481e-4ac4-b220-f8cb6368c56a.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=0.9836&from=paste&height=455&id=u5712f1ea&margin=%5Bobject%20Object%5D&name=image.png&originHeight=568&originWidth=1126&originalType=binary&ratio=1&rotation=0&showTitle=false&size=117566&status=done&style=shadow&taskId=ud2267ddd-6185-4e94-91ca-ba59cd68bb2&title=&width=901)
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662100835551-f8e2e51e-aaae-4939-a75f-e121b0587bd9.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=178&id=u9ced8d30&margin=%5Bobject%20Object%5D&name=image.png&originHeight=549&originWidth=1159&originalType=binary&ratio=1&rotation=0&showTitle=false&size=369978&status=done&style=shadow&taskId=u5019ebe9-637a-4eab-aabf-98921bbe2e1&title=&width=376)![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662100896268-d929ed17-eb96-4cef-bb2a-cbc864956602.png#clientId=u75e002cd-f71b-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=178&id=u35f8bc77&margin=%5Bobject%20Object%5D&name=image.png&originHeight=554&originWidth=1071&originalType=binary&ratio=1&rotation=0&showTitle=false&size=428533&status=done&style=shadow&taskId=uc43ab531-583c-4c9b-ba6f-e45d1e2a081&title=&width=344)
**Summary**
- We arrange neurons into **fully-connected layers**.
- The **abstraction **of a **layer **has the nice property that it allows us to use efficient vectorized code (e.g. matrix multiplies).
- Neural networks are not really neural.

## Lecture 5: Convolutional Neural Networks
[🔗](https://www.youtube.com/watch?v=bNb2fEVKeEo&list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv&index=5) Video
[🔗](http://cs231n.stanford.edu/slides/2017/cs231n_2017_lecture5.pdf) Slides

**Convolutional Neural Networks**
之前提到过的 Fully Connected Layer 会将多维的数据拉伸为向量的形式，相比之下， Convolution Layer 则会保留输入数据的形状**特征**，一般来说，filter 会与数据具有相同的深度（例如 input 是 32x32x3，那么 filter 可以为 5x5x3）。通过将 filter 与 input 的某一个同形状的子区域做点积，我们就可以得到一个数字。
- _Convolve the filter with the image. (i.e. "slide over the image spatially, computing dot products")_

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662778616456-4c661045-fca7-4f98-adbd-9460dd230792.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=312&id=u00fedce3&margin=%5Bobject%20Object%5D&name=image.png&originHeight=390&originWidth=843&originalType=binary&ratio=1&rotation=0&showTitle=true&size=66769&status=done&style=shadow&taskId=u08a3e835-a8e4-4e06-8b29-7205c257573&title=%E5%9C%A8%E6%9F%90%E4%B8%AA%E4%BD%8D%E7%BD%AE%E8%8E%B7%E5%BE%97%E7%82%B9%E7%A7%AF%EF%BC%8C%E5%8D%B3%20filter%20%E5%A6%82%E4%BD%95%E4%BD%9C%E7%94%A8%E4%BA%8E%20input&width=674.4 "在某个位置获得点积，即 filter 如何作用于 input")
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662778922924-61f20e8a-64f2-4d72-8ee0-7a6fb3ab8e5e.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=175&id=u3469dbff&margin=%5Bobject%20Object%5D&name=image.png&originHeight=386&originWidth=822&originalType=binary&ratio=1&rotation=0&showTitle=false&size=44328&status=done&style=shadow&taskId=ub3b1a169-046c-4034-aeb7-c96fc8c2558&title=&width=373)  ![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662779019849-c2497280-1a95-4f95-b636-bf33d6243738.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=175&id=ucfebd984&margin=%5Bobject%20Object%5D&name=image.png&originHeight=469&originWidth=895&originalType=binary&ratio=1&rotation=0&showTitle=false&size=53574&status=done&style=shadow&taskId=u781d4018-a35a-4fa3-97d6-42662048dee&title=&width=334)
采用多个 filters 并将结果叠加，我们就可以得到多个激活图(activation maps)，作为一个处理后的数据。
- _ConvNet is a sequence of Convolution Layers, interspersed with activation functions._

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662780472229-1aa4373d-1508-4da9-b32e-841435d8ac16.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=286&id=uff9f1496&margin=%5Bobject%20Object%5D&name=image.png&originHeight=358&originWidth=883&originalType=binary&ratio=1&rotation=0&showTitle=false&size=44369&status=done&style=shadow&taskId=ua9a50793-94ba-4856-acae-ac2c0ae8a23&title=&width=706.4)
关于输出的激活图的大小，有如上公式。
通过选择步长，我们可以控制滑动的速率。从某种意义上来讲这也是在控制滑动结果的分辨率，也是池化操作背后的思想之一。而具体选择大步长还是小步长是你需要对各种因素进行考量决定的。
可以发现，步长为 3 时无法匹配。而在实践过程中，我们有一些手段来解决这种无法匹配的情况，如"zero pad to borders"以使大小符合步长。
- _The zero padding __does add some sort of extraneous features at the corners__, and we're doing our best to get some value and do, like process that region of the image. And so zero padding is kind of one way to do this. There's __also other ways__ to do this that, you know, you can try and like, mirror the values here or extend them, and so it doesn't have to be zero padding, but __in practice this is one thing that works reasonably__._

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662780648310-3a86f775-2cdd-4f20-ae3b-7ffa8a0cd8e9.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=362&id=u565fb487&margin=%5Bobject%20Object%5D&name=image.png&originHeight=452&originWidth=929&originalType=binary&ratio=1&rotation=0&showTitle=true&size=109534&status=done&style=shadow&taskId=u6279e545-571e-4ca9-95e7-ecc373d7b8d&title=%E6%B3%A8%E6%84%8F%EF%BC%8C%E9%87%87%E7%94%A8%E9%9B%B6%E6%89%A9%E5%B1%95%E4%BB%A5%E5%90%8E%E4%B8%8A%E4%B8%80%E5%BC%A0%E5%9B%BE%E7%9A%84%E5%85%AC%E5%BC%8F%E5%B0%B1%E6%97%A0%E6%B3%95%E4%BD%BF%E7%94%A8%E4%BA%86%E3%80%82%E8%BF%99%E4%B9%9F%E6%AD%A3%E6%98%AF%E9%9B%B6%E6%89%A9%E5%B1%95%E7%9A%84%E4%B8%80%E4%B8%AA%E7%89%B9%E7%82%B9%EF%BC%8C%E5%AE%83%E5%8F%AF%E4%BB%A5%E8%AE%A9%E5%9B%BE%E5%83%8F%E7%9A%84%E5%BD%A2%E7%8A%B6%E4%B8%8D%E5%BF%85%E7%BC%A9%E5%B0%8F%E3%80%82&width=743.2 "注意，采用零扩展以后上一张图的公式就无法使用了。这也正是零扩展的一个特点，它可以让图像的形状不必缩小。")
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662781477669-28b50a57-109f-419b-a8fe-bd792abca8e3.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=190&id=u3ca29e98&margin=%5Bobject%20Object%5D&name=image.png&originHeight=237&originWidth=945&originalType=binary&ratio=1&rotation=0&showTitle=true&size=36284&status=done&style=shadow&taskId=u64ccf793-366b-4871-8eb3-e997ba4f4ac&title=%E4%B8%80%E9%81%93%E6%B5%8B%E8%AF%95%E9%A2%98%EF%BC%8C%E8%AE%A1%E7%AE%97%E8%BF%99%E6%A0%B7%E4%B8%80%E5%B1%82%E4%B8%AD%E6%9C%89%E5%A4%9A%E5%B0%91%E5%8F%82%E6%95%B0%E3%80%82&width=756 "一道测试题，计算这样一层中有多少参数。")

Ans- Each filter has $5\times5\times3_{\text{(depth)}} + 1_{\text{(for bias)}} = 76$ params.
- So the total number is $76\times 10 = 760$.

**Pooling layer**
- makes the representations smaller and more manageable
- operates over each activation map independently:

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662783361516-3f949cb8-6ea1-41dd-8450-9bfff55f04cc.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=277&id=ua85e54b7&margin=%5Bobject%20Object%5D&name=image.png&originHeight=346&originWidth=437&originalType=binary&ratio=1&rotation=0&showTitle=true&size=69724&status=done&style=shadow&taskId=u7c47bbcd-e8f4-4551-a6a6-f29d66b8a7f&title=just%20downsample&width=349.6 "just downsample")
A common way to do this is max pooling:
![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662783517400-2e3bd335-ad6d-437b-8823-743b06982cd7.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=369&id=u53f5dd65&margin=%5Bobject%20Object%5D&name=image.png&originHeight=461&originWidth=809&originalType=binary&ratio=1&rotation=0&showTitle=true&size=42815&status=done&style=shadow&taskId=u60ec636c-49b6-4554-97f7-262765e93d3&title=just%20take%20the%20max%20value&width=647.2 "just take the max value")
对于池化层，在进行滑动窗口时我们更希望步长的设置能使 filter 没有重叠，以满足小节开头提到的"independently"。

**Fully Connected Layer (FC layer)**
- Contains neurons that connect to the entire input volume, as in ordinary Neural Networks.

![](https://cdn.nlark.com/yuque/0/2022/png/22387144/1662784708958-0b1cbaf5-07fb-47ab-b132-dcf2a797cdee.png#clientId=u992d708c-53fe-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=249&id=u09f3adff&margin=%5Bobject%20Object%5D&name=image.png&originHeight=311&originWidth=649&originalType=binary&ratio=1&rotation=0&showTitle=false&size=184807&status=done&style=shadow&taskId=u3d835372-5e6d-417c-b2e9-0d24d45b9bb&title=&width=519.2)

## Assignments

 - 请查看子文章：[Assignments](assignments/index.md)




