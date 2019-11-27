package tests.mocks;

import connect.Blob;
import connect.api.IUsageApi;
import connect.api.Query;
import haxe.Json;


class UsageApiMock extends Mock implements IUsageApi {
    public function new() {
        super();
        this.list = Mock.parseJsonFile('tests/mocks/data/usagefile_list.json');
    }


    public function listUsageFiles(filters: Query): String {
        this.calledFunction('listUsageFiles', [filters]);
        return Json.stringify(this.list);
    }


    public function createUsageFile(body: String): String {
        this.calledFunction('createUsageFile', [body]);
        return Json.stringify(this.list[0]);
    }


    public function getUsageFile(id: String): String {
        this.calledFunction('getUsageFile', [id]);
        final usageFiles = this.list.filter((usageFile) -> usageFile.id == id);
        if (usageFiles.length > 0) {
            return Json.stringify(usageFiles[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function updateUsageFile(id: String, body: String): String {
        this.calledFunction('updateUsageFile', [id, body]);
        return this.getUsageFile(id);
    }


    public function deleteUsageFile(id: String): Void {
        this.calledFunction('deleteUsageFile', [id]);
    }


    public function uploadUsageFile(id: String, file: Blob): String {
        this.calledFunction('uploadUsageFile', [id, file]);
        return this.getUsageFile(id);
    }


    public function submitUsageFileAction(id: String): String {
        this.calledFunction('submitUsageFileAction', [id]);
        return this.getUsageFile(id);
    }


    public function acceptUsageFileAction(id: String, note: String): String {
        this.calledFunction('acceptUsageFileAction', [id, note]);
        return this.getUsageFile(id);
    }


    public function rejectUsageFileAction(id: String, note: String): String {
        this.calledFunction('rejectUsageFileAction', [id, note]);
        return this.getUsageFile(id);
    }


    public function closeUsageFileAction(id: String): String {
        this.calledFunction('closeUsageFileAction', [id]);
        return this.getUsageFile(id);
    }


    public function getProductSpecificUsageFileTemplate(productId: String): String {
        this.calledFunction('getProductSpecificUsageFileTemplate', [productId]);
        return '{"template_link": "https://storage.googleapis.com/apsconnect-rteam.appspot.com/PRD-783-078-030/template/TEMPLATE-PRD-783-078-030?GoogleAccessId=quickstart-usage-collector%40apsconnect-rteam.iam.gserviceaccount.com&Expires=1548767260&Signature=WKiObnvvZjEElgxrOyscXJKI82bZg%2BESUZThnpGXYTNKFkjKwr378TQwbSZlXa41cR4M0x1yCt2KqCbo45zxpgip8WTLpJx05RvMmIiNOGFwLjK6nd1pwfXKRM0aUmkbxQ1B4GF3hLJWMqCzWWzDN8UNP7vKi7mamlV%2F1gv16OGsGgpbHtEDSXHNMciQOHOa0Fue5O12zKmE0gh4j8RxHUA5hl8etss57rWHkoGfOSG0nCJAIKIHS%2FJ2EW2X9o1nIIDIqsNrESrItuekwLad5t6%2FtQW8CkVal3dC9jXhelR%2FzzcGRBlbTrDr6GHw%2FECGfnL8q9RxpH0tk335Wi7zpQ%3D%3D&response-content-disposition=attachment%3B+filename%3D%22TEMPLATE-PRD-783-078-030.csv%22"}';
    }


    public function uploadReconciliationFileFromProvider(id: String, file: Blob): String {
        this.calledFunction('uploadReconciliationFileFromProvider', [id, file]);
        return this.getUsageFile(id);
    }


    public function reprocessProcessedFile(id: String): String {
        this.calledFunction('reprocessProcessedFile', [id]);
        return this.getUsageFile(id);
    }


    public function listUsageRecords(filters: Query): String {
        return null;
    }


    public function getUsageRecord(id: String): String {
        return null;
    }


    public function updateUsageRecord(id: String, record: String): String {
        return null;
    }


    public function closeUsageRecord(id: String, record: String): String {
        return null;
    }


    private final list: Array<Dynamic>;
}
