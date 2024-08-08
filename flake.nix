# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{

  description = "multimedia video gpu driver api package for IMX8 flake wrapper";
  inputs = {
    # NixOS official package source, here using the nixos-24.05 branch
  };

  outputs = _: {
      #package import v4l video for linux packages, needed to stream webcamera data
      v4l = import packages;
  };
}
