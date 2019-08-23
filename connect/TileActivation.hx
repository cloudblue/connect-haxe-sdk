package connect;

class TileActivation implements Activation {
    public function new(markdown:String) {
        this.markdown = markdown;
    }

    public function toString() : String {
        return '{"activation_tile": "' + this.markdown + '"}';
    }

    private var markdown : String;
}