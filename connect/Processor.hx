package connect;


typedef FilterMap = Map<String, String>;


/**
    The Processor class automates the processing of requests from Connect. Each Processor instance
    is capable of listing requests from one Connect API (i.e. Fulfillment, Tier Config, etc).

    To create processors for the typical cases, like a processor for the Fulfillment API, you can
    create a preconfigured instance using the ProcessorFactory class.

    In order to process the requests, you must either assign a function to the onProcessRequest
    method receiving the request (of Dynamic type, since every API returns different objects),
    or subclass Processor and override the onProcessRequest method.
**/
class Processor {
    /**
        Last component of the path to the connect API used for listing (e.g. "requests" for the Fulfillment API).
    **/
    public var listPath(default, null) : String;


    /**
        A FilterMap (a map with string keys and values) with the default set of filters used for listing requests.
    **/
    public var defaultFilters(default, null) : FilterMap;


    /**
        Creates a new Processor.

        @param listPath value for the listPath property.
        @param defaultFilters value for the defaultFilters property.
        @param onProcessRequest optional function to assign to the onProcessRequest dynamic method.
    **/
    public function new(listPath:String, defaultFilters:FilterMap, ?onProcessRequest:(Dynamic) -> Activation) {
        this.listPath = listPath;
        this.defaultFilters = defaultFilters;
        if (onProcessRequest != null) {
            this.onProcessRequest = onProcessRequest;
        }
    }
    

    /**
        Lists all the pending requests for this processor.

        @returns an array of anonymous structures with the parsed list of requests.
        @throws String if the request fails.
    **/
    public function list() : Array<Dynamic> {
        return Connect.getInstance().listRequests(listPath, defaultFilters);
    }


    /**
        Process all the pending requests. for every requested returned by list(),
        it calls the onProcessRequest method (which should be overriden or assigned).
    **/
    public function process() : Void {
        var list = this.list();
        for (request in list) {
            try {
                var activation = this.onProcessRequest(request);
                //var response = Config.getInstance().syncRequest("POST", request.id + "/approve/", activation.toString());
            }
        }
    }

    
    /**
        Processes one request. You should dynamically assign a function to this method, or subclass
        Processor and override it. Within the method, the step to correctly process a request
        depend on the type of request, and are described on ProcessorFactory for each type of
        Processor.

        @returns an instance implementing the Activation interface.
    **/
    public dynamic function onProcessRequest(request:Dynamic) : Activation {
        throw "onProcessRequest method must be assigned";
    }
}
