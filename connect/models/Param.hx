package connect.models;


/**
    Parameters are used in product and asset definitions.
**/
class Param extends IdModel {
    /** Name of parameter. **/
    public var name(default, null): String;


    /** Description of parameter. **/
    public var description(default, null): String;


    /** Type of parameter. **/
    public var type(default, null): String;


    /** Value of parameter. **/
    public var value(default, null): String;


    /** Error indicated for parameter. **/
    public var valueError(default, null): String;


    /** Collections of string choices for parameter. **/
    public var valueChoice(default, null): Collection<String>;


    // Undocumented fields (they appear in PHP SDK)


    /** Title for parameter. **/
    public var title(default, null): String;


    /** Scope of parameter. **/
    public var scope(default, null): String;


    /** Parameter constraints. **/
    public var constraints(default, null): Constraints;


    /** Collection of available dropdown choices for parameter. **/
    public var valueChoices(default, null): Collection<Choice>;


    /** Param phase. **/
    public var phase(default, null): String;


    /** Events. **/
    public var events(default, null): Events;


    /** Marketplace. **/
    public var marketplace(default, null): Marketplace;


    public function new() {
        super();
        this._setFieldClassNames([
            'valueChoice' => 'String',
            'valueChoices' => 'Choice',
        ]);
    }
}
