<br />
<p align="center">
  <h3 align="center">
	Vgr_pixmap test repository
  </h3>

  <p align="center">
    Temporary repository to store test programs for the WIP
    <a href="https://github.com/EmileRolley/vgr-pixmap"<code>Vgr_pixmap</code></a>
    renderer.
  <!-- <br /> -->
   <!--  <a href="https://github.com/github_username/repo_name"><strong>Explore the docs »</strong></a> -->
    <br />
   <!--  <a href="https://github.com/github_username/repo_name">View Demo</a> -->
    <a href="https://github.com/EmileRolley/sustainable-computing-resources/issues">Report Bug</a>
    ·
    <a href="https://github.com/EmileRolley/sustainable-computing-resources/pulls">Contribute</a>
  </p>
</p>



<details>
  <summary>Table of Contents</summary>

<!-- vim-markdown-toc GitLab -->

* [Results](#results)
  * [Rendering time comparison](#rendering-time-comparison)

<!-- vim-markdown-toc -->

</details>

---

## Results

Result images produced by the `Vgr_cairo` and `Vgr_pixmap` are stored in `./imgs/`.

And could be re-rendered by executing:
```
dune build && ./_build/default/bin/main.exe
```

### Rendering time comparison


|                   `Vg` image (1181x1181) | `Vgr_cairo` rendering time | `Vgr_pixmap` rendering time |
|-----------------------------------------:|:--------------------------:|:---------------------------:|
|               two_stroked_straight_lines |          0.055174s         |          0.000070s          |
|                         closed_sub_paths |          0.055282s         |          0.000061s          |
|   imbricated_filled_squares_not_same_dir |          0.058220s         |          0.004771s          |
| cairo-imbricated_filled_squares_same_dir |          0.075290s         |          0.012154s          |
|                           closed_cbezier |          0.058570s         |          0.000137s          |
|                           filled_cbezier |          0.054751s         |          0.006338s          |
|                     mult_filled_cbeziers |          0.054836s         |          0.003525s          |
|                           simple_qbezier |          0.056556s         |          0.000127s          |
|                       non_zero_rule_star |          0.052657s         |          0.004548s          |
|                       even_odd_rule_star |          0.053657s         |          0.003701s          |
|                                     poly |          0.055466s         |          0.007711s          |
|                              scaled_poly |          0.058964s         |          0.002356s          |
|                               moved_poly |          0.058006s         |          0.002909s          |
|                            rotated_poly' |          0.058723s         |          0.003000s          |
|                          tr_matrix_poly' |          0.057560s         |          0.001019s          |
