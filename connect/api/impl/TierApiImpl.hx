package connect.api.impl;


class TierApiImpl extends Base implements ITierApi {
    private static final TCR_PATH = 'tier/config-requests';
    private static final TA_PATH = 'tier/accounts';
    private static final TC_PATH = 'tier/configs';

    public function new() {}


    public function listTierConfigRequests(filters: Query): String {
        return ConnectHelper.get(TCR_PATH, null, null, filters);
    }


    public function createTierConfigRequest(body: String): String {
        return ConnectHelper.post(TCR_PATH, null, null, body);
    }


    public function getTierConfigRequest(id: String): String {
        return ConnectHelper.get(TCR_PATH, id);
    }


    public function updateTierConfigRequest(id: String, tcr: String): String {
        return ConnectHelper.put(TCR_PATH, id, tcr);
    }


    public function pendTierConfigRequest(id: String): String {
        return ConnectHelper.post(TCR_PATH, id, 'pend');
    }


    public function inquireTierConfigRequest(id: String): String {
        return ConnectHelper.post(TCR_PATH, id, 'inquire');
    }


    public function approveTierConfigRequest(id: String, data: String): String {
        return ConnectHelper.post(TCR_PATH, id, 'approve', data);
    }


    public function failTierConfigRequest(id: String, data: String): String {
        return ConnectHelper.post(TCR_PATH, id, 'fail', data);
    }


    public function assignTierConfigRequest(id: String): String {
        return ConnectHelper.post(TCR_PATH, id, 'assign');
    }


    public function unassignTierConfigRequest(id: String): String {
        return ConnectHelper.post(TCR_PATH, id, 'unassign');
    }


    public function listTierAccounts(filters: Query): String {
        return ConnectHelper.get(TA_PATH, null, null, filters);
    }


    public function getTierAccount(id: String): String {
        return ConnectHelper.get(TA_PATH, id);
    }


    public function listTierConfigs(filters: Query): String {
        return ConnectHelper.get(TC_PATH, null, null, filters, true);
    }


    public function getTierConfig(id: String): String {
        return ConnectHelper.get(TC_PATH, id);
    }
}
