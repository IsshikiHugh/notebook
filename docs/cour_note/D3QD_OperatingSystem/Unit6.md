# Unit 6: 文件系统 | File System [未完成]

!!! info "导读"

    在[存储](./Unit5.md){target="_blank"}一章，我们提到过，卷(volume)做初始化时，需要建立一个文件系统。文件系统提供了数据存储形式的逻辑视图，将数据以**文件(file)**的形式从硬件存储中抽象出来，并使用**目录(directory)**对文件进行进行结构化的组织和管理。

## 文件

一个文件是**存储在二级介质上**的，**具名**的一系列相关**信息集合**，无论是用户还是程序，都需要通过文件来与二级介质进行信息交换。

### 文件属性

不同的文件系统下，文件可能有不同的属性，但通常有以下几个（当然还有其它的）：

- `name`：这是唯一的以 human-readable 形式保存的信息，即文件名；
- `identifier`：在文件系统中用于唯一标识一个文件；
- `type`：一些文件系统需要支持不同的文件类型，此时这些信息用于标识类型；
- `location`：标识文件在哪个设备的哪个位置；
- `size`：当前文件大小，也可能包含文件被允许的最大大小；
- `protection`：访问控制信息，决定哪些用户具有对应的读/写/执行权限等；
- `timestamp`：保存创建时间、上次修改时间、上次使用时间等，这些信息可用来做一些安全保护和使用监控；
- `user indentification`：创建者、上次修改者、上次访问者等，这些信息可用来做一些安全保护和使用监控；

这些信息也被称为文件的元数据(meta data)。

### 文件操作

操作系统可以提供相关的系统调用来完成一些基本的文件操作，例如：

- `create`：分为两步，⓵ 在文件系统中为文件[分配](#分配){target="_blank"}一块空间，⓶ 在[目录](#目录结构){target="_blank"}中创建对应的条目；
- `open` / `close`：打开文件后会得到文件的句柄(handle)，其它对特定文件的操作一般都需要通过这个句柄来完成，类似于“与文件建立一个会话”，关闭文件就是“结束这个会话”；
    - 通常来说，文件被打开后需要由用户来负责关闭；
    - 打开后的文件会被加入到一个打开文件表(open-file table)中，这个表中保存了所有打开的文件的信息，包括文件的**句柄**、文件的**位置**、文件的**访问权限**等；
    - 文件可能被多方用户（进/线程）打开，而只有所有用户都关闭文件后才应当释放文件在打开文件表中的条目，所以维护一个 open-file count 用于记录当前文件被打开的次数，有点类似智能指针；
- `read` / `write`：维护一个 current-file-position pointer 表示当前操作的位置，在对应位置上做读写操作，有一点像[图灵机](https://note.tonycrane.cc/cs/tcs/toc/topic3/){target="_blank"}；
- `repositioning within a file`：将 current-file-position pointer 的位置重新定位到给定值（如文件开头或结尾），也被叫做 `seek`；
- `delete`：在 directory 中找到对应条目并删除该条目，如果此时对应的文件没有其它[硬链接](#hard-link){target="_blank"}，则需要释放其空间，类似于智能指针；
- `truncate`：清空文件内容，但保留文件属性；
- [`locking`](https://en.wikipedia.org/wiki/File_locking){target="_blank"}；

> 在 C 的文件操作函数中，你都能看到类似的操作。

### 权限保护

不同的文件操作对应着不同的权限。

理论上，文件的所属者应当能够决定能对文件做什么操作，以及谁具有这些权限，这个权限通过**访问控制列表(access control list, ACL)**来维护用户们对文件所具有的权限。但是这么做的坏处是，构建 ACL 性价比低，而且原先固定长的表项可能不定长了。

因此，可以精简化这个列表。例如，Unix 和 Linux 系统采用了**访问权限位(access permission bits)**的方式来实现权限控制：

???+ eg "🌰"

    在 Linux 中，我们使用 ls -l 就可以看到当前目录下文件的权限。

    ```shell
    $ ls -l
    total 72
    -rw-r--r--   1 isshikih  staff  18658 Oct 18 23:51 LICENSE
    -rw-r--r--   1 isshikih  staff   1778 Dec 18 10:27 README.md
    lrwxr-xr-x   1 isshikih  staff     18 Nov 21  2022 _deploy.sh@ -> scripts/_deploy.sh
    lrwxr-xr-x   1 isshikih  staff     16 Nov 21  2022 _sync.sh@ -> scripts/_sync.sh
    drwxr-xr-x  14 isshikih  staff    448 Oct 29 22:53 docs/
    drwxr-xr-x  33 isshikih  staff   1056 Nov  3  2022 mkdocs-material/
    -rw-r--r--@  1 isshikih  staff  10937 Dec 21 10:01 mkdocs.yaml
    drwxr-xr-x   3 isshikih  staff     96 Nov  2  2022 overrides/
    drwxr-xr-x   5 isshikih  staff    160 Oct 10 15:39 scripts/
    drwxr-xr-x  19 isshikih  staff    608 Dec 20 21:39 site/
    ```

    第一列中有 10 个字符，其含义如下：

    > A "d" indicates a directory. The second set of three characters represent the read, write, and execution rights of the file's owner. The next three represent the rights of the file's group, and the final three represent the rights granted to everybody else. We'll discuss this in more detail in a later lesson.[^3]

    后 9 个字符将权限被分为三组，分别代表文件所有者(owner)、文件所属组(group)、其他人(other)的**读\(r)**、**写(w)**、**执行(x)**权限。


### 文件类型

对操作系统来所，文件主要分为**数据(data)**和**程序(program)**两大类。而对用户来说，我们通常会认为后缀扩展(extension)标识了一个文件的类型。例如我们会认为 `sketch.psd` 是 Photoshop 的工程文件，`img.png` 是一个图片文件，`main.exe` 是一个可执行文件。但实际上，这些后缀扩展更多的只是一种“提示”，只是用来帮助系统选择合适的方式来打开文件，而不是决定文件的类型，是否要参考后缀名，应当由开发者来决定。

UNIX 系统会在文件开头，使用一串 magic number 来标识文件的类型，例如图片文件的开头通常是 `0xFFD8`[^1]，脚本文本文件开头会以类似 `#!bash` 的形式来指定由谁来执行（例如这个是用 `bash` 执行）。但是需要注意，并非所有文件都支持 magic number，所以并不能仅仅用 magic number 来实现文件类型的判断。

### 文件结构

文件结构指的是文件数据存储的形式，由操作系统或用户程序决定。常见的文件结构有：

- 无结构：流式的存储所有的 words/bytes，UNIX 就定位仪所有文件就是普通的一串字节；
- 简单记录结构(simple record structure)：将文件以 record 为单位存储，record 的长度可以是 fixed 也可以是 variable 的，例如数据库文件；
- 复杂结构(complex structures)；

## 访问方式

访问方式即数据的存取方式，最简单也最常见的访问方式是**顺序访问(sequential access)**，即像磁带那样，逐 byte 或者逐 record 地访问。

另一种方法是**直接访问(direct access)**或**相对访问(relative access)**/**随机访问(random access)**，即支持以几乎相同的时间访问任意位置。

在直接访问的方法之上，还有可能提供索引，即先通过索引表得知所需访问的内容在哪里，然后去访问。在此之上还有一种**索引顺序访问(indexed sequential-access)**。

## 目录结构

目录本质上是一个特殊的文件，而实际上，目录下文件的元信息是被存储在目录中的。目录的结构表示的是目录下文件的组织方式，接下来我们介绍若干目录结构的设计。

### 单级目录

最原始的实现方式，不存在分组策略，所有的文件都被铺在根目录下。

<figure markdown>
<center> ![](img/52.png){ width=80% } </center>
Single-level directory.
</figure>

!!! not-advice "disadvantages"
    
    - 为了实现索引，文件的名字必须是唯一的；
    - 随着文件数量的增大，这个设计愈发不合理；

### 二级目录

特指以用户为依据，将文件分组。即**主文件目录(master file directory, MFD)**下为每个用户分配一个**用户文件目录(user file directory, UFD)**，每个用户的目录下再存放该用户的文件。

<figure markdown>
<center> ![](img/53.png){ width=80% } </center>
Two-level directory structure.
</figure>

由于出现了分层结构，所以对文件的索引从依赖文件名转为依赖文件路径(path)。

!!! advice "advantages"

    - 相比于[单级目录](#单级目录){target="_blank"}，不同用户目录下的文件名可以相同了；

!!! not-advice "disadvantages"

    - 并没有从根源上解决无法分组的问题；

### 树形目录

树形目录(tree-structured directories)将目录视为一种特殊文件，即将“目录”的概念通用化，于是允许用户在目录下自由地创建目录进行分组，于是总体文件结构成为一种树形结构。

<figure markdown>
<center> ![](img/54.png){ width=80% } </center>
Tree-structured directory structure.
</figure>

文件都相当于树上的一个节点，非目录节点都是叶子节点，目录节点都是非叶子节点（不考虑空目录）。为了在这种结构下找到唯一确定的那个文件，我们需要提供文件的**路径(path)**，分为**绝对路径(absolute path)**和**相对路径(relative path)**两种。

> 这东西太简单了，只要有 Linux 实践经历就肯定搞得明白，所以我就不展开了。没有 Linux 实践经历建议先有 Linux 实践经历。

!!! advice "advantages"

    - 解决了自由分组的问题，使文件系统的结构化管理能力大大增强；


### 无环图目录

无环图目录(acyclic-graph directories)是在树形目录的基础上，允许目录之间存在链接关系，链接分为软链接(soft link)和硬链接(hard link)两种。

<figure markdown>
<center> ![](img/55.png){ width=80% } </center>
Acyclic-graph directory structure.
</figure>

!!! section "soft link"

    软链接又称符号链接(symbolic link)，是一个指向文件的指针，类似于 Windows 下的快捷方式。

    删除被软链接指向的那个文件并不会连带地处理软链接，但是原先的这个软链接已经失效了。
    
    从本质上来看，软链接是特殊的文件。

<a id="hard-link" />
!!! section "hard link"

    硬链接是复制链接文件目录项的所有元信息，存到目标目录中，此时文件平等地属于两个目录。

    由于此时文件等价地属于复数个目录，所以在文件元信息被更新时，需要保证在若干目录下该文件的信息是一致的。
    
    删除被硬链接的文件并不会直接导致文件被删除，只有当用来记录「被硬链接数量」的 reference counter 被减至 0，即不再有其他硬链接指向该文件时，文件才会被删除；其他情况下都只需要在当前目录中删除该表项，并将 reference counter 减 1，更新相关元信息即可。

    从本质上来看，硬链接是目录表项。

在无环图目录(acyclic-graph directories)中，为了保证无环，我们只允许创建关于文件这种叶子节点的硬链接[^2]。不过这个说法存在一个例外，我们都知道通常在任意路径都会有 `.` 和 `..` 这两个特殊目录，它们通过硬链接分别指向当前目录和父目录（根目录的父目录也是根目录）。

此外，由于硬链接本质上是表项，而表项与文件系统相关，所以硬链接只能在同一个文件系统下创建，无法跨越 file-system boundary。

### 通用图目录

[无环图目录](#无环图目录){target="_blank"}通过保证不存在环来保证文件系统的简介性，避免遍历目录时候出现死循环或者删除文件时出现的循环依赖等问题。

而通用图目录(general-graph directories)则允许目录之间存在环，但是在各种操作时，通过算法来避免出现问题，例如部分能处理环的图遍历算法、垃圾回收机制等。

<figure markdown>
<center> ![](img/56.png){ width=80% } </center>
General graph directory.
</figure>

## 文件系统挂载

文件系统**挂载(mount)**是指将一个文件系统的根目录挂载到另一个文件系统的某个目录（被称为 mount point），使得这个目录下的文件可以访问到被挂载的文件系统中的文件。只有被挂载了，一个文件系统才能被访问。

<figure markdown>
<center> ![](img/57.png){ width=80% } </center>
Volume mounted at /users.
</figure>

[^1]: [ISO/IEC 10918-1: 1993(E) p.36](https://www.digicamsoft.com/itu/itu-t81-36.html){target="_blank"}，其中 SOI (Start Of Image) 的值为 `0xFFD8`。
[^2]: [Why are hard links not allowed for directories?](https://askubuntu.com/questions/210741/why-are-hard-links-not-allowed-for-directories/525129#525129){target="_blank"}
[^3]: [File Permissions](https://linuxcommand.org/lc3_lts0030.php){target="_blank"}