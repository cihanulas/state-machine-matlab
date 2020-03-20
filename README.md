# state-machine-matlab
State Machine Implementation with Matlab

Motor and Oven is implemented as a StateMachine.


# StateMachine is a base class and responsible for state transition:
 * Implements Internal and External events
 * Includes StateEngine
 
 
 
 # States: States are defined and named. So the name is also ID of the state. 
 ST_Ignored and ST_CannotHappen are static states defined in StateMahine so can be used for all instance of sub class (like Motor, or Oven)
 
 Here is the usage for an Oven state machine and its light implementation. 
 Assume Oven has two states, "DoorOpen" and "DoorClose". So we need two event for open_door, and close_door. 
 Additionally we want to turn light on just before opening the door (onEntry of DoorOpen) and 
 '''
 states = struct (...
            'ST_DoorOpen', State('ST_DoorOpen'), ...
            'ST_DoorClose', State('ST_DoorClose'), ...
            'ST_Ignored', StateMachine.ST_Ignored, ...
            'ST_CannotHappen', StateMachine.ST_CannotHappen);
        
# TransitionMap stores the transition map for a particular event and optionally the states's entry and exit functions.
'''
        transitions_for_event_open_door = TransitionMap ({
            {'ST_DoorClose' 'ST_DoorOpen', 'TurnOnLight'}; % Turn light on just before openning door (OnEnter func.)
            });
        transitions_for_event_close_door = TransitionMap ({
            {'ST_DoorOpen' 'ST_DoorClose', 'TurnOffLight'}; % Turn light off before closing door
            });
          
# ------------------------ Oven State Machine------------------ 

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

# ------------------------ Motor State Machine------------------ 

classdef Motor < StateMachine
    
    properties (Constant)
        states = struct (...
            'ST_Idle', State('ST_Idle'), ...
            'ST_Stop', State('ST_Stop'), ...
            'ST_Start', State('ST_Start'), ...
            'ST_ChangeSpeed', State('ST_ChangeSpeed'), ...
            'ST_Ignored', StateMachine.ST_Ignored, ...
            'ST_CannotHappen', StateMachine.ST_CannotHappen);
        
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
            obj@StateMachine(Motor.states.ST_Idle)
            disp('Motor is ready in state: "ST_Idle"');
        end
        
        % External Events
        % Halt Event
        function Halt(obj)
            disp('  --> Event Halt  is triggered');
            
            new_state_name = Motor.transitions_for_event_halt.go_next(obj);
            obj.ExternalEvent(new_state_name, []); % event data
        end
        
        % SetSpeed Event
        function SetSpeed(obj, data)
            disp('  --> Event SetSpeed is triggered');
            if nargin==1
                return % do nothing stay in the same state.
            end
            new_state_name = Motor.transitions_for_event_set_speed.go_next(obj);
            obj.ExternalEvent(new_state_name, data); % event data
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


