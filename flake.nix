# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{

  description = "python-package swig lib package flake wrapper";
  inputs = {
    # NixOS official package source, here using the nixos-24.05 branch
  };

  outputs = _: {
      #package import for python swig lib
      v4l = import packages;
  };
}
