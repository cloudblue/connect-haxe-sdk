package connect.models;


class Events extends Model {
    public var created(default, null): Event;
    public var inquired(default, null): Event;
    public var pended(default, null): Event;
    public var validated(default, null): Event;
    public var updated(default, null): Event;
    public var approved(default, null): Event;
    public var uploaded(default, null): Event;
    public var submitted(default, null): Event;
    public var accepted(default, null): Event;
    public var rejected(default, null): Event;
    public var closed(default, null): Event;


    public function new() {
        this._setFieldClassNames([
            'created' => 'Event',
            'inquired' => 'Event',
            'pended' => 'Event',
            'validated' => 'Event',
            'updated' => 'Event',
            'approved' => 'Event',
            'uploaded' => 'Event',
            'submitted' => 'Event',
            'accepted' => 'Event',
            'rejected' => 'Event',
            'closed' => 'Event',
        ]);
    }
}
