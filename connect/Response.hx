package connect;

class Response {
    public var status(default, null) : Int;
    public var text(default, null) : String;

    public function new(status:Int, text:String) {
        this.status = status;
        this.text = text;
    }
}