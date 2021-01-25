/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.models.IdModel;

class TierApi extends Base {
    private static final TCR_PATH = 'tier/config-requests';
    private static final TA_PATH = 'tier/accounts';
    private static final TC_PATH = 'tier/configs';

    public function new() {
    }

    public function listTierConfigRequests(filters: Query): String {
        return ConnectHelper.get(TCR_PATH, null, null, filters, true);
    }

    public function createTierConfigRequest(body: String): String {
        return ConnectHelper.post(TCR_PATH, null, null, body);
    }

    public function getTierConfigRequest(id: String): String {
        return ConnectHelper.get(TCR_PATH, id);
    }

    public function updateTierConfigRequest(id: String, tcr: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.put(TCR_PATH, id, null, tcr, currentRequest);
    }

    public function pendTierConfigRequest(id: String, currentRequest: Null<IdModel>): Void {
        ConnectHelper.post(TCR_PATH, id, 'pend', currentRequest);
    }

    public function inquireTierConfigRequest(id: String, currentRequest: Null<IdModel>): Void {
        ConnectHelper.post(TCR_PATH, id, 'inquire', currentRequest);
    }

    public function approveTierConfigRequest(id: String, data: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(TCR_PATH, id, 'approve', data, currentRequest);
    }

    public function failTierConfigRequest(id: String, data: String, currentRequest: Null<IdModel>): Void {
        ConnectHelper.post(TCR_PATH, id, 'fail', data, currentRequest);
    }

    public function assignTierConfigRequest(id: String, currentRequest: Null<IdModel>): Void {
        ConnectHelper.post(TCR_PATH, id, 'assign', currentRequest);
    }

    public function unassignTierConfigRequest(id: String, currentRequest: Null<IdModel>): Void {
        ConnectHelper.post(TCR_PATH, id, 'unassign', currentRequest);
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
