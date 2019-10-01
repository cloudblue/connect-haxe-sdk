package connect.models;


class TileApproval implements IApproval {
    public function new(markdown: String) {
        this.markdown = markdown;
    }

    public function toString(): String {
        return '{"activation_tile": "' + this.markdown + '"}';
    }

    private var markdown: String;
}
