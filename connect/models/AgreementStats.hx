package connect.models;


/**
    Agreement Stats.
**/
class AgreementStats extends Model {
    /** Number of contracts this agreement has. **/
    public var contracts(default, null): Int;


    /** Number of versions in the agreement. **/
    public var versions(default, null): Int;
}
