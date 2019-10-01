package connect.api;

class TierApi {
    private static inline var TCR_PATH = 'tier/config-requests';
    private static inline var TA_PATH = 'tier/accounts';
    private static inline var TC_PATH = 'tier/configs';

    private var client: IApiClient;


    public function new(?client: IApiClient) {
        this.client = client != null ? client : ApiClient.getInstance();
    }


    public function listTierConfigRequests(?filters: QueryParams): Array<Dynamic> {
        return this.client.get(TCR_PATH, null, null, filters);
    }


    public function createTierConfigRequest(): Dynamic {
        return this.client.post(TCR_PATH);
    }


    public function getTierConfigRequest(id: String): Dynamic {
        return this.client.get(TCR_PATH, id);
    }


    public function updateTierConfigRequest(id: String, tcr: String): Dynamic {
        return this.client.put(TCR_PATH, id, tcr);
    }


    public function pendTierConfigRequest(id: String): Dynamic {
        return this.client.post(TCR_PATH, id, 'pend');
    }


    public function inquireTierConfigRequest(id: String): Dynamic {
        return this.client.post(TCR_PATH, id, 'inquire');
    }


    public function approveTierConfigRequest(id: String, data: String): Dynamic {
        return this.client.post(TCR_PATH, id, 'approve', data);
    }


    public function failTierConfigRequest(id: String, data: String): Dynamic {
        return this.client.post(TCR_PATH, id, 'fail', data);
    }


    public function assignTierConfigRequest(id: String): Dynamic {
        return this.client.post(TCR_PATH, id, 'assign');
    }


    public function unassignTierConfigRequest(id: String): Dynamic {
        return this.client.post(TCR_PATH, id, 'unassign');
    }


    public function listTierAccounts(?filters: QueryParams): Array<Dynamic> {
        return this.client.get(TA_PATH, null, null, filters);
    }


    public function getTierAccount(id: String): Dynamic {
        return this.client.get(TA_PATH, id);
    }


    public function listTierConfigs(?filters: QueryParams): Array<Dynamic> {
        return this.client.get(TC_PATH, null, null, filters);
    }


    public function getTierConfig(id: String): Dynamic {
        return this.client.get(TC_PATH, id);
    }
}
