classdef StockStrategy < StateMachine
    
    properties (Constant)
        % Turn light on before openning door
        transitions_for_event_price_update = TransitionMap ({
            % In Passive mode, ignore price update event.
            {'ST_Passive' 'ST_Ignored', 'LogStrategyInPassiveMode'};
            % depending on price info internally will switch to ST_OrderInProgress
            {'ST_NotInPortfoy' 'ST_NotInPortfoy'};
            % internally will switch to ST_OrderInProgress
            {'ST_InPortfoy' 'ST_InPortfoy'};
            % price info can not change ST_OrderInProgress, so ignore it.
            {'ST_OrderInProgress' 'ST_Ignored', 'LogOrderInProgress'};
            });
        
        transitions_for_event_in_portfoy = TransitionMap ({
            {'ST_Passive' 'ST_InPortfoy'};
            {'ST_OrderInProgress' 'ST_InPortfoy'};
            });
        
        transitions_for_event_not_in_portfoy = TransitionMap ({
            {'ST_Passive' 'ST_NotInPortfoy'};
            {'ST_OrderInProgress' 'ST_NotInPortfoy'};
            });
        
        transitions_for_event_stop = TransitionMap ({
            {'ST_NotInPortfoy' 'ST_Passive'};
            {'ST_InPortfoy' 'ST_Passive'};
            });
    end
    
    properties
        strategy
        portfoy_data = PortfoyData([]);
        price
    end
    
    methods
        function obj = StockStrategy(strategy)
            obj@StateMachine('ST_Passive')
            obj.strategy = strategy;
            disp('StockStrategy is ready.');
            obj.PrintActiveState();
        end
        
        % External Events
        function PriceUpdate(obj, data)
            disp('  --> Event PriceUpdate is triggered');
            StockStrategy.transitions_for_event_price_update.go_next(obj, data);
        end
        
        function InPortfoy(obj, data)
            disp('  --> Event InPortfoy is triggered');
            StockStrategy.transitions_for_event_in_portfoy.go_next(obj, data);
        end
        
        function NotInPortfoy(obj)
            disp('  --> Event NotInPortfoy is triggered');
            
            StockStrategy.transitions_for_event_not_in_portfoy.go_next(obj, PortfoyData([]));
        end
        
        function Stop(obj)
            disp('  --> Event Stop is triggered');
            StockStrategy.transitions_for_event_stop.go_next(obj, []);
        end
        
    end
    
    methods (Access = {?TransitionMap})
        function LogStrategyInPassiveMode (obj)
            fprintf('   ==> Strategy in passive mode. All events are ignored.\n');
        end
        
    end
    methods (Access = {?StateMachine})
        
        %% In states
        function ST_Passive(obj, ~)
            
        end
        
        function ST_NotInPortfoy(obj, event_data)
            
            if strcmp(event_data.type, 'PriceData')
                obj.price = event_data.price;
                is_buy_signal = obj.price.close <=obj.strategy.buy_price;
                if (is_buy_signal)
                    obj.InternalEvent('ST_OrderInProgress', event_data);
                end
            elseif strcmp(event_data.type, 'PortfoyData')
                obj.portfoy_data = event_data;
            end
            
        end
        
        function ST_InPortfoy(obj, event_data)
            
            if strcmp(event_data.type, 'PriceData')
                obj.price = event_data.price;
                is_sell_signal = obj.price.close >=obj.strategy.take_profit_price;
                if (is_sell_signal)
                    obj.InternalEvent('ST_OrderInProgress', event_data);
                end
            elseif strcmp(event_data.type, 'PortfoyData')
                obj.portfoy_data = event_data;
            end
            
        end
        
        function ST_OrderInProgress(obj, ~)
            
        end
        
        
        
        
    end
end