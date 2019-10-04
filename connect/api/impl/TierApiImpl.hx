package connect.api.impl;


class TierApiImpl implements ITierApi {
    private static inline var TCR_PATH = 'tier/config-requests';
    private static inline var TA_PATH = 'tier/accounts';
    private static inline var TC_PATH = 'tier/configs';


    public function new() {}


    public function listTierConfigRequests(?filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(TCR_PATH, null, null, filters);
    }


    public function createTierConfigRequest(): Dynamic {
        return Environment.getApiClient().post(TCR_PATH);
    }


    public function getTierConfigRequest(id: String): Dynamic {
        return Environment.getApiClient().get(TCR_PATH, id);
    }


    public function updateTierConfigRequest(id: String, tcr: String): Dynamic {
        return Environment.getApiClient().put(TCR_PATH, id, tcr);
    }


    public function pendTierConfigRequest(id: String): Dynamic {
        return Environment.getApiClient().post(TCR_PATH, id, 'pend');
    }


    public function inquireTierConfigRequest(id: String): Dynamic {
        return Environment.getApiClient().post(TCR_PATH, id, 'inquire');
    }


    public function approveTierConfigRequest(id: String, data: String): Dynamic {
        return Environment.getApiClient().post(TCR_PATH, id, 'approve', data);
    }


    public function failTierConfigRequest(id: String, data: String): Dynamic {
        return Environment.getApiClient().post(TCR_PATH, id, 'fail', data);
    }


    public function assignTierConfigRequest(id: String): Dynamic {
        return Environment.getApiClient().post(TCR_PATH, id, 'assign');
    }


    public function unassignTierConfigRequest(id: String): Dynamic {
        return Environment.getApiClient().post(TCR_PATH, id, 'unassign');
    }


    public function listTierAccounts(?filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(TA_PATH, null, null, filters);
    }


    public function getTierAccount(id: String): Dynamic {
        return Environment.getApiClient().get(TA_PATH, id);
    }


    public function listTierConfigs(?filters: QueryParams): Array<Dynamic> {
        return Environment.getApiClient().get(TC_PATH, null, null, filters);
    }


    public function getTierConfig(id: String): Dynamic {
        return Environment.getApiClient().get(TC_PATH, id);
    }
}