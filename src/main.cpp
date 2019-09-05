/**
 * @file main.cpp
 * @brief Main function for a demo using GSTSimpleWebRTC class
 */
#include "gst_simplewebrtc.hpp"
#include <iostream>

int main(int argc, char const *argv[])
{
    std::cout << "Making GSTSimpleWebRTC object..." << std::endl; 
    GSTSimpleWebRTC gst_webrtc;
    std::cout << "GSTSimpleWebRTC object made" << std::endl;
    std::cout << "Program ran, exiting..." << std::endl;
    return 0;
}
