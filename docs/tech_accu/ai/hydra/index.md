# Hydra

!!! quote "相关链接"
    - 官方文档 [🔗](https://hydra.cc/docs/intro/)
    - 笔记 [🔗](https://cloud.tencent.com/developer/article/1587877  )

!!! info "简介"
    Hydra 亦可用于其它 Python APP，但本文只以 Research 的视角来谈这个工具。

    在进行实验时，我们可能会希望一个项目能支持切换其中的若干部件，就好像给机器人更换不同的部件，来测试其性能。而每一个部件都有可能有自己的超参数需要设置。

    硬编码设置当然不可取，这太不优雅了。所以我们通常使用命令行参数，即 args 来实现超参数的传入。但随着模型越来越复杂，需要的超参数越来越多，命令行就会越来越长；而且不同的“部件”可能需要不同的超参数，因此，使用命令行参数灵活性就大大下降了。

    因此，我们考虑把这些东西放在文件里，需要修改时就直接修改文件，这样修改参数相对就灵活一些。更进一步的，我们还可以通过将不同的组合分别保存为一个文件，用指定特定文件的方式来选择一个已经设置好的 pipeline。

    但是这样还有两个问题，首先，这样写的话，配置文件的复用率是比较低的，因为各个配置之间差别可能不大，可能互相只有一小部分的不同，而复用率低的坏处就不必多说了；其次，就算我们用层次化的配置文件来解决复用的问题，我们在实际代码里也需要使用繁复的分支语句才能很好地控制配置的选择。

    于是，Hydra 应运而生。Hydra 会以特定的方式处理层次化的配置文件，它的行为很像 Cpp 的 `#include`，会把选中的后代 Group 里的配置文件嵌入到当前配置文件里。

    ---

    更具体的关于 Hydra 的规范，请参考官方文档，本文主要对官方文档做一些补充，通过实验探索一些 Hydra 文档中没有提到的性质。

---

## 关于 +A=B 语法

在文档中，有两个地方提到了 +A=B 的语法。第一次是在[这里](https://hydra.cc/docs/tutorials/basic/your_first_app/simple_cli/)：

> You can add config values via the command line. The `+` indicates that the field is new.
> 
> ```shell
> $ python my_app.py +db.driver=mysql +db.user=omry +db.password=secret
> db:
>   driver: mysql
>   user: omry
>   password: secret
> ```
>
> ??? extra "files"
>     ```python title="my_app.py"
>     from omegaconf import DictConfig, OmegaConf
>     import hydra
> 
>     @hydra.main(version_base=None)
>     def my_app(cfg: DictConfig) -> None:
>         print(OmegaConf.to_yaml(cfg))
> 
>     if __name__ == "__main__":
>         my_app()
>     ```

第二次是在[这里](https://hydra.cc/docs/tutorials/basic/your_first_app/config_groups/)：

> Select an item from a config group with `+GROUP=OPTION`, e.g:
> 
> ```
> $ python my_app.py +db=postgresql
> db:
>   driver: postgresql
>   pass: drowssap
>   timeout: 10
>   user: postgres_user
> ```
> 
> ??? extra "files" 
>     ```plaintext title="Directory layout"
>         ├─ conf
>         │  └─ db
>         │      ├─ mysql.yaml
>         │      └─ postgresql.yaml
>         └── my_app.py
>     ```
>     
>     ```yaml title="db/mysql.yaml"
>     driver: mysql
>     user: omry
>     password: secret
>     ```
>     
>     ```yaml title="db/postgresql.yaml"
>     driver: postgresql
>     user: postgres_user
>     password: drowssap
>     timeout: 10
>     ```
> 
>     ```python title="my_app.py"
>     from omegaconf import DictConfig, OmegaConf
>     import hydra
> 
>     @hydra.main(version_base=None)
>     def my_app(cfg: DictConfig) -> None:
>         print(OmegaConf.to_yaml(cfg))
> 
>     if __name__ == "__main__":
>         my_app()
>     ```

前者表示增加一个 field，后者表示指定一个 group，其含义是不同的，而看起来是有歧义的。

根据我的测试，`+A=B` 具体是哪一种，取决于是否存在名为 A 的 folder。即：

- 如果存在名为 A 的 folder，则 `+A=B` 表示指定 A group 里的 `b.yaml` 项；
- 如果不存在名为 A 的 folder，则 `+A=B` 表示增加一个 field，其 key 为 A，value 为 B；

---

更进一步的，只要当前目录存在名为 `A` 的 folder，那么在**当前** `yaml` 文件中就无法将 `A` 作为一个 field 的 key。

之所以强调**当前**，是因为它可以被父母的 `yaml` 文件中的，以 `A` 为 key 的 k-v 对覆盖。

例如，虽然添加 `A=1` 替换作为 group 的 `A` 会报错，但是添加 `A.B=1` 却可以覆盖 `A` 下的作为 group 的 `B`；亦或在最的 `config.yaml` 里添加这样一段也可以起到同样的效果：

```yaml
A:
  B: 1
```

即，对于“无法将 group 覆盖为 field”这件事的保护，只有目录一层内有效。

---

## 覆盖关系

首先，除了在上一节提到的关于 field 和 group 的覆盖关系，更重要的是在不同层的 yaml 之间，相同键的值的覆盖关系。

首先，单看 defaults，官方在文档中有提到规则：

> The defaults are ordered:
> 
> - If multiple configs define the same value, the last one wins.
> - If multiple configs contribute to the same dictionary, the result is the combined dictionary.

此外，如果已经在内层 defaults 设置了键的默认值，就不能在外层为这个键设置默认值，反之亦然。

!!! eg "🌰"
    例如下面这两个文件中，`- group1/group2: option1_1` 和 `- group2: option1_1` 这两行是冲突的，只能选其一的。

    ```yaml title='config.yaml'
    defaults:
      - group1: option1
      - group1/group2: option1_1
    ```

    ```yaml title='group1/option1.yaml'
    defaults:
      - group2: option1_1
    ```

因此，一般来说尽量避免让配置层数超过两层。

---

而关于 defaults 以外的部分，规则如下：

1. 当最外层的 `config.yaml` 和在 `defaults:` 里指定的 `yaml` 配置文件存在冲突的键时，以 `config.yaml` 里的为准，（无论是否有 `GROUP=OPTION` 选项）；
2. 当键不存在于 `defaults:` 中，而只在命令行中通过 `+GROUP=OPTION` 选中时，以 `OPTION.yaml` 里的为准；