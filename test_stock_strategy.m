function test_stock_strategy
clear all, close all,clc
strategy.stock = 'AAPL';
strategy.buy_price = 1;
strategy.take_profit_price = 1.2;
strategy.stop = 0.9;
strategy.lot = 100; 
strategy.after_stop_buy= 0.8;

stock_strategy = StockStrategy (strategy);
%% test initial state
expect_current_state('ST_Passive');

%% Test PriceUpdate event when in ST_Passive stay in same state
price = PriceData (struct('high', 1.1, 'close', 1.1, 'low',1, 'open', 0.9));
stock_strategy.PriceUpdate(price);
expect_current_state('ST_Passive');

%% Test InPortfoyEvent
portfoy_data = PortfoyData(struct('buy_price', 1.1, 'close', 1.1, 'lot', 100));
stock_strategy.InPortfoy(portfoy_data);
expect_current_state('ST_InPortfoy');

%% State: ST_InPortfoy: check take_profit price
fprintf ('\nTest Price Update for Take Profit');
price_for_take_profit = PriceData (struct('high', 1.2, 'close', 1.2, 'low',1, 'open', 0.9));
stock_strategy.PriceUpdate(price_for_take_profit);
expect_current_state('ST_OrderInProgress');

% Event NotInPortfoy
stock_strategy.NotInPortfoy();
expect_current_state('ST_NotInPortfoy');

% PriceUpdate Event check buy price
price_for_buy = PriceData (struct('high', 1.2, 'close', 1, 'low',0.9, 'open', 0.8));
stock_strategy.PriceUpdate(price_for_buy);
expect_current_state('ST_OrderInProgress');

% InPortfoy Event
portfoy_data = PortfoyData(struct('buy_price', 1, 'close', 1.15, 'lot', 70));
stock_strategy.InPortfoy(portfoy_data);
expect_current_state('ST_InPortfoy');
expect_lot(70);

portfoy_data = PortfoyData(struct('buy_price', 1, 'close', 1.15, 'lot', 100));
stock_strategy.InPortfoy(portfoy_data);
expect_current_state('ST_InPortfoy');
expect_lot(100);


%% Stop Stategy -> Passive Mode.
fprintf ('\nTest Stop Event');
stock_strategy = StockStrategy (strategy);
% Test Stop
stock_strategy.NotInPortfoy();
expect_current_state('ST_NotInPortfoy');

% Event Stop
stock_strategy.Stop();
expect_current_state('ST_Passive');

portfoy_data = PortfoyData(struct('buy_price', 1.1, 'close', 1.1, 'lot', 100));
stock_strategy.InPortfoy(portfoy_data);
expect_current_state('ST_InPortfoy');
stock_strategy.Stop();
expect_current_state('ST_Passive');


    function expect_current_state (state)
        assert (strcmp(stock_strategy.CurrentState(),state));
    end

    function expect_lot (lot)
        assert (stock_strategy.portfoy.lot == lot);
    end

end
