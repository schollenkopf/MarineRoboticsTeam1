#!/usr/bin/env python
import rospy
from nav_msgs.msg import Path
from geometry_msgs.msg import PoseStamped

class PoseStampedToPath:
    def __init__(self):
        rospy.init_node('pose_stamped_to_path', anonymous=True)
        
        self.odom_sub = rospy.Subscriber('/bluerov2/mavros/fake_gps/mocap/pose', PoseStamped, self.pose_stamped_callback)
        self.path_pub = rospy.Publisher('/bluerov2/path_gt', Path, queue_size=10)
        
        self.path_msg = Path()

    def pose_stamped_callback(self, msg):
        self.path_msg.header.frame_id = msg.header.frame_id
        self.path_msg.poses.append(msg)
        
        # Publish path
        self.path_pub.publish(self.path_msg)

if __name__ == '__main__':
    try:
        pose_stamped_to_path = PoseStampedToPath()
        rospy.spin()
    except rospy.ROSInterruptException:
        pass
