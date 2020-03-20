classdef TransitionMap < handle
    
    properties (Access = private)
        tr_map
        exit_map
        enter_map
        
    end
    
    methods (Static)
        function key = create_key (from_state, to_state)
            key = [from_state '_' to_state];
        end
    end
    methods
        function obj = TransitionMap(transitions)
            
            for i=1:size(transitions,1)
                transition = transitions{i,:};
                n_item  = length(transition);
                assert(n_item > 1)
                obj.tr_map.(transition{1}) = transition{2};
                
                key = TransitionMap.create_key(transition{1}, transition{2});
                if (n_item>2)
                    obj.enter_map.(key) = transition{3};
                end
                if (n_item>3)
                    obj.exit_map.(key) = transition{4};
                end
            end
        end
        
        function go_next(obj, main_obj, data)
            current_state = main_obj.CurrentState();
            next_state = obj.tr_map.(current_state);
            key = TransitionMap.create_key(current_state, next_state);
            if isfield(obj.exit_map, key)
                onExit = obj.exit_map.(key);
                main_obj.(onExit)();
            end
            
            if isfield(obj.enter_map, key)
                onEnter = obj.enter_map.(key);
                main_obj.(onEnter)();
            end
            if (nargin==2)
                data= [];
            end
            main_obj.ExternalEvent(next_state, data); % event data
        end
    end
    
end