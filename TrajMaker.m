classdef TrajMaker < handle
    properties
        header = [];
        angles = [];
    end
    
    methods
        function tm = TrajMaker(joints)
            tm.header = joints;
            tm.angles = zeros(0, length(joints));
        end
        
        function [tm, success] = addLine(tm, data)
            if(length(data) == length(tm.header))
                tm.angles = [tm.angles; data];
                success = 1;
            else
                success = 0;
            end
        end
        
        function createTrajectory(tm, filename)
            saveTraj(filename, tm.header, tm.angles)
        end
    end
    
end

