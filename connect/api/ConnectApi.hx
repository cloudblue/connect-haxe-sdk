package connect.api;

class ConnectApi {
    public var fulfillment(default, null): FulfillmentApi;
    public var usage(default, null): UsageApi;
    public var tier(default, null): TierApi;
    public var general(default, null): GeneralApi;


    public function new(?apiClient: IApiClient) {
        apiClient = (apiClient != null) ? apiClient : Defaults.getApiClient();
        this.fulfillment = new FulfillmentApi(apiClient);
        this.usage = new UsageApi(apiClient);
        this.tier = new TierApi(apiClient);
        this.general = new GeneralApi(apiClient);
    }
}
