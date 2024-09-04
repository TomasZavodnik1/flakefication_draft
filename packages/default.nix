# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for morsemicro drivers
{
  config,
  pkgs,
  lib,
  ...
}: let
  whetstone-pkg = pkgs.callPackage whetstone {};
  drystone-pkg = pkgs.callPackage drystone {};
  coremark-pkg = pkgs.callPackage coremark {};

in
  with lib; {
      environment.systemPackages = with pkgs; [
          #coremark cpu benchmark software
          coremark-pkg
          #drystone cpu benchmark software
          drystone-pkg
          #whetstone cpu benchmark software
          whetstone-pkg
      ];
}
