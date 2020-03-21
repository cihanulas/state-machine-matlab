classdef Oven < StateMachine
    
    properties (Constant)
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
            obj@StateMachine('ST_DoorClose')
            disp('Oven is ready.');
            obj.PrintActiveState();
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
            fprintf('   ==> TurnOnLight just before opening door\n');
            obj.light = true;
        end
        
        function TurnOffLight (obj)
             fprintf('   ==> TurnOffLight just after closing door\n');
            obj.light = false;
        end
        
    end
    methods (Access = {?StateMachine})
        
        %% In states
        function ST_DoorOpen(obj, ~)
            
        end
        
        function ST_DoorClose(obj, ~)
            
        end
        
    end
end