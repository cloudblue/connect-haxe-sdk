package connect.models;


/**
    Parameter constraints.
**/
class Constraints extends Model {
    /** Is the parameter hidden? **/
    public var hidden: Bool;


    /** Is the parameter required? **/
    public var required: Bool;


    /** A collection of choices. **/
    public var choices: Collection<Choice>;


    /** Is the constraint unique? **/
    public var unique: Bool;
}
