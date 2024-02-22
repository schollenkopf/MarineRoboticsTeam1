#!/usr/bin/python

import rospy
from std_msgs.msg import Float64
from geometry_msgs.msg import PoseWithCovarianceStamped


def handle_depth(depth: Float64, args: tuple):
    msg, pub = args
    msg.pose.pose.position.z = depth.data
    msg.header.stamp = rospy.Time.now()
    pub.publish(msg)


def main():
    try:
        rospy.init_node("depth2pose")
        msg = PoseWithCovarianceStamped()
        msg.header.frame_id = rospy.get_param("~frame_id", "map_ned")
        msg.pose.covariance = [0]*36
        msg.pose.covariance[14] = rospy.get_param("~depth_covariance", 1e-9)
        pub = rospy.Publisher("pose", PoseWithCovarianceStamped, queue_size=10)
        rospy.Subscriber("depth", Float64, handle_depth, (msg, pub))
        rospy.spin()
    except rospy.ROSInterruptException:
        pass


if __name__=="__main__":
    main()