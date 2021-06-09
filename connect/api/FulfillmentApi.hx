/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.logger.Logger;
import connect.models.IdModel;

class FulfillmentApi extends Base {
    private static final REQUESTS_PATH = 'requests';
    private static final TEMPLATES_PATH = 'templates';
    private static final ASSETS_PATH = 'assets';

    public function new() {
    }

    public function listRequests(filters: Query): String {
        return ConnectHelper.get(REQUESTS_PATH, null, null, filters, false, Logger.LEVEL_DEBUG);
    }

    public function getRequest(id: String): String {
        return ConnectHelper.get(REQUESTS_PATH, id);
    }

    public function createRequest( body: String): String {
        return ConnectHelper.post(REQUESTS_PATH, null, null, body);    
    }

    public function updateRequest(id: String, request: String): String {
        return ConnectHelper.put(REQUESTS_PATH, id, null, request);
    }

    public function changeRequestStatus(id: String, status: String, data: String): String {
        return ConnectHelper.post(REQUESTS_PATH, id, status, data);
    }

    public function assignRequest(id: String, assignee: String): String {
        return ConnectHelper.post(REQUESTS_PATH, id, 'assign/' + assignee);
    }

    public function renderTemplate(id: String, requestId: String): String {
        return ConnectHelper.get(TEMPLATES_PATH, id, 'render',
            new Query().equal('request_id', requestId));
    }

    public function listAssets(filters: Query): String {
        return ConnectHelper.get(ASSETS_PATH, null, null, filters, true);
    }

    public function getAsset(id: String): String {
        return ConnectHelper.get(ASSETS_PATH, id);
    }

    public function getAssetRequests(id: String): String {
        return ConnectHelper.get(ASSETS_PATH, id, 'requests');
    }
}
