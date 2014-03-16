clear

rightLeg = Leg(Leg.RIGHT);
tm = TrajMaker(rightLeg.joints);
rightLeg.joints
[hy, hr, hp, kp, ap, ar] = rightLeg.setFootLowerBodyXYZ(-.05, -.05, -.4, 1.57);
data = [hy, hr, hp, kp, ap, ar];
success = tm.addLine(data);
[hy, hr, hp, kp, ap, ar] = rightLeg.setFootLowerBodyXYZ(0, -.05, -.4, 0);
data = [hy, hr, hp, kp, ap, ar];
success = tm.addLine(data);
z = tm.angles;
