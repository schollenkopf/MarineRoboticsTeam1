cmake_minimum_required(VERSION 2.8.3)
project(ts2_record_data)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  geometry_msgs
  ##message_generation  # Add this line for message generation
)

## Generate messages in the 'msg' folder
##add_message_files(
##  FILES
##)

## Generate added messages and services with any dependencies listed here
##generate_messages(
##  DEPENDENCIES
##  std_msgs
##  geometry_msgs
##)

## Declare a catkin package
catkin_package(
  CATKIN_DEPENDS roscpp std_msgs geometry_msgs message_runtime  # Add 'message_runtime' for message generation
)

catkin_install_python(PROGRAMS scripts/steps_forward.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

## Build talker and listener
include_directories(
  ${catkin_INCLUDE_DIRS}
)
