# Command-line reference

Project repository: https://github.com/COPT-Public/cuLoRADS

## Syntax

```text
bin/cuLoRADS --filePath INPUT [OPTIONS]
```

Boolean values are written as `true` or `false`. Option names are
case-sensitive. Run `bin/cuLoRADS --help` to display the parser's built-in help.

## Input and output

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `--filePath` | path | empty | Required problem file (`.dat-s` or `.mat`). |
| `--outputPath` | directory | empty | Existing directory for `<input>.out.mat`; no file is saved when empty. |
| `--optSense` | Boolean | `false` | Objective convention: `false` for maximize (`0`), `true` for minimize (`1`). |

For a `.mat` input, the solver expects SeDuMi-style `A` (or `At`), `b`, `c`,
and `K` variables. A saved solution contains `primal_sdp`, `primal_lp`, and
`dual`. See the main README for reconstruction details.

## Iteration, rank, and stopping controls

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `--maxALMIter` | integer | `200` | Maximum augmented-Lagrangian iterations. |
| `--maxADMMIter` | integer | `10000` | Maximum ADMM iterations. |
| `--timesLogRank` | real | `2.0` | Multiplier used by automatic rank selection. |
| `--constRank` | one or more integers | `-1` | Fixed ranks; `-1` keeps automatic rank behavior. Multiple values follow the same option. |
| `--phase1Tol` | real | `1e-3` | Phase-one tolerance. |
| `--phase2Tol` | real | `1e-5` | Phase-two tolerance. |
| `--timeSecLimit` | seconds | `40000.0` | Solver time limit. |
| `--reoptLevel` | integer | `4` | Re-optimization level. |
| `--dyrankLevel` | integer | `2` | Dynamic-rank level. |
| `--enhancementMode` | Boolean | `true` | Enable enhancement mode. |
| `--accLevel` | integer | `1` | Acceleration level. |
| `--juliaWarmStart` | Boolean | `true` | Enable the built-in warm start. The name is retained for CLI compatibility; external Julia is not required. |

## Penalty and algorithm controls

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `--initRho` | real | `0.0` | Initial penalty parameter; `0.0` uses solver initialization. |
| `--rhoMax` | real | `5000.0` | Maximum penalty parameter. |
| `--ALMRhoFactor` | real | `2.0` | ALM penalty update factor. |
| `--ADMMRhoFreq` | integer | `5` | ADMM penalty update frequency. |
| `--ADMMRhoFactor` | real | `1.2` | ADMM penalty update factor. |
| `--heuristicFactor` | real | `1.0` | Heuristic scaling factor. |
| `--lbfgsListLength` | integer | `2` | L-BFGS history length. |

The level options are advanced controls. Use the defaults unless a validated
benchmark protocol specifies otherwise. For the Hans benchmark:

```text
--timeSecLimit 40000 --reoptLevel 4 --enhancementMode true
```

## Examples

Solve and print results without saving a MATLAB file:

```sh
./bin/cuLoRADS --filePath /data/problem.dat-s
```

Save a solution and select a physical GPU:

```sh
mkdir -p /data/results
CUDA_VISIBLE_DEVICES=1 ./bin/cuLoRADS \
  --filePath /data/problem.dat-s \
  --outputPath /data/results
```

Use a fixed rank and a short time limit:

```sh
./bin/cuLoRADS \
  --filePath /data/problem.dat-s \
  --constRank 32 \
  --timeSecLimit 300
```
