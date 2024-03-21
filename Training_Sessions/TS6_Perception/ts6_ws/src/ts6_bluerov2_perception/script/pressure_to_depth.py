#!/usr/bin/env python

import rospy
from sensor_msgs.msg import FluidPressure
from geometry_msgs.msg import PoseStamped, PoseWithCovarianceStamped
import numpy as np

class DepthEstimator:
    def __init__(self, standard_pressure, kpa_per_m):
        self.standard_pressure = standard_pressure
        self.kpa_per_m = kpa_per_m
        self.depth_values = []
        self.depth_publisher = rospy.Publisher("bluerov2/pressure_depth", PoseWithCovarianceStamped, queue_size=10)
        self.pressure_subscriber = rospy.Subscriber("bluerov2/pressure", FluidPressure, self.pressure_callback)

    def pressure_callback(self, data):
        print("Get raw data",data.fluid_pressure)
        depth = (data.fluid_pressure - self.standard_pressure) / (self.kpa_per_m * 1000.0)
        self.depth_values.append(depth)
        if len(self.depth_values) > 50:  # Keep only the last 50 depth values for better estimation
            self.depth_values.pop(0)
        variance = self.calculate_variance()
        self.publish_depth(depth, variance)

    def calculate_variance(self):
        std_dev = np.std(self.depth_values)
        variance = std_dev ** 2
        return variance

    def publish_depth(self, depth, variance):
        pose = PoseStamped()
        pose.header.stamp = rospy.Time.now()
        pose.pose.position.z = depth

        pose_with_covariance = PoseWithCovarianceStamped()
        pose_with_covariance.header = pose.header
        pose_with_covariance.pose.pose = pose.pose

        # Set covariance matrix
        covariance = np.zeros((6,6), dtype=float)
        covariance[2,2] = variance 
        
        pose_with_covariance.pose.covariance = tolist()  # 6x6 zero matrix
        pose_with_covariance.pose.covariance[2][2] = variance  # Assigning value to the variance in Z direction

        self.depth_publisher.publish(pose_with_covariance)

def main():
    rospy.init_node('depth_estimator', anonymous=True)
    standard_pressure = 101.325  # kPa
    kpa_per_m = 9.80638  # kPa/m
    depth_estimator = DepthEstimator(standard_pressure, kpa_per_m)
    rospy.spin()

if __name__ == '__main__':
    main()
