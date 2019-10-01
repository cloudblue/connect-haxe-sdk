package connect.models;


class Param extends IdModel {
    public var name(default, null): String;
    public var description(default, null): String;
    public var type(default, null): String;
    public var value(default, null): String;
    public var valueError(default, null): String;
    public var valueChoice(default, null): Collection<String>;

    // Undocumented fields (they appear in PHP SDK)

    public var title(default, null): String;
    public var scope(default, null): String;
    public var constraints(default, null): Constraints;
    public var valueChoices(default, null): Collection<Choice>;
    public var phase(default, null): String;
    public var events(default, null): Events;
    public var marketplace(default, null): Marketplace;


    public function new() {
        this._setFieldClassNames([
            'valueChoice' => 'String',
            'valueChoices' => 'Choice',
        ]);
    }
}
