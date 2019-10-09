package connect.api;


interface IUsageApi {
    public function listUsageFiles(filters: QueryParams): Array<Dynamic>;
    public function createUsageFile(): Dynamic;
    public function getUsageFile(id: String): Dynamic;
    public function updateUsageFile(id: String, file: String): Dynamic;
    public function deleteUsageFile(id: String): Void;
    public function uploadUsageFile(id: String, file: String): Dynamic;
    public function submitUsageFileAction(id: String): Dynamic;
    public function acceptUsageFileAction(id: String): Dynamic;
    public function rejectUsageFileAction(id: String): Dynamic;
    public function closeUsageFileAction(id: String): Dynamic;
    public function getProductSpecificUsageFileTemplate(product_id: String): Dynamic;
    public function uploadReconciliationFileFromProvider(id: String, file: String): Dynamic;
    public function reprocessProcessedFile(id: String): Dynamic;
    public function listUsageRecords(filters: QueryParams): Array<Dynamic>;
    public function getUsageRecord(id: String): Dynamic;
    public function updateUsageRecord(id: String, record: String): Dynamic;
    public function closeUsageRecord(id: String, record: String): Dynamic;
}
