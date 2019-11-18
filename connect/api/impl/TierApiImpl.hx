package connect.api.impl;


class TierApiImpl extends Base implements ITierApi {
    private static inline var TCR_PATH = 'tier/config-requests';
    private static inline var TA_PATH = 'tier/accounts';
    private static inline var TC_PATH = 'tier/configs';


    public function new() {}


    public function listTierConfigRequests(filters: QueryParams): String {
        return Env.getApiClient().get(TCR_PATH, null, null, filters);
    }


    public function createTierConfigRequest(): String {
        return Env.getApiClient().post(TCR_PATH);
    }


    public function getTierConfigRequest(id: String): String {
        return Env.getApiClient().get(TCR_PATH, id);
    }


    public function updateTierConfigRequest(id: String, tcr: String): String {
        return Env.getApiClient().put(TCR_PATH, id, tcr);
    }


    public function pendTierConfigRequest(id: String): String {
        return Env.getApiClient().post(TCR_PATH, id, 'pend');
    }


    public function inquireTierConfigRequest(id: String): String {
        return Env.getApiClient().post(TCR_PATH, id, 'inquire');
    }


    public function approveTierConfigRequest(id: String, data: String): String {
        return Env.getApiClient().post(TCR_PATH, id, 'approve', data);
    }


    public function failTierConfigRequest(id: String, data: String): String {
        return Env.getApiClient().post(TCR_PATH, id, 'fail', data);
    }


    public function assignTierConfigRequest(id: String): String {
        return Env.getApiClient().post(TCR_PATH, id, 'assign');
    }


    public function unassignTierConfigRequest(id: String): String {
        return Env.getApiClient().post(TCR_PATH, id, 'unassign');
    }


    public function listTierAccounts(filters: QueryParams): String {
        return Env.getApiClient().get(TA_PATH, null, null, filters);
    }


    public function getTierAccount(id: String): String {
        return Env.getApiClient().get(TA_PATH, id);
    }


    public function listTierConfigs(filters: QueryParams): String {
        return Env.getApiClient().get(TC_PATH, null, null, filters);
    }


    public function getTierConfig(id: String): String {
        return Env.getApiClient().get(TC_PATH, id);
    }
}
