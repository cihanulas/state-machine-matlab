classdef Oven < StateMachine
    
    properties (Constant)
        states = struct (...
            'ST_DoorOpen', State('ST_DoorOpen'), ...
            'ST_DoorClose', State('ST_DoorClose'), ...
            'ST_Ignored', StateMachine.ST_Ignored, ...
            'ST_CannotHappen', StateMachine.ST_CannotHappen);
        
        % Turn light on before openning door
        transitions_for_event_open_door = TransitionMap ({
            {'ST_DoorClose' 'ST_DoorOpen', 'TurnOnLight'};
            });
        transitions_for_event_close_door = TransitionMap ({
            {'ST_DoorOpen' 'ST_DoorClose', 'TurnOffLight'};
            });
    end
    
    properties
        light = false;
    end
    
    methods
        function obj = Oven()
            obj@StateMachine(Oven.states.ST_DoorClose)
            disp([ 'Oven is ready in state: ' obj.CurrentState()]);
        end
        
        % External Events
        function OpenDoor(obj)
            disp('  --> Event OpenDoor is triggered');
            Oven.transitions_for_event_open_door.go_next(obj);
        end
        
        function CloseDoor(obj)
            disp('  --> Event CloseDoor is triggered');
            Oven.transitions_for_event_close_door.go_next(obj);
        end
    end
    
    methods (Access = {?TransitionMap})
        function TurnOnLight (obj)
            fprintf('   ==> TurnOnLight executed \n');
            obj.light = true;
        end
        
        function TurnOffLight (obj)
            fprintf('   ==> TurnOffLight executed \n');
            obj.light = false;
        end
        
    end
    methods (Access = {?StateMachine})
        
        %% In states
        function ST_DoorOpen(obj, ~)
            fprintf('ST_DoorOpen\n');
        end
        
        function ST_DoorClose(obj, ~)
            fprintf('ST_Stop(0) executed \n');
        end
        
    end
end