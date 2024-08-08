# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{

  description = "multimedia video vpu driver api package for IMX8 flake wrapper";
  inputs = {
    # NixOS official package source, here using the nixos-24.05 branch
  };

  outputs = _: {
      #imports package for working with the vpu of the IMX8
      vpu-api = import packages;
  };
}
