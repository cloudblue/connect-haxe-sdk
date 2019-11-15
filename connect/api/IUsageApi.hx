package connect.api;


@:dox(hide)
interface IUsageApi {
    public function listUsageFiles(filters: QueryParams): Array<Dynamic>;
    public function createUsageFile(body: String): Dynamic;
    public function getUsageFile(id: String): Dynamic;
    public function updateUsageFile(id: String, body: String): Dynamic;
    public function deleteUsageFile(id: String): Void;
    public function uploadUsageFile(id: String, file: Blob): Dynamic;
    public function submitUsageFileAction(id: String): Dynamic;
    public function acceptUsageFileAction(id: String, note: String): Dynamic;
    public function rejectUsageFileAction(id: String, note: String): Dynamic;
    public function closeUsageFileAction(id: String): Dynamic;
    public function getProductSpecificUsageFileTemplate(productId: String): Dynamic;
    public function uploadReconciliationFileFromProvider(id: String, file: Blob): Dynamic;
    public function reprocessProcessedFile(id: String): Dynamic;
    public function listUsageRecords(filters: QueryParams): Array<Dynamic>;
    public function getUsageRecord(id: String): Dynamic;
    public function updateUsageRecord(id: String, record: String): Dynamic;
    public function closeUsageRecord(id: String, record: String): Dynamic;
}
