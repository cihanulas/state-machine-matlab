classdef State < handle
    
    properties (Constant)
        % uid = 1;
    end
    
    properties
        name, id 
    end
    
    methods (Static)
        function out = create_id()
            global uid
            if isempty(uid)
                uid = 0;
            else
                uid = uid + 1;
            end
            out = uid ;
        end
        
        function out = last_id()
            global uid
            out = uid;
        end
    end
    
    methods
        function obj = State(name)
            obj.id = obj.create_id();
            obj.name = name;
        end
        
        function obj = enter(obj)
            fprintf('State::Enter: %s\n', obj.name);
        end
        
        function obj = exit(obj)
            fprintf('State::Exit: %s\n', obj.name);
        end
        
        function obj = in(obj)
            fprintf('State::In: %s\n', obj.name);
        end
    end
    
    
end