classdef IKTraj < Traj
    properties
        limb;
    end
    
    methods
        function iktraj = IKTraj(limb)
            iktraj = iktraj@Traj(limb.joints);
            iktraj.limb = limb;
        end
        
        % Given xyz position, compute joint angles and add them to
        % trajectory
        function iktraj = addLine(iktraj, xyzData)
            jointData = iktraj.limb.setXYZ(xyzData);
            iktraj = iktraj.addLine@Traj(jointData);
        end
        
        % Move xyz position in a straight line from start to end at a given
        % velocity v. Assumes first three arguments of limb are x,y,z and
        % ignores rest of data
        function iktraj = interpolateLinear(iktraj, startData, endData, v)
            dx = endData(1) - startData(1);
            dy = endData(2) - startData(2);
            dz = endData(3) - startData(3);
            dist = sqrt(dx*dx + dy*dy + dz*dz);
            iterations = dist/v*200;
            xpts = startData(1):dx/iterations:endData(1);            
            ypts = startData(2):dy/iterations:endData(2);
            zpts = startData(3):dz/iterations:endData(3);
            dataTmp = startData;
            for i = 1:length(xpts)
                dataTmp(1) = xpts(i);
                dataTmp(2) = ypts(i);
                dataTmp(3) = zpts(i);
                iktraj = iktraj.addLine(dataTmp);
            end
        end
    end
end

