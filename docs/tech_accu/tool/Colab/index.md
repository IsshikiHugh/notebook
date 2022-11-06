# Google Colaboratory


!!! summary "简介"
    Google Colab 是一个允许编写和执行代码的交互式环境，以下是分别为 Colab 的网址以及官方 Q&A。
    
    - Colab URL: [🔗](https://colab.research.google.com) 
    - A&Q: [🔗](https://research.google.com/colaboratory/faq.html)

    
    ---

> 对我来说，Golab 为我提供了一个比较方便且有一定算力的在线平台，而且我觉得作为笔记本貌似也挺好用的。

简单来说，Colab 中存在 **文本单元** 和 **代码单元** 这两种模块。

- 在文本单元中，你可用集成$\LaTeX$、`HTML`、富文本、Markdown 等；
- 而对于代码单元，你则可以直接把它当作一个`Python`解释器：

![](1.png)

- 同时，在一行的最前面加上`!`表示这是一个终端命令
- 例如在 **代码单元** 中输入`!pwd`就等价于在终端中输入`pwd`
- 但在 **代码单元** 中输入`pwd`则会报错，因为这不是一个`Python`命令

从用途上来讲，Colab 在数据科学和机器学习这两方面有较大用处。

- 数据科学: [🔗](https://colab.research.google.com/#scrollTo=UdRyKR44dcNI)
- 机器学习: [🔗](https://colab.research.google.com/#scrollTo=OwuxHmxllTwN)

## 文件互动

Colab 自带文件浏览界面

通过这三个按钮可以实现 **上传文件**、**刷新**、**装载 Google 云盘**：

<center markdown>![](3.png)</center>

## 硬件加速

![](4.png)

关于GPU加速的具体信息，请查看这里 [🔗](https://research.google.com/colaboratory/faq.html#gpu-availability)。

## 资源限制

- 关于资源限制的官方说明: [🔗](https://research.google.com/colaboratory/faq.html#resource-limits) 

  - **条目**：
    - 为什么 Colab 不能保证资源供应？
    - Colab 的用量限额是多少？
    - Colab 提供哪些类型的 GPU？
    - 在 Colab 中，笔记本可以运行多长时间？
    - Colab 提供多大内存？
    - 如何才能充分利用 Colab？
    - 系统显示一条消息，提示我没有使用 GPU。我该怎么办？

## 奇技淫巧

### 占用显存

当你的整个项目需要`GPU`但是现在不太需要的时候，可以通过下面这样一段代码来先占用一部分显存。

```python
import torch
## about 1.1 GB
a = torch.Tensor([1000, 1000, 1000]).cuda()
```

### 查看显卡信息

```python
!nvidia-smi
```

### 挂载 Google Drive

```python
from google.colab import drive
drive.mount('/content/drive/')
```

### 可参考资料

- [https://zhuanlan.zhihu.com/p/387509768](https://zhuanlan.zhihu.com/p/387509768)
- [https://itiandong.com/2021/colab-tips/](https://itiandong.com/2021/colab-tips/)

## 其他资料

- [https://jishuin.proginn.com/p/763bfbd316dc](https://jishuin.proginn.com/p/763bfbd316dc)

