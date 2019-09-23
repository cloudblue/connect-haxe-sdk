package connect.api;

class ConnectApi {
    public var fulfillment(default, null): FulfillmentApi;

    public static function getInstance() : ConnectApi {
        if (instance == null) {
            instance = new ConnectApi();
        }
        return instance;
    }


    private static var instance: ConnectApi;


    private function new() {
        this.fulfillment = new FulfillmentApi();
    }
}