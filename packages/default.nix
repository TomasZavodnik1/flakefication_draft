# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for gpu driver
{
  config,
  pkgs,
  lib,
  ...
}: let
  vpu-api = pkgs.callPackage multimedia/video/vpu/driver/hantro-imx {};
in
  with lib; {
      environment.systemPackages = with pkgs; [
          #api for working with the imx8 vpu
          vpu-api
      ];
}
