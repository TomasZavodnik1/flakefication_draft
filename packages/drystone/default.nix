# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  pkgs,
  stdenv,
  pkg-config,
  pkgconf,
  gnumake,
  gcc,
}:

pkgs.stdenv.mkDerivation rec {
  pname = "drystone";
  version = "v1.0";

  src = pkgs.fetchFromGitHub {
      owner = "Keith-S-Thompson";
      repo = "dhrystone";
      rev = "66bb9df1a5dea67f33437b856bf68ae52bd5c90f";
      sha256 = "sha256-2iQm2tXAxYoBwjCCWr2oCrIZeJ4Kz0D31QS/LuMd7Q8=";
  };



  # Disable the execution of checks during the build
  #doCheck = false;

  # Set buildInputs to an empty list
  buildInputs = [  pkgs.gnumake ];
  
  nativeBuildInputs = [];
  #sourceRoot = "./.";

  # Add the dontBuild attribute to prevent building the package
  buildPhase = ''
              cd v2.2/              
              $CC -c $CFLAGS dry.c -o dry1.o
              $CC -DPASS2 $CFLAGS dry.c dry1.o $LFLAGS -o dry2
              $CC -c -DREG $CFLAGS dry.c -o dry1.o
              $CC -DPASS2 -DREG $CFLAGS dry.c dry1.o $LFLAGS -o dry2nr
              $CC -c -O $CFLAGS dry.c -o dry1.o
              $CC -DPASS2 -O $CFLAGS dry.c  dry1.o $LFLAGS -o dry2o
              
               '';
  installPhase = ''
                 mkdir -p $out/bin
                 cp dry2 $out/bin
                 cp dry2nr $out/bin
                 cp dry2o $out/bin
                 '';
}

