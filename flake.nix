# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{

  description = "utils vendor morsemicro package";
  inputs = {
    # NixOS official package source, here using the nixos-24.05 branch
  };

  outputs = _: {
      #imports packages for cpu benchmarking
      cpu_benchmarks = import ./packages;
  };
}
