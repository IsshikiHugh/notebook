# Docker

## “何为 Docker” 以及 “我们为什么需要 Docker”

> Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same way you manage your applications. By taking advantage of Docker's methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

- 尽管原理上存在本质不同，但是你可以暂时将它当作一个轻量级的“虚拟机”。
    - 关于 Docker 和 VM 的区别，推荐阅读：Docker vs. Virtual Machines: Differences You Should Know
- 从模式上来讲，Docker 专注于三件事：Build Image, Ship Image, Run Image.
    - 而这里的Image则是学习 Docker 过程中必须理解的一个概念。

设想这样一个背景：

- 你在你的本地机器上写了一个复杂的服务，除了 GoLang 以外还配置了一大堆其他的依赖；
- 这时候你需要把它部署到一个干干净净的服务器上，并且该发行版有很多你并不熟悉的特性……

如果你未曾了解过 Docker，那你或许只能选择再花一个下午在上面配置环境，甚至还会踩到更多的坑；但是如果你会用 Docker，那么你只需要为你的项目写一个 Dockerfile，并确保服务器上安装了 Docker，接下来只需要通过 Docker 直接部署即可。

- 按照我的理解，Docker 就是为了在部署过程中便捷地构建一个必须的环境而存在的。
- 按照上面那个不太恰当的的“虚拟机”的比喻，就是在远程服务器上快速启一个配置好的虚拟机，并在里面运行对应的服务。

---

> 关于如何安装 Docker，这里我们直接略过，请自行搜索如何在你使用的操作系统上安装 Docker。

---

## 关键词辨析

- Image
    - Docker Image 是用来构建 Docker Container 的一系列资源，你可以当它是一个“模板”，而 Container 是其实例化。其本质是一堆静态文件，并不具备执行能力。
- Container
    - Container 是 Image 的实例化，是一系列进程（当然你可以选择停止他们），它们根据 Image 中的内容被初始化创建，并基本上与你的宿主系统隔离，只留下一些用来进行交互的通道。
- Docker Hub
    - 类似于 GitHub，你可以在上面搜索查看公开的 Image，从中挑选你需要的并拉取到本地进行使用。
    - https://hub.docker.com/

## Docker 使用

- 关于命令行的说明，我将融合在之后的内容中在对应的使用场景中介绍，如果想要查看列表类型的命令说明，可以查看：
    - https://docs.docker.com/engine/reference/commandline/cli/
    - https://docs.docker.com/engine/reference/commandline/docker/
- 在这里，我将简单介绍两种 Docker 的使用流程。分别对应“使用 Docker Hub 的 Docker 镜像”和“本地构建镜像并创建容器使用”。
[使用 Docker Hub 的 Docker 镜像]
- 刚好我之前写过一篇用 Docker 安装 FSL 的博客，直接拿这个做介绍了。
  - https://www.yuque.com/isshikixiu/notes/sna3ru
这里只放几个常见的命令，其它命令建议在使用遇到的时候去查阅docs：

```dockerfile
# 拉取image
sudo docker pull {image name}

# 创建容器并进入
sudo docker run -it {image name} {entrance}

# 启动/结束实例
sudo docker start {container id}
sudo docker stop {container id}

# 进入运行中的实例
sudo docker exec -ti {container id} {entrance}

# container操作
sudo docker container ...

# image操作
sudo docker image ...
```

- 查找镜像
    - *Docker Hub 支持命令行交互，但使用起来大概不如直接浏览 Docker Hub 方便，所以这里不做介绍 。
- 使用docker pull 来拉取镜像
- 使用docker run 来生成容器并运行
[本地构建镜像并创建容器使用]
首先，在考虑服务器之前，请先在本地做好这些事：
- 准备好的你的代码。
    - 例如我们需要在服务器上部署一个后端服务，那么首先你需要把这个后端服务的源代码准备好，否则“部署”将无从谈起。
- 写 Dockerfile
    - 具体来说，Dockerfile 指导 Docker 如何构建一个镜像，包括但不限于要如何准备你所需要的依赖、如何组织你的源代码、如何编译你的源代码、镜像中会包含什么等。
    - 关于 Dockerfile 的语法，可以参考我展示的例子，但是并不仅限于这些。

这里提供一个简单的 dockerfile 模版样例：

```dockerfile
# 选取一个 go 的官方镜像作为基础 作为 编译环境
FROM golang:1.18 AS builder

# 设置一些环境变量，其中三个是 golang 所需要的；WORKDIR 是为了方便下面使用而设置的

ENV GOPROXY=https://mirrors.aliyun.com/goproxy/,direct \
    GO111MODULE=on \
    CGO_ENABLED=0 \
    WORKDIR=/tmp/src/

# 运行 'mkdir -p $WORKDIR' 来创建工作目录
RUN mkdir -p $WORKDIR

# 将 . 下的内容全部复制到 $WORKDIR ，也就是 /tmp/src/
COPY . $WORKDIR

# 进入工作目录 并且 进行 go 的包管理操作
RUN cd $WORKDIR && go mod download all

# 进入工作目录 并且 编译
RUN cd $WORKDIR && go build -o /fileName

# 选取 alpine 作为运行环境
FROM alpine:3.15.2

# 复制文件内容
COPY --from=builder /fileName /fileName

# 在启动容器时运行该命令
CMD ["/fileName"]
```

- [非必需] 写一个部署脚本
    - 使用 Docker 已经很大程度上便利了在服务器上的部署，但是仍然还是需要一些步骤，而多数情况写我们需要多次修改源代码并重新部署，为了偷懒提高效率，我们还可以血已干部署脚本来让我们的部署真正实现“一键化”；
    - 由于我们在这个流程中需要在部署端准备源代码，那么将不可避免的涉及到“源代码版本管理”这件事，显然这件事和 Docker 无关（如果你使用在本地把镜像上传到 Docker Hub 上，并在部署端拉取 Image 的模式，那么这件事就和 Docker 有关了），所以我们需要在脚本中写上一些 git 指令；
    - 除此之外，由于我们需要多次重新部署，那么对于老版本的容器和镜像也需要一定的管理，即删除没有用的镜像和容器；
    - 当然，最重要的还有从镜像的构建到容器的运行这一系列操作；


## 推荐资料

- https://yeasy.gitbook.io/docker_practice/
- https://www.runoob.com/docker/docker-tutorial.html
- https://docs.docker.com/