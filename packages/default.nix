# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for opus tools codec
{
  config,
  pkgs,
  lib,
  ...
}: let
  opustools = pkgs.callPackage multimedia/audio/codecs/opustools {};
in
  with lib; {
      environment.systemPackages = with pkgs; [
          #codec opus tools
          opustools
      ];
}
