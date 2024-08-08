# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for morsemicro drivers
{
  config,
  pkgs,
  lib,
  ...
}: let
  morsemicro-pkg = pkgs.callPackage utils/vendors/morsemicro {};
in
  with lib; {
      environment.systemPackages = with pkgs; [
          #morse micro driver
          morsemicro-pkg
      ];
}
