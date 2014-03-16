classdef IKTraj < handle
    properties
        joints = [];
        angles = [];
    end
    
    methods
        function traj = IKTraj(joints)
            traj.joints = joints;
            traj.angles = zeros(0, length(joints));
        end
        
        function [traj, success] = addLine(traj, data)
            if(length(data) == length(traj.joints))
                traj.angles = [traj.angles; data];
                success = 1;
            else
                success = 0;
            end
        end
    end
end

