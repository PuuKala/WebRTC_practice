cmake_minimum_required(VERSION 3.0)

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR})

file(GLOB GST_SIMPLEWEBRTC_SRC "src/main.cpp" "src/gst_simplewebrtc.cpp")

find_package(GStreamer)

include_directories(${GLIB_INCLUDE_DIRS} ${GLIB_CONFIG_INCLUDE_DIRS} ${GSTREAMER_INCLUDE_DIRS} "include")

add_executable(gst_simplewebrtc ${GST_SIMPLEWEBRTC_SRC})
target_link_libraries(gst_simplewebrtc ${GSTREAMER_LIBRARIES} ${GLIB_LIBRARIES})