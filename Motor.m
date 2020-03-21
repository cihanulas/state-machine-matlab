classdef Motor < StateMachine
    
    properties (Constant)
        transitions_for_event_halt = TransitionMap ({
            {'ST_Idle' 'ST_Ignored'};
            {'ST_Stop' 'ST_CannotHappen'};
            {'ST_Start' 'ST_Stop', 'OnHaltExitST_Start', 'OnHaltEnterST_Stop'};
            {'ST_ChangeSpeed' 'ST_Stop'}});
        
        transitions_for_event_set_speed = TransitionMap ({
            {'ST_Idle' 'ST_Start'};
            {'ST_Stop' 'ST_CannotHappen'};
            {'ST_Start' 'ST_ChangeSpeed'};
            {'ST_ChangeSpeed' 'ST_ChangeSpeed'}});
    end
    
    properties
        speed = 0;
    end
    methods
        function obj = Motor()
            obj@StateMachine('ST_Idle')
            disp('Motor is ready.');
            obj.PrintActiveState();
        end
        
        % External Events
        % Halt Event
        function Halt(obj)
            disp('  --> Event Halt  is triggered');
            Motor.transitions_for_event_halt.go_next(obj, []);
        end
        
        % SetSpeed Event
        function SetSpeed(obj, data)
            disp('  --> Event SetSpeed is triggered');
            if nargin==1
                return % do nothing stay in the same state.
            end
            Motor.transitions_for_event_set_speed.go_next(obj,data);
        end
    end
    
    methods (Access = {?TransitionMap})
        function OnHaltExitST_Start (obj)
            fprintf('   ==> OnHaltExitST_Start(0) executed \n');
        end
        
        function OnHaltEnterST_Stop (obj)
            fprintf('   ==> OnHaltEnterST_Stop(0) executed \n');
        end
        
    end
    methods (Access = {?StateMachine})
        
        %% In states
        function ST_Idle(obj, ~)
            obj.speed = 0;
        end
        
        function ST_Stop(obj, ~)
            obj.speed = 0;
            obj.InternalEvent('ST_Idle', 0);
        end
        function ST_Start(obj, data)
            obj.speed = data.speed;
        end
        function ST_ChangeSpeed(obj, data)
            obj.speed = data.speed;
        end
        
        
        
    end
end