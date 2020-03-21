classdef EventData
    
    properties
        type = ''
    end
    
    methods (Access = public)
        function obj = EventData(type)
            obj.type = type;
        end
    end
    
end