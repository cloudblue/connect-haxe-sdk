package connect.api;

class ConnectApi {
    public var fulfillment(default, null): FulfillmentApi;
    public var usage(default, null): UsageApi;
    public var tier(default, null): TierApi;
    public var general(default, null): GeneralApi;

    public static function getInstance() : ConnectApi {
        if (instance == null) {
            instance = new ConnectApi();
        }
        return instance;
    }


    private static var instance: ConnectApi;


    private function new() {
        this.fulfillment = new FulfillmentApi();
        this.usage = new UsageApi();
        this.tier = new TierApi();
        this.general = new GeneralApi();
    }
}
