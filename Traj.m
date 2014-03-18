classdef Traj < handle
    properties
        joints;
        angles;
    end
    
    methods
        function traj = Traj(joints)
            traj.joints = joints;
            traj.angles = zeros(0,length(joints));
        end
        
        % Return number of joints in trajectory
        function l = getWidth(traj)
            l = length(traj.joints);
        end
        
        % Return number of lines in trajectory
        function l = getLength(traj)
            l = length(traj.angles);
        end
        
         % Return column of trajectory corresponding to given joint or an
         % empty array if joint is not in trajectory
        function col = getColumn(traj, joint)
            i = strmatch(joint,traj.joints);
            if(i)
                col = traj.angles(:,i);
                return;
            end
            col = [];
        end
        
        % Delete a column corresponding to a given joint
        function traj = deleteColumn(traj, joint)
            i = strmatch(joint, traj.joints);
            if(i)
                traj = traj(:, [1:i-1,i+1:length(traj(1))]);
            end
        end
        
        % Replace a joint's column with provided array
        function traj = replaceColumn(traj, joint, angles)
            i = strmatch(joint,traj.joints);
            if(i)
                if(length(angles) == length(traj.angles(:,i)))
                    traj.angles(:,i) = angles;
                else
                    error('myApp:argChk','Length of new column does not match old');
                end
            end      
        end
              
        % Append a line on the end of the trajectory, provided the joints
        % match
        function traj = addLine(traj, data)
            if(length(data) == length(traj.joints))
                traj.angles = [traj.angles; data];
            else
                error('myApp:argChk','Number of joints did not match trajectory');
            end
        end
        
        % Combine trajectories side by side. If trajectories are not the
        % same length, the last line of the shorter trajectory is repeated
        % until the trajectories have the same length
        function traj = joinFromStart(traj, traj1, traj2)
            % Check that no joints are shared
            if(not(isempty(intersect(traj1.joints, traj2.joints))))
                error('myApp:argChk','Error, joint(s) shared between traj1 and traj2')
            end
            % Check if trajectories are same length
            if(length(traj1.angles) < length(traj2.angles))
                disp(length(traj1.angles))
                disp(length(traj2.angles))
                
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
            traj.joints = [traj1.joints; traj2.joints];
            traj.angles = cat(2, traj1.angles, traj2.angles);
        end
        
        % Combine trajectories side by side. If trajectories are not the
        % same length, the first line from the shorter trajectory is 
        % repeated to line up the end of each sub-trajectory
        function traj = joinFromEnd(traj, traj1, traj2)
            % Check that no joints are shared
            if(not(isempty(intersect(traj1.joints, traj2.joints))))
                error('myApp:argChk','Error, joint(s) shared between traj1 and traj2')
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
            traj.joints = [traj1.joints; traj2.joints];
            traj.angles = cat(2, traj1.angles, traj2.angles);
        end
        
        % NOT YET IMPLEMENTED
        % Adds lines of trajectory 2 to the end of trajectory 1. Original
        % sub-trajectories are unchanged, 
        function traj = append(traj, traj1, traj2)
            t1 = traj1.angles;
            t2 = traj2.angles;
            % Check if trajectories share joints
            if(not(isempty(intersect(traj1.joints, traj2.joints))))
                % Rearrange headers and angles for trajectories to be
                % concatenated
                
            end
            traj.angles = [t1;t2];
        end
        
        % Create trajectory file. saveTraj function created by William Hilton
        function createTrajectory(traj, filename)
            saveTraj(filename, traj.angles, traj.joints)
        end
    end
    
end

