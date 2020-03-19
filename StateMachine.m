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
        ST_Ignored = State('ST_Ignored')
        ST_CannotHappen = State('ST_CannotHappen')
    end
    
    properties
        currentState
    end
    
    properties (Access = public)
        event_generated = false;
        EventData = [];
    end
    
    methods
        function obj = StateMachine(init_state)
            obj.currentState = init_state;
        end
        
        function str = CurrentState(obj)
            str = obj.currentState.name;
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
                obj.(obj.CurrentState())(obj.EventData);
            end
        end
    end
    
    methods (Access = public)
        function obj = ExternalEvent(obj, newStateName, eventData)
            newState = obj.states.(newStateName);
            
            if (newState == obj.ST_Ignored )
                disp('External event ignored: new state is ignored');
            elseif (newState == obj.ST_CannotHappen)
                disp('External event ignored: new state cannot happen');
            elseif (newState ~= obj.ST_Ignored)
                % generate the event and execute the state engine
                obj.InternalEvent(newState, eventData);
                obj.StateEngine();
            end
            obj.PrintActiveState();
        end
        
        function obj = InternalEvent(obj, newState, eventData)
            obj.EventData = eventData;
            obj.event_generated = true;
            % run exit
            
            %obj.currentState.exit();
            obj.currentState = newState;
            %obj.currentState.enter();
        end
        
    end
    
end

