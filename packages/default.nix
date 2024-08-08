# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for gpu driver
{
  config,
  pkgs,
  lib,
  ...
}: let
  gpu-api = pkgs.callPackage multimedia/video/gpu/driver/hantro-imx {};
in
  with lib; {
      environment.systemPackages = with pkgs; [
          #api for working with the imx8 gpu
          gpu-api
      ];
}
