# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{

  description = "python-package swig lib package flake wrapper";
  inputs = {
    # NixOS official package source, here using the nixos-24.05 branch
  };

  outputs = _: {
      #package import v4l video for linux packages, needed to stream webcamera data
      v4l = import packages;
  };
}
