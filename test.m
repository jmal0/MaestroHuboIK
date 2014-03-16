clear

leftLeg = Leg(Leg.LEFT, Leg.GLOBAL);
rightLeg = Leg(Leg.RIGHT, Leg.GLOBAL);
leftHipThrust = IKTraj(leftLeg.joints);
rightHipThrust = IKTraj(rightLeg.joints);

t1 = 0:.001:.1;
t2 = .1:-.001:-.1;
t3 = -.1:.001:0;
x = [t1,t2,t3];
y = zeros(1, length(x));
z = zeros(1, length(x)) - .45;

for i = 1:length(x)
    dataL = leftLeg.setXYZ(x(i), y(i), z(i), 0);
    dataR = rightLeg.setXYZ(x(i), y(i), z(i), 0);
    if(or(isnan(dataL), isnan(dataR)))
        print('fail')
        return
    end
    leftHipThrust.addLine(dataL);
    rightHipThrust.addLine(dataR);
end

tm = TrajMaker(cellstr('test'), []);
tm.joinFromStart(leftHipThrust, rightHipThrust);
tm.createTrajectory('hipThrustTest.traj')
