package connect.api;


@:dox(hide)
interface IUsageApi {
    public function listUsageFiles(filters: Query): String;
    public function createUsageFile(body: String): String;
    public function getUsageFile(id: String): String;
    public function updateUsageFile(id: String, body: String): String;
    public function deleteUsageFile(id: String): Void;
    public function uploadUsageFile(id: String, file: Blob): String;
    public function submitUsageFileAction(id: String): String;
    public function acceptUsageFileAction(id: String, note: String): String;
    public function rejectUsageFileAction(id: String, note: String): String;
    public function closeUsageFileAction(id: String): String;
    public function getProductSpecificUsageFileTemplate(productId: String): String;
    public function uploadReconciliationFileFromProvider(id: String, file: Blob): String;
    public function reprocessProcessedFile(id: String): String;
    public function listUsageRecords(filters: Query): String;
    public function getUsageRecord(id: String): String;
    public function updateUsageRecord(id: String, record: String): String;
    public function closeUsageRecord(id: String, record: String): String;
}
