classdef PortfoyData < EventData
    
    
    
    properties
        % Test price event for buying.
    portfoy
    end
    methods (Access = public)
        function obj = PortfoyData(portfoy)
            obj@EventData('PortfoyData');
            obj.portfoy = portfoy;
        end
    end
end