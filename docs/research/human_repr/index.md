# Body Models

!!! advice "Motivation"

    写了一些 [Jupyter Notebooks](https://github.com/IsshikiHugh/LearningHumans) 来记录一些实用工具的实用方法和小部分细节。但不适合做速查，所以在笔记里开一栏专门做速查。

## SMPL Family

### SMPL

```python title="smpl-inference"
body_model_smpl = smplx.SMPL(
        model_path = Path(<input_root>) / 'body_models' / 'smpl',
        gender     = gender,
    )
smpl_out = body_model_smpl(
        betas         = torch.zeros(B, 10),
        global_orient = torch.zeros(B, 1, 3),
        body_pose     = torch.zeros(B, 23, 3),
        transl        = torch.zeros(B, 3),
    )
joints = smpl_out.joints    # (B, 45, 3)
verts  = smpl_out.vertices  # (B, 7890, 3)
```

```python title="smpl-auxiliary"
faces = body_model_smpl.faces  # (13776, 3), numpy.ndarray
J_regressor = body_model_smpl.J_regressor  # (24, 6890)
```

### SMPL-X

```python title="smplx-inference"
body_model_smpl = smplx.SMPLX(
        model_path = Path(<input_root>) / 'body_models' / 'smplx',
        gender     = gender,
        batch_size = <batch_size>,
    )
smplx_out = body_model(
        betas         = torch.zeros(B, 10),
        global_orient = torch.zeros(B, 3),
        body_pose     = torch.zeros(B, 63),
        transl        = torch.zeros(B, 3),
    )
joints = smplx_out.joints    # (B, 127, 3)
verts  = smplx_out.vertices  # (B, 10475, 3)
```


