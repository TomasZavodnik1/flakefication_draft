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
  swig = pkgs.callPackage python-packages/swig {};

in
  with lib; {
    options.m2crypto_test = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, will build m2crypto_test and make it available to userspace
        '';
      };
    };

    environment.systemPackages = with pkgs; [
          #python m2crypto lib
          m2cypto
          #python package swig
          swig
    ];
    
    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
          #video for linux package
          m2ctypto_test
      ];
    };

}
