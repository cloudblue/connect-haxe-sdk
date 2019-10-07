package connect.models;


/**
    Parameter constraints.
**/
class Constraints extends Model {
    /** Is the parameter hidden? **/
    public var hidden(default, null): Bool;


    /** Is the parameter required? **/
    public var required(default, null): Bool;


    /** A collection of choices. **/
    public var choices(default, null): Collection<Choice>;


    /** Is the constraint unique? **/
    public var unique(default, null): Bool;
}
