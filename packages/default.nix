# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for video flakes
{
  config,
  pkgs,
  lib,
  ...
}: let
  v4l = pkgs.callPackage multimedia/video/v4l {};
in
  with lib; {
    options.nrc-utils = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enabled, video drivers will be enables and used
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
          #video for linux package
          v4l        
      ];
    };
}
