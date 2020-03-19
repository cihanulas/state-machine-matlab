classdef Motor < StateMachine
    
    properties (Constant)
        states = struct (...
            'ST_Idle', State('ST_Idle'), ...
            'ST_Stop', State('ST_Stop'), ...
            'ST_Start', State('ST_Start'), ...
            'ST_ChangeSpeed', State('ST_ChangeSpeed'), ...
            'ST_Ignored', StateMachine.ST_Ignored, ...
            'ST_CannotHappen', StateMachine.ST_CannotHappen);
        
        % transition maps for the events
        transitions_halt = struct (...
            'ST_Idle', 'ST_Ignored', ...
            'ST_Stop', 'ST_CannotHappen', ...
            'ST_Start', 'ST_Stop', ...
            'ST_ChangeSpeed', 'ST_Stop');
        
        transitions_set_speed = struct (...
            'ST_Idle', 'ST_Start', ...
            'ST_Stop', 'ST_CannotHappen', ...
            'ST_Start', 'ST_ChangeSpeed', ...
            'ST_ChangeSpeed', 'ST_ChangeSpeed');
    end
    
    properties
        speed = 0;
    end
    methods
        function obj = Motor()
            obj@StateMachine(Motor.states.ST_Idle)
            disp('Motor is ready in state: "ST_Idle"');
        end
        
        % External Events
        % Halt Event
        function Halt(obj)
            disp('  --> Event Halt  is triggered');
            new_state_name = Motor.transitions_halt.(obj.CurrentState());
            obj.ExternalEvent(new_state_name, []); % event data
            
        end
        
        % SetSpeed Event
        function SetSpeed(obj, data)
            disp('  --> Event SetSpeed is triggered');
            if nargin==1
                return % do nothing stay in the same state.
            end
            new_state_name = Motor.transitions_set_speed.(obj.CurrentState());
            obj.ExternalEvent(new_state_name, data); % event data
        end
    end
    
    methods (Access = {?StateMachine})
        
        %% In states
        function ST_Idle(obj, ~)
            fprintf('ST_Idle(0) executed \n');
            obj.speed = 0;
        end
        
        function ST_Stop(obj, ~)
            fprintf('ST_Stop(0) executed \n');
            obj.speed = 0;
            obj.InternalEvent(obj.states.ST_Idle, 0);
        end
        function ST_Start(obj, data)
            fprintf('ST_Start() executed. Speed: %d \n', data.speed);
            obj.speed = data.speed;    
        end
        function ST_ChangeSpeed(obj, data)
            fprintf('ST_ChangeSpeed(%d) executed. Speed: %d \n', data.speed);
            obj.speed = data.speed;
        end
        
        
    end
end