/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.util.Blob;
import connect.models.IdModel;

class UsageApi extends Base {
    private static final USAGE_FILES_PATH = 'usage/files';
    private static final USAGE_PRODUCTS_PATH = 'usage/products';
    private static final USAGE_RECORDS_PATH = 'usage/records';

    public function new() {
    }

    public function listUsageFiles(filters: Query): String {
        return ConnectHelper.get(USAGE_FILES_PATH, null, null, filters);
    }

    public function createUsageFile(body: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(USAGE_FILES_PATH, null, null, body, currentRequest);
    }

    public function getUsageFile(id: String): String {
        return ConnectHelper.get(USAGE_FILES_PATH, id);
    }

    public function updateUsageFile(id: String, body: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.put(USAGE_FILES_PATH, id, null, body, currentRequest);
    }

    public function deleteUsageFile(id: String, currentRequest: Null<IdModel>): Void {
        ConnectHelper.post(USAGE_FILES_PATH, id, 'delete', currentRequest);
    }

    public function uploadUsageFile(id: String, file: Blob, currentRequest: Null<IdModel>): String {
        return ConnectHelper.postFile(
            USAGE_FILES_PATH,
            id,
            'upload',
            'usage_file',
            'usage_file.xlsx',
            file,
            currentRequest
        );
    }

    public function submitUsageFileAction(id: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(USAGE_FILES_PATH, id, 'submit', currentRequest);
    }

    public function acceptUsageFileAction(id: String, note: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(USAGE_FILES_PATH, id, 'accept',
            haxe.Json.stringify({acceptance_note: note}), currentRequest);
    }

    public function rejectUsageFileAction(id: String, note: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(USAGE_FILES_PATH, id, 'reject',
            haxe.Json.stringify({rejection_note: note}), currentRequest);
    }

    public function closeUsageFileAction(id: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(USAGE_FILES_PATH, id, 'close', currentRequest);
    }

    public function getProductSpecificUsageFileTemplate(productId: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.get(USAGE_PRODUCTS_PATH, productId, 'template', currentRequest);
    }

    public function uploadReconciliationFileFromProvider(id: String, file: Blob, currentRequest: Null<IdModel>): String {
        return ConnectHelper.postFile(
            USAGE_FILES_PATH,
            id,
            'reconciliation',
            'reconciliation_file',
            'reconciliation_file.xlsx',
            file,
            currentRequest
        );
    }

    public function reprocessProcessedFile(id: String, currentRequest: Null<IdModel>): String {
        return ConnectHelper.post(USAGE_FILES_PATH, id, 'reprocess', currentRequest);
    }

    public function listUsageRecords(filters: Query): String {
        return ConnectHelper.get(USAGE_RECORDS_PATH, null, null, filters);
    }

    public function getUsageRecord(id: String): String {
        return ConnectHelper.get(USAGE_RECORDS_PATH, id);
    }

    public function updateUsageRecord(id: String, record: String): String {
        return ConnectHelper.put(USAGE_RECORDS_PATH, id, null, record);
    }

    public function closeUsageRecord(id: String, record: String): String {
        return ConnectHelper.post(USAGE_RECORDS_PATH, id, 'close', record);
    }
}
