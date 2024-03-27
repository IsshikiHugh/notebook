# [HuMoR] 3D Human Motion Model for Robust Pose Estimation

---

## 名词

- TestOpt: test-time optimization
- $\mathbf{x} = \begin{bmatrix} \mathbf{r} & \dot{\mathbf{r}} & \Phi & \dot{\Phi} & \Theta & \mathbf{J} & \dot{\mathbf{J}} \end{bmatrix}$: state of a moving person
    - $\mathbf{r} \in \R^3$: root translation
    - $\Phi\in\R^3$: root orientation in axis-angle form
    - $\Theta\in\R^{3\times 21}$: body pose joint angles
    - $\mathbf{J}\in\R^{3\times22}$: joint positions
    - $\dot{?}$: 对应的量的速度
- $M(\mathbf{r},\Phi,\Theta,\beta)$: SMPL models，输出 mesh vertices $\mathbf{V}\in\R^{3\times 6890}$ 和 joints $\mathbf{J}^\text{SMPL}\in\R^{3\times22}$，其中 $\beta\in\R^{16}$

## 输入输出

- 输入：（RGB(-D), 2D/3D joint position sequence）
- 输出：准确合理的 motions, contacts

## 方法

1. HuMoR 使用 conditional VAE 的 expressive generative model，学习的是 motion seq 中每一步的变化的分布，而非直接学习 poses
2. 使用 optimization based 方法，利用 HuMoR 作为 motion prior 来鲁棒地估计模糊估计下可能的 pose & shape & ground plane
    - 具体来说，通过两个方面和 HuMoR 进行互动：
    1. 将 motion 参数化到 HuMoR latent space
    2. 利用 HuMoR prior 来向合理的 motion 优化

—[HuMoR motion prior]→ latent transitions $\mathbf{z}_{1:T}$ (with initial state and something relative) —[rollout function]→ motions

- 表达
    - $\mathbf{x} = \begin{bmatrix} \mathbf{r} & \dot{\mathbf{r}} & \Phi & \dot{\Phi} & \Theta & \mathbf{J} & \dot{\mathbf{J}} \end{bmatrix}$
    - 利用其中一部分可以从 SMPL 中恢复出更多信息
    - 从 state 和 SMPL 的输出中都可以获得 joints，冗余表达
- Latent Variable Dynamics Model
    - 建模 states 的时序概率

        $$
        p_\theta(\mathbf{x}_0,\mathbf{x}_1,\cdots,\mathbf{x}_T) = p_\theta(\mathbf{x}_0)\prod\limits_{t=1}^Tp_\theta(\mathbf{x}_{t}|\mathbf{x}_{t-1})
        $$

    - 因此 $p_\theta(\mathbf{x}_t|\mathbf{x}_{t-1})$ 必须能够 handle 变换的合理性，本文使用 CVAE 来实现
    - 分为两个主要部分：
    1. 以 $\mathbf{x}_{t-1}$ 为 condition 建模 $p_\theta(\mathbf{z}_t|\mathbf{z}_{t-1})$：
        - $\mathbf{z}_t\in\R^{48}$ is described by the learned **conditional prior**

            $$
            p_\theta(\mathbf{z}_t|\mathbf{z}_{t-1})=\mathcal{N}(\mathbf{z}_t;\mu_\theta(\mathbf{x}_{t-1}),\sigma_\theta(\mathbf{x}_{t-1}))
            $$

    2. 以 $\mathbf{x}_{t-1}$ 和 $\mathbf{z}$ 为 condition 建模 $p_\theta(\mathbf{x}_t|\mathbf{z}_t,\mathbf{x_{t-1}})$，实际上建模的是 $\Delta_\theta$ 和 $\mathbf{c}_t$：
        - decoder 输出 change in state $\Delta_\theta$ 和 contact probability $\mathbf{c}_t$ ，并通过如下更新来建模 $p_\theta(\mathbf{x}_t|\mathbf{z}_t,\mathbf{x_{t-1}})$：

            $$
            \mathbf{x}_t=\mathbf{x}_{t-1}+\Delta_\theta(\mathbf{z}_t,\mathbf{x}_{t-1})+\eta, \quad\eta\sim\mathcal{N}(0,\mathbf{I})
            $$

        - 通过这种估计改变量的方式，能够提高效果
        - $\mathcal{c}_t$ 评估 { l/r toes, heels, knees, hands } 共 8 个 joints 的触地概率，但它只是 prior 的输出，并不参与 motion prior 的预测，而是在 TestOpt 的时候才被考虑
            - [ ]  **疑问**：为什么不参与呢？参与了会不会更好呢？感觉 transition 和触地地有关很合理啊？
    - 综上所述，可以将这两个部分统合为：

        $$
        p_\theta(\mathbf{x}_t|\mathbf{x}_{t-1}) = \int_{\mathbf{z}_t}
        p_\theta(\mathbf{z}_t|\mathbf{z}_{t-1})
        \cdot p_\theta(\mathbf{x}_t|\mathbf{z}_t,\mathbf{x_{t-1}})
        $$

- rollout function 是 TestOpt 的核心部分：

    $$
    \mathbf{x}_T = f(\mathbf{x}_0,\mathbf{z}_{1:T})
    $$

    - 其具体实现为在每一个 timestep 都进行一次 $\mathbf{x}_t=\mathbf{x}_{t-1}+\Delta_\theta(\mathbf{z}_t,\mathbf{x}_{t-1})$
    - [ ]  **疑问**：$\eta$ 呢？这个式子和表达里的那个式子代表的是同一个过程吗？
- 关于初始状态，使用一个 $K=12$ 的Gaussian mixture model(GMM) 来建模 $p_\theta(\mathbf{x}_0) = \sum_{i=0}^{K=12}\gamma^i\mathcal{N}(\mathbf{x}_0;\mu_\theta^i,\sigma_\theta^i)$

### 训练

训练过程中保证 joint position 和 angle predictions 的一致性

- CVAE 通过 pairs of $(\mathbf{x}_{t-1},\mathbf{x}_t)$ 来训练，考虑通常的 variational lower bound：

    $$
    \log p_\theta(\mathbf{x}_t|\mathbf{x}_{t-1})
    \geq
    \underbrace{
        \mathbb{E}_{q_\phi}\Big[
            \log\big(
                \underbrace{p_\theta(\mathbf{x}_t|\mathbf{z}_t,\mathbf{x_{t-1}})}_\text{decoder}
            \big)
        \Big]
    }_{\mathcal{L}_\text{rec}}
     -
     \underbrace{
         D_\text{KL}\big(
            \underbrace{
                q_{\phi}(\mathbf{z}_t|\mathbf{x}_t,\mathbf{x}_{t-1})
            }_\text{encoder}
            ||
            \underbrace{
                p_{\theta}(\mathbf{z}_t|\mathbf{x}_{t-1})
            }_\text{prior}
        \big)
    }_{\mathcal{L}_\text{KL}}
    $$

    - 其中 encoder 就是 $\mathcal{N}(\mathbf{z}_t;\mu_\phi(\mathbf{x}_t,\mathbf{x}_{t-1}),\sigma_\phi(\mathbf{x}_t, \mathbf{x}_{t-1}))$
- 而我们的目标就是寻找 $(\theta,\phi)$ 能够最小化 loss $\mathcal{L}_\text{rec}+w_\text{KL}\mathcal{L}_\text{KL}+\mathcal{L}_\text{reg}$
    - $\mathcal{L}_\text{rec} = ||\mathbf{x}_t-\hat{\mathbf{x}}_t||^2$，其中 $\hat{\mathbf{x}}_t = \mathbf{x}_{t-1} + \Delta_\theta(\mathbf{z}_t,\mathbf{x}_{t-1})$ ，而 $\mathbf{z}_t \sim q_\phi(\mathbf{z}_t|\mathbf{x}_t,\mathbf{x}_{t-1})$，通过 reparameterization 来保证梯度传播
    - $\mathcal{L}_\text{reg} = \mathcal{L}_\text{SMPL} + w_\text{contact}\mathcal{L}_\text{contact}$
        - 其中 SMPL 项包括：$\mathcal{L}_\text{SMPL} = \mathcal{L}_\text{joint} + \mathcal{L}_\text{vertices} + \mathcal{L}_\text{consist}$
            - $\mathcal{L}_\text{joint} = ||\mathbf{J}_t^\text{SMPL} - \hat{\mathbf{J}}^\text{SMPL}_t||^2$，即 joint 的 pred 和 gt 的差别
            - $\mathcal{L}_\text{vertices} = ||\mathbf{V}_t-\hat{\mathbf{V}}_t||^2$，即 vtx 的 pred 和 gt 的差别
            - $\mathcal{L}_\text{consist} = ||\mathbf{\hat{J}}_t - \hat{\mathbf{J}}_t^\text{SMPL}||^2$，即 state 中的和 SMPL regress 出来的 joint 的一致性
        - contact 项也分为两个部分：$\mathcal{L}_\text{contact}=\mathcal{L}_\text{BCE}+\mathcal{L}_\text{vel}$
            - BCE 项用 binary cross entropy 对 ground contact classification 进行监督
            - vel 项主要是建模接触的点的速度应当趋近 0：$\mathcal{L}_\text{vel}=\sum_j\hat{c}_t^j||\hat{\mathbf{v}}_t||^2$，这里的 v 是速度
    - paper 使用了 $w_\text{contact}=0.01$，$w_\text{KL}=4e^{-4}$


### 优化

- 流程
    - 输入：observations $\mathbf{y}_{0:T}$ 或 2D/3D joints 或 3D point clouds 或 3D key-points
    - 输入 → seek initial shape $\beta$ and SMPL pose parameters $(\mathbf{r}_{0:T},\Phi_{0:T},\Theta_{0:T})$ → parameterize the optimized motion using HuMoR → initial state $\mathbf{x}_0$ & latent transitions $\mathbf{z}_{1:T}$ —[rollout function]→ $\mathbf{x}_T=f(\mathbf{x}_0,\mathbf{z}_{1:T})$
    - 此外，为了实现座标系的转换，还需要优化 ground plane of the scene $\mathbf{g}\in\R^3$
    - 总的起来就是同时优化 $\mathbf{x}_0$，一系列 latent $\mathbf{z}_{1:T}$，地面 $\mathbf{g}$ 以及 shape $\beta$
    - 同时**假设相机静止 & 内参已知**
- 优化目标
    - maximum a-posteriori (MAP)
        - [ ]  **疑问**：这个是什么？check supplementary
    - 寻找一个在提出的 generative model 下 plausible 的 motion，依据是非常匹配 observations：

        $$
        \min_{\mathbf{x}_0,\mathbf{z}_{1:T},\mathbf{g},\beta} \mathcal{E}_\text{mot}+\mathcal{E}_\text{data}+\mathcal{E}_\text{reg}
        $$

        - Motion Prior $\mathcal{E}_\text{mot} = \mathcal{E}_\text{CVAE} + \mathcal{E}_\text{init}$
            - 着眼于 likelihood of the latent transitions $\mathbf{z}_{1:T}$ 以及 initial state $\mathbf{x}_0$ under HuMoR CVAE & GMM，两个 term 分别就对应 conditional prior 和 initial state GMM

            $$
            \mathcal{E}_\text{CVAE} = -\lambda_\text{CVAE}\sum_{t=1}^T\log\mathcal{N}(\mathbf{z}_t;\mu_\theta(\mathbf{x}_{t-1}),\sigma_\theta(\mathbf{x}_{t-1})) \\
            \mathcal{E}_\text{init} = -\lambda_\text{init}\log\sum_{i=1}^K\gamma^i\mathcal{N}(\mathbf{x}_0;\mu_\theta^i,\sigma_\theta^i)
            $$

        - Data Term $\mathcal{E}_\text{data}$
            - 它与输入的类型有关，现在讨论 3D joints, 2D joints, 3D point cloud 这三种，它们的计算对象都与 SMPL 通过 camera frame 下还原出的 joints 和 vertices 有关，下列式子中 $\mathbf{y}$ 都表示观测值，即监督的数据，含义不尽相同

            $$
            \mathcal{E}_\text{data} \triangleq \mathcal{E}_\text{data}^\text{3D}=\lambda_\text{data}\sum_{t=0}^T\sum_{j=1}^J||\mathbf{p}_t^j-\mathbf{y}_t^j||^2
            \\
            \mathcal{E}_\text{data} \triangleq \mathcal{E}_\text{data}^\text{2D}=\lambda_\text{data}\sum_{t=0}^T\sum_{j=1}^J\sigma_t^j\rho\big(\Pi(\mathbf{p}_t^j)-\mathbf{y}_t^j\big)
            \\
            \mathcal{E}_\text{data} \triangleq \mathcal{E}_\text{data}^\text{PC3D}=\lambda_\text{data}\sum_{t=0}^T\sum_{j=1}^Jw_\text{bs}\min_{\mathbf{x}_t\in\mathbf{V}_t} ||\mathbf{p}_t-\mathbf{y}_t^i||^2
            $$

            - 其中 2D 项中，$\sigma_t^j$ 为 detection confidence，$\rho$ 为 Geman-McClure function，使用重投影误差计算
            - 其中 $w_\text{bs}$ 是 robust bisquare weight [8] computed based on the Chamfer distance term
        - Regularizers $\mathcal{E}_\text{reg} = \mathcal{E}_\text{skel} + \mathcal{E}_\text{env} + \mathcal{E}_\text{gnd} + \mathcal{E}_\text{shape}$
            - $\mathcal{E}_\text{skel}$ 保证 state 中的 joints 对应的 skeleton 和 state 中 theta 通过 SMPL 还原出来的 skeleton 的一致性，包含 joints location 和 bone length 两部分

                $$
                \mathcal{E}_\text{skel} = \sum_{t=1}^{T}\left(
                \lambda_c \sum_{j=1}^{J}\left|\left|\mathbf{p}_t^j-\mathbf{p}_t^{j,\text{pred}}\right|\right|^2
                +
                \lambda_b\sum_{i=1}^{B}\left(l_t^i-l_{t-1}^i\right)^2
                \right)
                $$

                - 其中，$\mathbf{p}_t^j \in \mathbf{J}_t^\text{SMPL}$，$\mathbf{p}_t^{j,\text{pred}} \in \mathbf{J}_t$，$l$ 表示的是 bone length
            - $\mathcal{E}_\text{env}$ 保证的是与 environment 和 contact 有关的一些内容，分别保证 contact 以后 joint 尽量不动，以及确保高度在一个 threshold 内

                $$
                \mathcal{E}_\text{env} = \sum_{t=1}^T\sum_{j=1}^{J}\lambda_\text{cv}c_t^j \left|\left|\mathbf{p}_t^j-\mathbf{p}_{t-1}^j\right|\right|^2
                +\lambda_\text{ch}c_t^j \max\left(
                \left|\mathbf{p}^{j}_{z,t}\right| - \delta,0
                \right)
                $$

                - 其中，$\mathbf{p}_t^j \in \mathbf{J}_t^\text{SMPL}$，$\mathbf{p}_{z,t}^j \in \mathbf{J}_t^\text{SMPL}$ 是其 z 分量，即高度分量，$c_t^j$ 是 contact probability
            - $\mathcal{E}_\text{gnd} = \lambda_\text{gnd}||\mathbf{g} - \mathbf{g}^\text{init}||^2$ 是对 ground 的先验，认为地面应当倾向于静止
            - $\mathcal{E}_\text{shape} = \lambda_\text{shape}||\beta||^2$ 是对 shape 的先验，认为 shape 应当倾向于 neutral zero
- 初始化
    - 为了得到初始的 SMPL parameters，需要经过一步 initialization optimization，主要利用 $\mathcal{E}_\text{data}$ 和 $\mathcal{E}_\text{shape}$ 以及两个额外的 regularization terms $\mathcal{E}_\text{pose} = \sum_t||\mathbf{z}_t^\text{pose}||^2$ 以及 $\mathcal{E}_\text{smooth}=\sum_{t=1}^T\sum_{j=1}^j||\mathbf{p}^j_t-\mathbf{p}^j_{t-1}||^2$，其中 $\mathbf{z}_t^\text{pose}\in\R^{32}$ 是用 VPoser 得到的 body joint angles 的 latent space 表达（不是 HuMoR 的 CVAE 得到的）
    - 在这之后，通过 CVAE 的 encoder 得到 initial latent sequence $\mathbf{z}^\text{init}_{1:T}$