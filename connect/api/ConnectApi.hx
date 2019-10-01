package connect.api;

class ConnectApi {
    public var fulfillment(default, null): IFulfillmentApi;
    public var usage(default, null): IUsageApi;
    public var tier(default, null): ITierApi;
    public var general(default, null): IGeneralApi;


    public function new(?apiClient: IApiClient) {
        apiClient = (apiClient != null) ? apiClient : Defaults.getApiClient();
        this.fulfillment = new connect.api.impl.FulfillmentApiImpl(apiClient);
        this.usage = new connect.api.impl.UsageApiImpl(apiClient);
        this.tier = new connect.api.impl.TierApiImpl(apiClient);
        this.general = new connect.api.impl.GeneralApiImpl(apiClient);
    }
}
