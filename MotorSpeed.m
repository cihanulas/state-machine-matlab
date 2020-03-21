classdef MotorSpeed < EventData
    
    properties 
        speed = 0;
    end
    methods (Access = public)
        function obj = MotorSpeed(speed) 
            obj@EventData('MotorSpeed');
            obj.speed = speed;
        end
    end
end