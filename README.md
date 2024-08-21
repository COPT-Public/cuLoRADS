## **[cuLoRADS](https://github.com/COPT-Public/cuLoRADS)**

cuLoRADS is an enhanced GPU-based first-order method solver written in Julia for low-rank semi-definite programming problems (SDPs). 

#### Optimization Problem:

cuLoRADS focuses on solving the following SDP problem:

$$
\min_{\mathcal{A} \mathbf{X} = \mathbf{b}, \mathbf{X}\in \mathbb{S}_+^n} \left\langle \mathbf{C}, \mathbf{X} \right\rangle
$$

##### Features of the problem:

- linear objective
- affine constraints
- positive-semidefinite variables

#### Current release:

cuLoRADS is currently under active development. A pre-built binary that processes SDPA (.dat-s) format files is available. Users testing the solver on Linux can download the release from [the release site](https://github.com/COPT-Public/cuLoRADS/releases).

Then, uncompress the .tar.gz by running

```
tar -xzvf cuLoRADS.tar.gz
```

#### Getting started:

By running

```sh
./bin/cuLoRADS --filePath /PATH/TO/SDPAFILE.dat-s --outputPath /PATH/TO/OUTPUT/FOLDER
```

we can solve SDPs represented in standard SDPA format.



If everything goes well, we would see logs like below:

```
╔════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                            ║
║                            L                           RRRRRR           A          DDDDDD         SSSSSS   ║
║                            L                           R     R         A A         D     D       S         ║
║   CCCCC       U    U       L              OOOO         R     R        A   A        D     D       S         ║
║  C            U    U       L             O    O        RRRRRR        AAAAAAA       D     D        SSSSSS   ║
║  C            U    U       L             O    O        R    R        A     A       D     D              S  ║
║  C            U    U       L             O    O        R     R       A     A       D     D              S  ║
║   CCCCC        UUUU        LLLLLLL        OOOO         R     R       A     A       DDDDDD         SSSSSS   ║
║                                                                                                            ║
╚════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

@ Solver Parameters
    ┌──────────────────┬───────────────┐
  ↳ │ Parameter        │ Value         │
    ├──────────────────┼───────────────┤
    │ initRho          │ 0.00e+00      │
    │ rhoMax           │ 5.00e+03      │
    │ maxALMIter       │ 200           │
    │ maxADMMIter      │ 10000         │
    │ timesLogRank     │ 2.00          │
    │ ALMRhoFactor     │ 2.00          │
    │ ADMMRhoFreq      │ 5             │
    │ ADMMRhoFactor    │ 1.20          │
    │ phase1Tol        │ 1.00e-03      │
    │ phase2Tol        │ 1.00e-05      │
    │ timeSecLimit     │ 3600.00       │
    │ heuristicFactor  │ 1.00          │
    │ lbfgsListLength  │ 2             │
    │ reoptLevel       │ 2             │
    │ dyrankLevel      │ 2             │
    │ highAccMode      │ false         │
    └──────────────────┴───────────────┘

➔ Reading Problem File ✅ (2.09 seconds) 

@ Problem Information
  ↳ sdp block dims: [1296]
  ↳ lp dim: 0
  ↳ number of constraints: 1297

@ Storage Format (S --- Sparse or D --- Dense)
  ↳ objective matrices: [D]
  ↳ vectorized objective matrix: S

➔ Transfering Date To GPU ✅ (0.28 seconds) 

➔ Initializing GPU Solver ✅ (0.91 seconds) 

┌────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                             Start Phase I: ALM                                             │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Initial Ranks: [15]                                                                                        │
├──────┬─────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬──────────┬──────────┤
│ Iter │ In Iter │ P Obj       │ D Obj       │ P Infea 1   │ P Infea Inf │ PD Gap      │ Rho      │ Time     │
├──────┼─────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼──────────┼──────────┤
│ 1    │ 370     │ -1.8973e+07 │ -2.4862e+04 │ 2.0137e+01  │ 1.3059e+04  │ 9.9738e-01  │ 5.56e-02 │ 1.32     │
│ 2    │ 786     │ -2.6310e+04 │ -2.4861e+04 │ 7.2640e-03  │ 4.7107e+00  │ 2.8311e-02  │ 1.11e-01 │ 2.06     │
│ 3    │ 810     │ -2.4900e+04 │ -2.4853e+04 │ 6.4754e-03  │ 4.1993e+00  │ 9.4616e-04  │ 2.22e-01 │ 2.08     │
│ 4    │ 843     │ -2.4541e+04 │ -2.4835e+04 │ 5.8972e-03  │ 3.8244e+00  │ 5.9400e-03  │ 4.44e-01 │ 2.11     │
│ 5    │ 877     │ -2.5152e+04 │ -2.4816e+04 │ 4.9622e-03  │ 3.2180e+00  │ 6.7127e-03  │ 8.89e-01 │ 2.14     │
│ 6    │ 911     │ -2.5057e+04 │ -2.4791e+04 │ 3.7477e-03  │ 2.4304e+00  │ 5.3243e-03  │ 1.78e+00 │ 2.17     │
├──────┴─────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴──────────┴──────────┤
│ Updating Ranks ...                                                                                         │
│ Updated Ranks: [23]                                                                                        │
├──────┬─────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬──────────┬──────────┤
│ Iter │ In Iter │ P Obj       │ D Obj       │ P Infea 1   │ P Infea Inf │ PD Gap      │ Rho      │ Time     │
├──────┼─────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼──────────┼──────────┤
│ 7    │ 1257    │ -2.4996e+04 │ -2.4770e+04 │ 2.3561e-03  │ 1.5279e+00  │ 4.5306e-03  │ 3.56e+00 │ 2.63     │
│ 8    │ 1321    │ -2.4904e+04 │ -2.4756e+04 │ 1.3097e-03  │ 8.4933e-01  │ 2.9834e-03  │ 7.11e+00 │ 2.69     │
│ 9    │ 1380    │ -2.4820e+04 │ -2.4750e+04 │ 5.7590e-04  │ 3.7347e-01  │ 1.4280e-03  │ 1.42e+01 │ 2.75     │
│ 10   │ 1467    │ -2.4770e+04 │ -2.4748e+04 │ 1.8459e-04  │ 1.1971e-01  │ 4.5195e-04  │ 2.84e+01 │ 2.83     │
│ 11   │ 1589    │ -2.4752e+04 │ -2.4748e+04 │ 4.0895e-05  │ 2.6520e-02  │ 8.7843e-05  │ 5.69e+01 │ 2.94     │
│ 12   │ 1621    │ -2.4748e+04 │ -2.4748e+04 │ 7.2906e-06  │ 4.7279e-03  │ 1.0105e-05  │ 1.14e+02 │ 2.97     │
│ 13   │ 1678    │ -2.4748e+04 │ -2.4748e+04 │ 3.0452e-06  │ 1.9748e-03  │ 7.5823e-07  │ 2.28e+02 │ 3.02     │
├──────┴─────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴──────────┴──────────┤
│ Updating Ranks ...                                                                                         │
│ Updated Ranks: [35]                                                                                        │
├──────┬─────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬──────────┬──────────┤
│ Iter │ In Iter │ P Obj       │ D Obj       │ P Infea 1   │ P Infea Inf │ PD Gap      │ Rho      │ Time     │
├──────┼─────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼──────────┼──────────┤
│ 14   │ 2422    │ -2.4748e+04 │ -2.4748e+04 │ 1.9263e-06  │ 1.2492e-03  │ 1.6409e-07  │ 4.55e+02 │ 3.78     │
│ 15   │ 2423    │ -2.4748e+04 │ -2.4748e+04 │ 1.2794e-06  │ 8.2968e-04  │ 3.7709e-08  │ 4.55e+02 │ 3.78     │
└──────┴─────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴──────────┴──────────┘

┌────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                          Switch To Phase II: ADMM                                          │
├──────┬─────────┬─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬──────────┬──────────┤
│ Iter │ CG Iter │ P Obj       │ D Obj       │ P Infea 1   │ P Infea Inf │ PD Gap      │ Rho      │ Time     │
├──────┼─────────┼─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼──────────┼──────────┤
│ 15   │ 119     │ -2.4748e+04 │ -2.4748e+04 │ 1.3007e-08  │ 8.4353e-06  │ 3.9613e-07  │ 6.55e+02 │ 4.34     │
└──────┴─────────┴─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴──────────┴──────────┘

➔ Initial Solving Finished ✅ (4.34 seconds)

➔ Evaluating Dual Infeasibility ✅ (0.03 seconds) 

@ Solution Information
    ┌────────────────────────────────┬───────────────┐
  ↳ │ Name                           │ Value         │
    ├────────────────────────────────┼───────────────┤
    │ primal objective value         │ -2.474782e+04 │
    │ dual objective value           │ -2.474780e+04 │
    │ primal infeasibility (DIMACS)  │ 1.300745e-08  │
    │ dual infeasibility (DIMACS)    │ 2.950202e-09  │
    │ primal dual gap (DIMACS)       │ 4.021113e-07  │
    └────────────────────────────────┴───────────────┘

➔ Problem Solved ✅ (4.34 seconds)
```

* **Note:** Even if the Julia application is precompiled, there will still be some dynamic compilation time at runtime due to Julia's Just-In-Time (JIT) compilation mechanism. (up to several seconds per run)

#### Environment Requirements:

cuLoRADS runs on Linux systems, with a minimum system requirement of Ubuntu 20.04. We have tested the following configurations, all of which successfully run the software:

* H100 + Ubuntu 22.04
* RTX 4090 + Ubuntu 22.04
* A6000 + Ubuntu 20.04
* A100 + Ubuntu 20.04


#### Output Format

If the `outputPath` is set, a `.out.mat` file with the same name as the problem will be written to the selected folder. This file is a standard MAT file containing the following data:

- **primal_sdp**: The low-rank primal solution \( U_i \) for each SDP block \( i \), where \( U_i U_i^\top = X_i \).
- **primal_lp**: The primal solution vector \(x\) for the LP variable (or the diagonal SDP block).
- **dual**: The dual solution \( \lambda \).


#### Parameters

cuLoRADS provides users with customizable parameters to fine-tune the solving process according to specific problem requirements (if needed). Below is a detailed description of each parameter:

| **Parameter**   | **Description**                                                                           | **Type** | **Default Value** |
| --------------- | ----------------------------------------------------------------------------------------- | -------- | ----------------- |
| timesLogRank    | Multiplier for the O(log(m)) rank calculation (rank = **timesLogRank** $\times$ log(m)).  | float    | 2.0               |
| phase1Tol       | Tolerance for ending Phase I.                                                             | float    | 1e-3              |
| phase2Tol       | Tolerance for ending Phase II.                                                            | float    | 1e-5              |
| reoptLevel      | [Beta] The level of reopt (select from 0, 1, 2).                                          | int      | 2                 |
| dyrankLevel     | [Beta] Increases sensitivity to rank update triggers as it rises (select from 0, 1, 2).   | int      | 2                 |
| highAccMode     | [Beta] Enhance the accuracy of the solution obtained.                                     | bool     | false             |
| initRho         | Initial value for the penalty parameter $\rho$.                                           | float    | 1/n               |
| rhoMax          | Maximum value for the penalty parameter $\rho$.                                           | float    | 5000.0            |
| ALMRhoFactor    | Multiplier for increasing $\rho$ ($\rho =$ **ALMRhoFactor** $\times$ $\rho$) in ALM.      | float    | 2.0               |
| ADMMRhoFreq     | Frequency of increasing $\rho$ (increased every **ADMMRhoFreq** ADMM iterations).         | int      | 5                 |
| ADMMRhoFactor   | Multiplier for increasing $\rho$ ($\rho =$ **ADMMRhoFactor** $\times$ $\rho$) in ADMM.    | float    | 1.2               |
| heuristicFactor | Heuristic factor applied when switching to Phase II.                                      | float    | 1.0               |
| lbfgsListLength | The number of vectors stored for L-BFGS                                                   | int      | 2                 |
| maxALMIter      | Maximum iteration number for the ADMM algorithm.                                          | int      | 200               |
| maxADMMIter     | Maximum iteration number for the ADMM algorithm.                                          | int      | 10000             |
| timeSecLimit    | Solving time limitation in seconds.                                                       | float    | 10000.0           |

For example, to set **timesLogRank** to 1.0 and solve a problem, we can execute

```
./bin/cuLoRADS --filePath /PATH/TO/SDPAFILE.dat-s --timesLogRank 1.0
```
* For the details of the reopt technique and the parameter reoptLevel, please refer to the paper.


#### Developing Team

cuLoRADS is developed by 

- Qiushi Han: joshhan2@illinois.edu

#### Reference

- Han, Q., Lin, Z., Liu, H., Chen, C., Deng, Q., Ge, D., & Ye, Y. (2024). Accelerating low-rank factorization-based semidefinite programming algorithms on GPU. *arXiv*. https://doi.org/10.48550/arXiv.2407.15049

```
@misc{han2024acceleratinglowrankfactorizationbasedsemidefinite,
      title={Accelerating Low-Rank Factorization-Based Semidefinite Programming Algorithms on GPU}, 
      author={Qiushi Han and Zhenwei Lin and Hanwen Liu and Caihua Chen and Qi Deng and Dongdong Ge and Yinyu Ye},
      year={2024},
      eprint={2407.15049},
      archivePrefix={arXiv},
      primaryClass={math.OC},
      url={https://arxiv.org/abs/2407.15049}, 
}
```

**cuLoRADS is free for academic use. When utilizing cuLoRADS in published works, please cite the source above.**
