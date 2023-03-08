# Lecture 2 | Red Black Tree & B+ Tree

!!! info "说明"
    上一节使用的用 Tab 绘图的方式时间成本太高了，所以我应该会放弃使用这种画图的方法。

    而为了提高笔记整理效率，可能会考虑用更多的引用和更简单的语言。如果您觉得有哪里说的不够清楚，请直接在评论区狠狠 blame 我！

## 红黑树

!!! quote "link"
    OI Wiki: https://oi-wiki.org/ds/rbtree/
    
    Wikipedia: https://en.wikipedia.org/wiki/Red%E2%80%93black_tree

顾名思义，**红黑树(Red Black Tree)**就是一种节点分类为红黑两色的，比较平衡的二叉搜索树。只不过不同于 AVL 树，红黑树的“平衡”性质是通过**黑高(black height)**来定义的。接下来依次给出红黑树的定义和黑高的定义。

!!! definition "Red Black Tree"
    ![](img/6.png)

    红黑树是满足如下性质的一种二叉搜索树：

    !!! feature "Properties of RBTree"

        \@cy's PPT
        
        1. Every node is either red or black.
        2. The root is black.
        3. Every leaf (`NIL`) is black.
        4. if a node is red, then both its children are black.
        5. For each node, all simple paths from the node to descendant leaves contain the same number of black nodes.

        ---

        \@Wiki:

        1. Every node is either red or black.
        2. All `NIL` nodes (figure above) are considered black.
        3. A red node does not have a red child.
        4. Every path from a given node to any of its descendant `NIL` nodes goes through the same number of black nodes.

        ---

        \@OI Wiki:

        1. 每一个节点要么是**红**色，要么是**黑**色；
        2. `NIL` 节点（空叶子节点）为**黑**色；
        3. **红**色节点的子节点必须为**黑**色；
        4. 从根节点到 `NIL` 节点的每条路径上的**黑**色节点数量相同；

!!! definition "black height, bh"
        特定节点的黑高，等于该节点到叶结点到简单路径中，黑色节点到数量。

        ---
        
        \@Wiki:
        
        The black height of a red–black tree is the number of black nodes in any path from the root to the leaves, which, by property 4, is constant (alternatively, it could be defined as the black depth of any leaf node).


---

## B+ Tree