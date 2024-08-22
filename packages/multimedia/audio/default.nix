# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.comms.gstreamer_audio;
  
  opus_decoder = pkgs.callPackage ../../../packages/multimedia/audio/codecs/opustools {};

in
  with lib; {
      environment.systemPackages = [
        #main gstreamer lib
        gst_all_1.gstreamer
        # Common plugins like "filesrc" to combine within e.g. gst-launch
        gst_all_1.gst-plugins-base
        # Specialized plugins separated by quality
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        # Plugins to reuse ffmpeg to play almost every video format
        gst_all_1.gst-libav
        # Support the Video Audio (Hardware) Acceleration API
        gst_all_1.gst-vaapi
        #tools to install opus enc
        libopusenc    
        #tools to install opus dec
        opus_decoder
        # Basic alsa utils needed for sound testing and gstreamer correct function
        alsa-utils
      ];
  }




