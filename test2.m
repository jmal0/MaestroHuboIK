clear

leftLeg = Leg(Leg.LEFT, Leg.GLOBAL);
rightLeg = Leg(Leg.RIGHT, Leg.GLOBAL);
leftHipThrust = IKTraj(leftLeg);
rightHipThrust = IKTraj(rightLeg);
arms = Traj(cellstr(['LSP';'RSP']));

t = 6;
T = 2;
A = .05;


superTraj = Traj([]);
superTraj.joinFromStart(leftHipThrust, rightHipThrust);
superTraj.createTrajectory('bowChickaWowWow2.traj')
