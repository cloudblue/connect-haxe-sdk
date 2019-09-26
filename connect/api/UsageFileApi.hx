package connect.api;


class UsageFileApi {
    private static inline var USAGE_FILES_PATH = 'usage/files';
    private static inline var USAGE_PRODUCTS_PATH = 'usage/products';


    public function new() {}


    public function listUsageFiles(?filters: QueryParams): Array<Dynamic> {
        return ApiClient.getInstance().get(USAGE_FILES_PATH, null, null, filters);
    }


    public function createUsageFile(): Dynamic {
        return ApiClient.getInstance().post(USAGE_FILES_PATH);
    }


    public function getUsageFile(id: String): Dynamic {
        return ApiClient.getInstance().get(USAGE_FILES_PATH, id);
    }


    public function updateUsageFile(file: Dynamic): Dynamic {
        return ApiClient.getInstance().put(USAGE_FILES_PATH, file.id, file);
    }


    public function deleteUsageFile(id: String): Void {
        ApiClient.getInstance().post(USAGE_FILES_PATH, id, 'delete');
    }


    public function uploadUsageFile(file: Dynamic): Dynamic {
        return ApiClient.getInstance().post(USAGE_FILES_PATH, file.id, 'upload', file);
    }


    public function submitUsageFileAction(id: String): Dynamic {
        return ApiClient.getInstance().post(USAGE_FILES_PATH, id, 'submit');
    }


    public function acceptUsageFileAction(id: String): Dynamic {
        return ApiClient.getInstance().post(USAGE_FILES_PATH, id, 'accept');
    }


    public function rejectUsageFileAction(id: String): Dynamic {
        return ApiClient.getInstance().post(USAGE_FILES_PATH, id, 'reject');
    }


    public function closeUsageFileAction(id: String): Dynamic {
        return ApiClient.getInstance().post(USAGE_FILES_PATH, id, 'close');
    }


    public function getProductSpecificUsageFileTemplate(product_id: String): Dynamic {
        return ApiClient.getInstance().get(USAGE_PRODUCTS_PATH, product_id, 'template');
    }


    public function uploadReconciliationFileFromProvider(id: String, file: String): Dynamic {
        return ApiClient.getInstance().postFile(
            USAGE_FILES_PATH,
            id,
            'reconciliation',
            'reconciliation_file',
            'reconciliation_file.xlsx',
            file
        );
    }
}
