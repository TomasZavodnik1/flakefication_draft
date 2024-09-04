# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{
  lib,
  pkgs,
  stdenv,
  pkg-config,
  gnumake,
  gcc,
}:

pkgs.stdenv.mkDerivation rec {
  pname = "whetstone";
  version = "v1.0";

  src = pkgs.fetchFromGitHub {
      repo = "arm_benchmarks";
      owner = "varigit";
      rev = "902b0b327dfe1c4fda0bf8e65784d8d944fafa71";
      sha256 = "sha256-PVGlrYFg5fORFWwq2CXEJMPcCC/xcyhPbEAD4p4XHps=";
  };

  buildInputs = [];
  
  nativeBuildInputs = [ pkgs.gnumake pkgs.gcc ];

  buildPhase = ''
                cd whetstone
                make all
               '';

  installPhase = ''
                 mkdir -p $out/bin
                 cp Release/whetstone $out/bin
                 '';
}

