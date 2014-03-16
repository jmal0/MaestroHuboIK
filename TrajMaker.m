classdef TrajMaker < handle
    properties
        header = [];
        angles = [];
    end
    
    methods
        function tm = TrajMaker(joints, angles)
            tm.header = cellstr(joints);
            tm.angles = angles;
        end
        
        % NOT YET IMPLEMENTED
        % Adds lines of trajectory 2 to the end of trajectory 1. Original
        % sub-trajectories are unchanged, 
        function tm = append(tm, traj1, traj2)
            t1 = traj1.angles;
            t2 = traj2.angles;
            % Check if trajectories share joints
            if(not(isempty(intersect(traj1.joints, traj2.joints))))
                % Rearrange headers and angles for trajectories to be
                % concatenated
                
            end
            tm.angles = [t1;t2];
        end
        
        % Combine trajectories side by side. If trajectories are not the
        % same length, the last line of the shorter trajectory is repeated
        % until the trajectories have the same length
        function [success, tm] = joinFromStart(tm, traj1, traj2)
            % Check that no joints are shared
            if(not(isempty(intersect(traj1.joints, traj2.joints))))
                print('Error, joint(s) shared between traj1 and traj2')
                success = 0;
                return;
            end
            % Check if trajectories are same length
            if(length(traj1.angles) < length(traj2.angles))
                diff = length(traj2.angles) - length(traj1.angles);
                lastline = traj1.angles(length(traj1.angles),:);
                traj1 = [traj1.angles;repmat(lastline, diff, 1)];
            else
                if(length(traj1.angles) > length(traj2.angles))
                diff = length(traj1.angles) - length(traj2.angles);
                lastline = traj2.angles(length(traj2.angles),:);
                traj2 = [traj2.angles;repmat(lastline, diff, 1)];
                end
            end
            tm.header = [traj1.joints; traj2.joints];
            tm.header = cellstr(tm.header)
            tm.angles = cat(2, traj1.angles, traj2.angles);
            success = 1;
        end
        
        % Combine trajectories side by side. If trajectories are not the
        % same length, the first line from the shorter trajectory is 
        % repeated to line up the end of each sub-trajectory
        function [success, tm] = joinFromEnd(tm, traj1, traj2)
            % Check that no joints are shared
            if(not(isempty(intersect(traj1.joints, traj2.joints))))
                print('Error, joint(s) shared between traj1 and traj2')
                success = 0;
                return;
            end
            % Check if trajectories are same length
            if(length(traj1.angles) < length(traj2.angles))
                diff = length(traj2.angles) - length(traj1.angles);
                lastline = traj1.angles(length(traj1.angles),:);
                traj1 = [repmat(lastline, diff, 1); traj1.angles];
            else
                if(length(traj1.angles) > length(traj2.angles))
                diff = length(traj1.angles) - length(traj2.angles);
                lastline = traj2.angles(length(traj2.angles),:);
                traj2 = [repmat(lastline, diff, 1); traj2.angles];
                end
            end
            tm.header = [traj1.joints; traj2.joints];
            tm.header = cellstr(tm.header)
            tm.angles = cat(2, traj1.angles, traj2.angles);
            success = 1;
        end
        
        % Create trajectory file. saveTraj function created by William Hilton
        function createTrajectory(tm, filename)
            saveTraj(filename, tm.angles, tm.header)
        end
    end
    
end

