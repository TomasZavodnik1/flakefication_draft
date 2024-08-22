# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for morsemicro drivers
{
  config,
  pkgs,
  lib,
  ...
}: let
  gstreamer-pkg = pkgs.callPackage multimedia/audio {};
in
  with lib; {
      environment.systemPackages = with pkgs; [
          #morse micro driver
          gstreamer-pkg
      ];
}
