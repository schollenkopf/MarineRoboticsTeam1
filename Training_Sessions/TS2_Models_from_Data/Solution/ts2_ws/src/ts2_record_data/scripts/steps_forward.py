#!/usr/bin/env python

import rospy
from geometry_msgs.msg import Twist
import time

def steps_forward():
    rospy.init_node('steps_forward', anonymous=True)
    pub = rospy.Publisher('bluerov2/cmd_vel', Twist, queue_size=10)
    rate = rospy.Rate(10)  # 10 Hz

    velocities = [0.0, 0.25, 0.75, 1.5, 0.75, 0.25]
    delay = 5.0
    while not rospy.is_shutdown():  # Continue indefinitely until shutdown
        for speed in velocities:
            twist_msg = Twist()
            twist_msg.linear.x = speed
            pub.publish(twist_msg)
            rospy.loginfo("Forward velocity set to %s m/s", speed)
            
            start_time = rospy.Time.now()
            while (rospy.Time.now() - start_time).to_sec() < delay:  
                pub.publish(twist_msg)
                rate.sleep()

if __name__ == '__main__':
    try:
        steps_forward()
    except rospy.ROSInterruptException:
        pass
