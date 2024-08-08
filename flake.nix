# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  description = "mesh-communicator - Ghaf based configuration";

  nixConfig = {
     extra-trusted-public-substituters = [
      "https://cache.vedenemo.dev"
      "https://cache.ssrcdevops.tii.ae"
      "https://ghaf-cache.ssrcdevops.tii.ae"
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "cache.vedenemo.dev:8NhplARANhClUSWJyLVk4WMyy1Wb4rhmWW2u8AejH9E="
      "cache.ssrcdevops.tii.ae:oOrzj9iCppf+me5/3sN/BxEkp5SaFkHfKTPPZ97xXQk="
      "ghaf-infra-dev:KDasXk8mv7YSzYIZyIM6gER8QoqnL1wAOf9LP/bPqwk="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    # use downstream repo for proprietary hardware modules maintained by sec comms team,
    # this repo will be periodically rebased with nixos-hardware repo to bring the changes
    # for opensource eval kits.
    nixos-hardware.url = "git+ssh://git@github.com/tiiuae/comms-nixos-hardware";
    osf-nix-pkg.url = "git+ssh://git@github.com/tiiuae/osf-nix-pkg";
    dc-pkg.url = "git+ssh://git@github.com/tiiuae/discreet-communicator-nix-pkg";
    flake-parts.url = "github:hercules-ci/flake-parts";
    ghaf = {
      url = "github:tiiuae/ghaf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        nixos-hardware.follows = "nixos-hardware";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs = inputs @ {
    flake-parts,
    ghaf,
    ...
  }:
    flake-parts.lib.mkFlake
    {
      inherit inputs;
      specialArgs = {
        inherit (ghaf) lib;
      };
    } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        ./targets/som-imx8mp/flake-module.nix
        ./targets/imx8mp-cm3/flake-module.nix
        ./targets/imx8mp-pi/flake-module.nix
        ./targets/imx8mp-evk/flake-module.nix
        ./targets/rpi-cm4/flake-module.nix
      ];

    };
}
