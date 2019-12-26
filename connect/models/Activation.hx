package connect.models;


/**
    Contract activation information.
**/
class Activation extends Model {
    /** Activation link. **/
    public var link: String;


    /** Activation message. **/
    public var message: String;


    /** Activation date. **/
    public var date: DateTime;

    public function new() {
        super();
        this._setFieldClassNames([
            'date' => 'DateTime',
        ]);
    }
}
