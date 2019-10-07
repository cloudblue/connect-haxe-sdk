package connect.models;


class Agreement extends IdModel {
    /** Type of the agreement. One of: distribution, program, service. **/
    public var type(default, null): String;


    /** Title of the agreement. **/
    public var title(default, null): String;


    /** Agreement details (Markdown). **/
    public var description(default, null): String;


    /** Date of creation of the agreement. **/
    public var created(default, null): String;


    /**
        Date of the update of the agreement. It can be creation
        of the new version, change of the field, etc. (any change).
    **/
    public var updated(default, null): String;


    /** Reference to the owner account object. **/
    public var owner(default, null): Account;


    /** Agreement stats. **/
    public var stats(default, null): AgreementStats;


    /** Reference to the user who created the version. **/
    public var author(default, null): User;


    /** Chronological number of the version. **/
    public var version(default, null): Int;


    /** State of the version. **/
    public var active(default, null): Bool;


    /** Url to the document. **/
    public var link(default, null): String;


    /** Date of the creation of the version. **/
    public var versionCreated(default, null): String;


    /** Number of contracts this version has. **/
    public var versionContracts(default, null): Int;


    /** Program agreements can have distribution agreements associated with them. **/
    public var agreements(default, null): Collection<Agreement>;


    /** Reference to the parent program agreement (for distribution agreement). **/
    public var parent(default, null): Agreement;


    /** Reference to marketplace object (for distribution agreement). **/
    public var marketplace(default, null): Marketplace;


    // Undocumented fields (they appear in PHP SDK)


    /** Name of Agreement. **/
    public var name(default, null): String;


    public function new() {
        super();
        this._setFieldClassNames([
            'owner' => 'Account',
            'stats' => 'AgreementStats',
            'author' => 'User',
            'parent' => 'Agreement'
        ]);
    }
}
