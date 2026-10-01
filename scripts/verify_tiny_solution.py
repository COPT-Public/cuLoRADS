#!/usr/bin/env python3
"""Numerically verify cuLoRADS output for the bundled 2-by-2 SDP."""

import argparse
import json
from pathlib import Path

import numpy as np
from scipy.io import loadmat


def first_factor(value):
    array = np.asarray(value)
    if array.dtype == object:
        if array.size != 1:
            raise ValueError("expected exactly one SDP factor")
        array = np.asarray(array.flat[0])
    array = np.asarray(array, dtype=float)
    if array.ndim == 1:
        array = array.reshape((-1, 1))
    if array.ndim != 2 or array.shape[0] != 2:
        raise ValueError(f"unexpected primal factor shape: {array.shape}")
    return array


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("solution", type=Path)
    parser.add_argument("--tolerance", type=float, default=1e-3)
    args = parser.parse_args()

    data = loadmat(args.solution)
    if "primal_sdp" not in data:
        raise SystemExit("solution does not contain primal_sdp")
    factor = first_factor(data["primal_sdp"])
    matrix = factor @ factor.T
    if matrix.shape != (2, 2) or not np.isfinite(matrix).all():
        raise SystemExit("reconstructed matrix is invalid")

    objective = float(-2.0 * matrix[0, 1])
    objective_error = abs(objective + 2.0)
    diagonal_error = float(np.max(np.abs(np.diag(matrix) - 1.0)))
    symmetry_error = float(np.max(np.abs(matrix - matrix.T)))
    minimum_eigenvalue = float(np.linalg.eigvalsh((matrix + matrix.T) / 2).min())
    passed = (
        objective_error <= args.tolerance
        and diagonal_error <= args.tolerance
        and symmetry_error <= args.tolerance
        and minimum_eigenvalue >= -1e-8
    )
    result = {
        "solution": str(args.solution),
        "objective": objective,
        "objective_error": objective_error,
        "maximum_diagonal_error": diagonal_error,
        "symmetry_error": symmetry_error,
        "minimum_eigenvalue": minimum_eigenvalue,
        "tolerance": args.tolerance,
        "passed": passed,
    }
    print(json.dumps(result, indent=2, allow_nan=False))
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
