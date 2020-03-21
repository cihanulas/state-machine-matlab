classdef PriceData< EventData
    
    properties
        % Test price event for buying.
    price
    
    end
    methods (Access = public)
        function obj = PriceData(price)
            obj@EventData('PriceData');
            obj.price = price;
        end
    end
end