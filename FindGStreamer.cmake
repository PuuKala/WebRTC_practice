##############################################################
#         -- Try to find GStreamer and its plugins --        #
#                                                            #
#                                                            #
#                                                            #
# Modified to find glib-2.0 with its config by Sami Karkinen #
#                                                            #
##############################################################
#
#
#
# Once done, this will define
#
#  GSTREAMER_FOUND - system has GStreamer
#  GSTREAMER_INCLUDE_DIRS - the GStreamer include directories
#  GSTREAMER_LIBRARIES - link these to use GStreamer
#  GLIB_LIBRARIES - link these in addition to GSTREAMER_LIBRARIES if needed
#
# Additionally, gstreamer-base is always looked for and required, and
# the following related variables are defined:
#
#  GSTREAMER_BASE_INCLUDE_DIRS - gstreamer-base's include directory
#  GSTREAMER_BASE_LIBRARIES - link to these to use gstreamer-base
#
# Optionally, the COMPONENTS keyword can be passed to FIND_PACKAGE()
# and GStreamer plugins can be looked for.  Currently, the following
# plugins can be searched, and they define the following variables if
# found:
#
#  gstreamer-app:        GSTREAMER_APP_INCLUDE_DIRS and GSTREAMER_APP_LIBRARIES
#  gstreamer-audio:      GSTREAMER_AUDIO_INCLUDE_DIRS and GSTREAMER_AUDIO_LIBRARIES
#  gstreamer-fft:        GSTREAMER_FFT_INCLUDE_DIRS and GSTREAMER_FFT_LIBRARIES
#  gstreamer-interfaces: GSTREAMER_INTERFACES_INCLUDE_DIRS and GSTREAMER_INTERFACES_LIBRARIES
#  gstreamer-pbutils:    GSTREAMER_PBUTILS_INCLUDE_DIRS and GSTREAMER_PBUTILS_LIBRARIES
#  gstreamer-video:      GSTREAMER_VIDEO_INCLUDE_DIRS and GSTREAMER_VIDEO_LIBRARIES
#
# Copyright (C) 2012 Raphael Kubo da Costa <rakuco@webkit.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND ITS CONTRIBUTORS ``AS
# IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR ITS
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FIND_PACKAGE(PkgConfig)

# The minimum GStreamer version we support.
# SET(GSTREAMER_MINIMUM_VERSION 1.0.30) # Modified to 1.0, no knoweledge of minor versions

# Helper macro to find a GStreamer plugin (or GStreamer itself)
#   _component_prefix is prepended to the _INCLUDE_DIRS and _LIBRARIES variables (eg. "GSTREAMER_AUDIO")
#   _pkgconfig_name is the component's pkg-config name (eg. "gstreamer-1.0", or "gstreamer-video-1.0").
#   _header is the component's header, relative to the gstreamer-1.0 directory (eg. "gst/gst.h").
#   _library is the component's library name (eg. "gstreamer-1.0" or "gstvideo-1.0")
MACRO(FIND_GSTREAMER_COMPONENT _component_prefix _pkgconfig_name _header _library _path_suffix)
# FIXME: The QUIET keyword can be used once we require CMake 2.8.2.
PKG_CHECK_MODULES(PC_${_component_prefix} ${_pkgconfig_name})

FIND_PATH(${_component_prefix}_INCLUDE_DIRS
    NAMES ${_header}
    HINTS ${PC_${_component_prefix}_INCLUDE_DIRS} ${PC_${_component_prefix}_INCLUDEDIR}
    PATH_SUFFIXES ${_path_suffix}
)

FIND_LIBRARY(${_component_prefix}_LIBRARIES
    NAMES ${_library}
    HINTS ${PC_${_component_prefix}_LIBRARY_DIRS} ${PC_${_component_prefix}_LIBDIR}
)
ENDMACRO()

# ------------------------
# 1. Find GStreamer itself
# ------------------------

# 1.1. Find headers and libraries
FIND_GSTREAMER_COMPONENT(GSTREAMER gstreamer-1.0 gst/gst.h gstreamer-1.0 gstreamer-1.0)
FIND_GSTREAMER_COMPONENT(GSTREAMER_BASE gstreamer-base-1.0 gst/gst.h gstbase-1.0 gstreamer-1.0)
FIND_GSTREAMER_COMPONENT(GLIB glib-2.0 glib.h glib-2.0 glib-2.0)
FIND_PATH(GLIB_CONFIG_INCLUDE_DIRS glibconfig.h
    /usr/lib/x86_64-linux-gnu/glib-2.0/include)

# 1.2. Check GStreamer version
IF (GSTREAMER_INCLUDE_DIRS)
IF (EXISTS "${GSTREAMER_INCLUDE_DIRS}/gst/gstversion.h")
    FILE (READ "${GSTREAMER_INCLUDE_DIRS}/gst/gstversion.h" GSTREAMER_VERSION_CONTENTS)

    STRING(REGEX MATCH "#define +GST_VERSION_MAJOR +\\(([0-9]+)\\)" _dummy "${GSTREAMER_VERSION_CONTENTS}")
    SET(GSTREAMER_VERSION_MAJOR "${CMAKE_MATCH_1}")

    STRING(REGEX MATCH "#define +GST_VERSION_MINOR +\\(([0-9]+)\\)" _dummy "${GSTREAMER_VERSION_CONTENTS}")
    SET(GSTREAMER_VERSION_MINOR "${CMAKE_MATCH_1}")

    STRING(REGEX MATCH "#define +GST_VERSION_MICRO +\\(([0-9]+)\\)" _dummy "${GSTREAMER_VERSION_CONTENTS}")
    SET(GSTREAMER_VERSION_MICRO "${CMAKE_MATCH_1}")

    SET(GSTREAMER_VERSION "${GSTREAMER_VERSION_MAJOR}.${GSTREAMER_VERSION_MINOR}.${GSTREAMER_VERSION_MICRO}")
ENDIF ()
ENDIF ()

# FIXME: With CMake 2.8.3 we can just pass GSTREAMER_VERSION to FIND_PACKAGE_HANDLE_STARNDARD_ARGS as VERSION_VAR
#        and remove the version check here (GSTREAMER_MINIMUM_VERSION would be passed to FIND_PACKAGE).
SET(VERSION_OK TRUE)
IF ("${GSTREAMER_VERSION}" VERSION_LESS "${GSTREAMER_MINIMUM_VERSION}")
SET(VERSION_OK FALSE)
ENDIF ()

# -------------------------
# 2. Find GStreamer plugins
# -------------------------

# FIND_GSTREAMER_COMPONENT(GSTREAMER_APP gstreamer-app-1.0 gst/app/gstappsink.h gstapp-1.0 gstreamer-1.0)
# FIND_GSTREAMER_COMPONENT(GSTREAMER_AUDIO gstreamer-audio-1.0 gst/audio/audio.h gstaudio-1.0 gstreamer-1.0)
# FIND_GSTREAMER_COMPONENT(GSTREAMER_FFT gstreamer-fft-1.0 gst/fft/gstfft.h gstfft-1.0 gstreamer-1.0)
# FIND_GSTREAMER_COMPONENT(GSTREAMER_INTERFACES gstreamer-interfaces-1.0 gst/interfaces/mixer.h gstinterfaces-1.0 gstreamer-1.0)
# FIND_GSTREAMER_COMPONENT(GSTREAMER_PBUTILS gstreamer-pbutils-1.0 gst/pbutils/pbutils.h gstpbutils-1.0 gstreamer-1.0)
# FIND_GSTREAMER_COMPONENT(GSTREAMER_VIDEO gstreamer-video-1.0 gst/video/video.h gstvideo-1.0 gstreamer-1.0)
# FIND_GSTREAMER_COMPONENT(GSTREAMER_APP gstreamer-app-1.0 gst/app/gstappsink.h gstapp-1.0 gstreamer-1.0)

# ------------------------------------------------
# 3. Process the COMPONENTS passed to FIND_PACKAGE
# ------------------------------------------------
SET(_GSTREAMER_REQUIRED_VARS GSTREAMER_INCLUDE_DIRS GSTREAMER_LIBRARIES VERSION_OK GSTREAMER_BASE_INCLUDE_DIRS GSTREAMER_BASE_LIBRARIES)

FOREACH(_component ${GStreamer_FIND_COMPONENTS})
SET(_gst_component "GSTREAMER_${_component}")
STRING(TOUPPER ${_gst_component} _UPPER_NAME)

LIST(APPEND _GSTREAMER_REQUIRED_VARS ${_UPPER_NAME}_INCLUDE_DIRS ${_UPPER_NAME}_LIBRARIES)
ENDFOREACH()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GStreamer DEFAULT_MSG ${_GSTREAMER_REQUIRED_VARS})
