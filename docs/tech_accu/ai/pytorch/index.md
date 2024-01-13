# PyTorch

!!! warning "弃坑了，感觉没啥写的必要"

!!! info ""
    - PyTorch 主要有两个用途：
        - 能够使用 GPU 加速的 NumPy 替代品；
        - 内置的自动微分库等对神经网络的实现产生较大的帮助；

???- quote "参考资料"
    - PyTorch 官网：[🔗](https://pytorch.org/)
    - A 60 MINUTE BLITZ：[🔗](https://pytorch.org/tutorials/beginner/deep_learning_60min_blitz.html)
        - *本文主要按照这篇文章的思路来；
    - PyTorch 官方教程中文版：[🔗](https://pytorch.org/tutorials/)
    - PyTorch简明教程：[🔗](http://fancyerii.github.io/books/pytorch/)

## 安装

根据 [这里](https://pytorch.org/get-started/locally/) 提供的方法获取安装途径，注意选择与您的环境相符的条件。

依赖之类的都已经在该页面写的很清楚了。

完成安装后，我们通过如下方法来检测是否安装成功：

```python
$ python
>>> import torch
>>> x = torch.rand(5, 3)
>>> print(x)
tensor([[0.8577, 0.6416, 0.2632],
        [0.3853, 0.8534, 0.4877],
        [0.0628, 0.2360, 0.8810],
        [0.1766, 0.8024, 0.5447],
        [0.3938, 0.9232, 0.4407]])
```

## 张量 | Tensors

Tensors 是 NumPy 中 ndarrys 的一种无痛替代，只不过 tensors 能够有效利用 GPU 进行加速。

### 初始化

显然，初始化有很多方法，这里提供几种。

=== "通过数据生成"
    !!! summary ""
        ```python
        data = [[1, 2], [3, 4]]
        x_data = torch.tensor(data)
        print(x_data)
        ```
        预期输出如下：
        !!! success "Output"
            ```
            tensor([[1, 2],
                    [3, 4]])
            ```
=== "通过 NumPy array 生成"
    !!! summary ""
        ```python
        np_array = np.array(data)
        x_np = torch.from_numpy(np_array)
        print(x_np)
        ```
        预期输出如下：
        !!! success "Output"
            ```
            tensor([[1, 2],
                    [3, 4]])
            ```
=== "通过另外一个 tensor 生成"
    !!! summary ""
        ```python
        x_ones = torch.ones_like(x_data) # retains the properties of x_data
        print(f"Ones Tensor: \n {x_ones} \n")

        x_rand = torch.rand_like(x_data, dtype=torch.float) # overrides the datatype of x_data
        print(f"Random Tensor: \n {x_rand} \n")
        ```
        预期输出如下：
        !!! success "Output"
            ```
            Ones Tensor:
            tensor([[1, 1],
                    [1, 1]])

            Random Tensor:
            tensor([[0.4557, 0.7406],
                    [0.5935, 0.1859]])
            ```
=== "使用常数或随机初始化"
    !!! summary ""
        ```python
            shape = (2, 3)
            rand_tensor = torch.rand(shape)
            ones_tensor = torch.ones(shape)
            zeros_tensor = torch.zeros(shape)

            print(f"Random Tensor: \n {rand_tensor} \n")
            print(f"Ones Tensor: \n {ones_tensor} \n")
            print(f"Zeros Tensor: \n {zeros_tensor}")
        ```
        预期输出如下：
        !!! success "Output"
            ```
            Random Tensor:
             tensor([[0.4434, 0.1717, 0.7331],
                    [0.4211, 0.8945, 0.2239]])

            Ones Tensor:
             tensor([[1., 1., 1.],
                    [1., 1., 1.]])

            Zeros Tensor:
             tensor([[0., 0., 0.],
                    [0., 0., 0.]])
            ```

### 属性

这里主要涉及的张量的属性为 **形状(`shape`)**、**数据类型(`dtype`)** 和 **数据所存储在的硬件设备(`device`)**。

```python
tensor = torch.rand(3, 4)

print(f"Shape of tensor: {tensor.shape}")
print(f"Datatype of tensor: {tensor.dtype}")
print(f"Device tensor is stored on: {tensor.device}")
```

预期输出如下：

!!! success "Output"
    ```python
    Shape of tensor: torch.Size([3, 4])
    Datatype of tensor: torch.float32
    Device tensor is stored on: cpu
    ```

### 方法与操作

对张量的操作方法非常之多，很难在本文中全部涉及，因而也只是放个 **[文档](https://pytorch.org/docs/stable/torch.html)** 在这边，在此只介绍比较基础的几个。

#### 使用 GPU 加速
令人幸喜的是，对张量的这些操作都可以使用 GPU 来进行加速，当然在此之前我们需要将它转移到 GPU 上——如果可以的话。

```python
# We move our tensor to the GPU if available
if torch.cuda.is_available():
    tensor = tensor.to('cuda')
    print(f"Device tensor is stored on: {tensor.device}")
```

!!! success "Output"
    ```python
    Device tensor is stored on: cuda:0
    ```

#### 运算

!!! tips "注意"
    如果一个 tensor 的方法以 `_` 结尾，那么说明这个运算会修改这个 tensor 自身。
    
    即，`x.method_(...)` 将会修改 `x` 本身。

PyTorch 对四则运算符进行了一些重载，其与正常方法的映射关系如下：

|运算符|等价方法|
|:-:|:-:|
|`+`|`torch.add()`|
|`-`|`torch.sub()`|
|`*`|`torch.mul()`|
|`/`|`torch.div()`|

#### 索引与切片

```python
tensor = torch.ones(4, 4)
tensor[:,1] = 0
print(tensor)
```
预期输出如下：
!!! success "Output"
    ```python
    tensor([[1., 0., 1., 1.],
            [1., 0., 1., 1.],
            [1., 0., 1., 1.],
            [1., 0., 1., 1.]])
    ```

