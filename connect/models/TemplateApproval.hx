package connect.models;


class TemplateApproval implements IApproval {
    public function new(templateId: String) {
        this.templateId = templateId;
    }

    public function toString(): String {
        return '{"template_id": "' + this.templateId + '"}';
    }

    private var templateId: String;
}
