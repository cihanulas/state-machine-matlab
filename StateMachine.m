%     public:
%     StateMachine(int maxStates);
%     virtual ~StateMachine() {}
%     protected:
%     enum { EVENT_IGNORED = 0xFE, CANNOT_HAPPEN };
%     unsigned char currentState;
%     void ExternalEvent(unsigned char, EventData* = NULL);
%     void InternalEvent(unsigned char, EventData* = NULL);
%     virtual const StateStruct* GetStateMap() = 0;
%     private:
%     const int _maxStates;
%     bool _eventGenerated;
%     EventData* _pEventData;
%     void StateEngine(void);

classdef StateMachine < handle
    
    properties (Constant)
        ST_Ignored = 'ST_Ignored'
        ST_CannotHappen = 'ST_CannotHappen'
    end
    
    properties
        currentState
    end
    
    properties (Access = public)
        event_generated = false;
        EventData = [];
    end
    
    methods (Static) 
    
        function ret = is_ignore(state)
            ret = strcmp(state, StateMachine.ST_Ignored);
        end
        
        function ret = is_cannot_happen(state)
            ret = strcmp(state, StateMachine.ST_CannotHappen);
        end
        
    end
    
    methods
        function obj = StateMachine(init_state)
            obj.currentState = init_state;
        end
        
        function str = CurrentState(obj)
            str = obj.currentState;
        end
        
        function PrintActiveState(obj)
            fprintf('Active State: %s\n', obj.CurrentState());
        end
    end
    
    methods (Access=private)
        function StateEngine(obj)
            % DataTemp = obj.EventData;
            
            % TBD - lock semaphore here
            % while events are being generated keep executing states
            while (obj.event_generated)
                obj.event_generated = false;  % event used up, reset flag
                % execute the state passing in event data, if any
                
                %state = obj.states.(obj.CurrentState());
                % obj.currentState.in(obj.EventData);
                current_state =  obj.CurrentState();
                fprintf('   (.)  State function %s() is executed....\n', current_state);
                obj.(current_state)(obj.EventData);
                fprintf('   (.)  State function %s() execution done.\n', current_state);
            end
        end
        
        
    end
    
    methods (Access = public)
        function obj = ExternalEvent(obj, newState, eventData)
            
            if StateMachine.is_ignore(newState)
                disp('  --> This event is ignored (ST_Ignored).');
            elseif StateMachine.is_cannot_happen(newState)
                disp('  --> This event is ignored:(ST_CannotHappen)');
            else
                % generate the event and execute the state engine
                obj.InternalEvent(newState, eventData);
                obj.StateEngine();
            end
            obj.PrintActiveState();
        end
        
        function obj = InternalEvent(obj, newState, eventData)
            obj.EventData = eventData;
            obj.event_generated = true;
            obj.currentState = newState;
        end
        
    end
    
end

