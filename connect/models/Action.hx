package connect.models;


class Action extends IdModel {
    /** Title field of Action. **/
    public var title: String;


    /** Only supported type is button for now. **/
    public var type: String;


    /** A description of the action, describing the operation that will be performed. **/
    public var description: String;


    /** Specifies all constrains applied on the action. One of: asset, tier-1, tier-2. **/
    public var scope: String;
}
