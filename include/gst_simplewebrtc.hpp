/**
 * @file gst_simplewebrtc.hpp
 * @brief Declarations for a class combining SimpleWebRTC open source to GStreamer
 * 
 * @author Sami Karkinen
 */
#pragma once
#ifndef GST_SIMPLEWEBRTC_HPP
#define GST_SIMPLEWEBRTC_HPP

#include <gstreamer-1.0/gst/gst.h>

class GSTSimpleWebRTC
{
private:
    GMainLoop *loop_;
    GstElement *pipe_, *webrtc_;
    GObject *receive_channel;
    const gchar *server_url_ = "localhost";
public:
    GSTSimpleWebRTC(/* args */);
    ~GSTSimpleWebRTC();
};

#endif  // GST_SIMPLEWEBRTC_HPP