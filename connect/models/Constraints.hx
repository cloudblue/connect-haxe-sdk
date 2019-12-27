/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
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
