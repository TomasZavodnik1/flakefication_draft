# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

 { stdenv, pkgs, lib, fetchurl, pkg-config, perl
, argp-standalone, libjpeg, udev
,
}:
let
  withQt = false;
  withUtils = true;
in stdenv.mkDerivation rec {
  pname = "v4l-utils";
  version = "1.24.1";

  src = fetchurl {
    url = "https://linuxtv.org/downloads/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-y7f+imMH9c5TOgXN7XC7k8O6BjlaubbQB+tTt12AX1s=";
  };

  outputs = [ "out" ] ++ lib.optional withUtils "lib" ++ [ "dev" ];

  configureFlags = (if withUtils then [
    "--with-localedir=${placeholder "lib"}/share/locale"
    "--with-udevdir=${placeholder "out"}/lib/udev"
  ] else [
    "--disable-v4l-utils"
  ]);

  postFixup = ''
    # Create symlink for V4l1 compatibility
    ln -s "$dev/include/libv4l1-videodev.h" "$dev/include/videodev.h"
  '';

  nativeBuildInputs = [ pkg-config perl ] ++ lib.optional withQt pkgs.wrapQtAppsHook;

  buildInputs = [ udev ]
    ++ lib.optional (!stdenv.hostPlatform.isGnu) argp-standalone
    ++ lib.optionals withQt [ pkgs.alsa-lib pkgs.libX11 pkgs.qtbase pkgs.libGLU ];

  propagatedBuildInputs = [ pkgs.libjpeg ];

  postPatch = ''
    patchShebangs utils/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "V4L utils and libv4l, provide common image formats regardless of the v4l device";
    homepage = "https://linuxtv.org/projects.php";
    changelog = "https://git.linuxtv.org/v4l-utils.git/plain/ChangeLog?h=v4l-utils-${version}";
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.linux;
  };
}
