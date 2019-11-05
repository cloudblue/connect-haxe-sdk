package connect.api;

class Response extends Base {
    public var status(default, null) : Int;
    public var text(default, null) : String;


    public function new(status:Int, text:String) {
        this.status = status;
        this.text = text;
    }
}
