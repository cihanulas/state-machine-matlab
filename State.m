classdef State < handle
    
    properties
        name
    end
    
    methods
        function obj = State(name)
            obj.name = name;
        end
    end
end