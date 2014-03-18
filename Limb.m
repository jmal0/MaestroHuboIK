classdef Limb
    % An abstract class defining properties a hubo 'limb' class should have
    
    properties
        % Controlled joint names
        joints;
    end
    
    methods (Abstract)
        xyzData = getXYZ(limb);
        jointData = setXYZ(limb, data);
    end
    
end

