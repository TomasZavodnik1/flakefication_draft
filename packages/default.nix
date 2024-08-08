# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

#overlay for video flakes
{
  config,
  pkgs,
  lib,
  ...
}: let
  m2crypto = pkgs.callPackage python-packages/m2crypt {};
  m2crypto_test = pkgs.callPackage python-packages/m2crypt_test {};

in
  with lib; {
    options.m2crypto = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, will build only m2crypto python libary
        '';
      };
    };
    options.m2crypto_test = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, will build m2crypto_test and make it available to userspace
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
          #video for linux package
          m2cypto
      ];
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
          #video for linux package
          m2ctypto_test
      ];
    };

}
