package connect.api;

class Response extends Base {
    public final status: Int;
    public final text: String;
    public final data: ByteData;

    public function new(status:Int, text:String, data:ByteData) {
        this.status = status;
        this.text = text;
        this.data = data;
    }
}
