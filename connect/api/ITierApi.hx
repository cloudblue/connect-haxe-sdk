package connect.api;


@:dox(hide)
interface ITierApi {
    public function listTierConfigRequests(filters: QueryParams): Array<Dynamic>;
    public function createTierConfigRequest(body: String): Dynamic;
    public function getTierConfigRequest(id: String): Dynamic;
    public function updateTierConfigRequest(id: String, tcr: String): Dynamic;
    public function pendTierConfigRequest(id: String): Dynamic;
    public function inquireTierConfigRequest(id: String): Dynamic;
    public function approveTierConfigRequest(id: String, data: String): Dynamic;
    public function failTierConfigRequest(id: String, data: String): Dynamic;
    public function assignTierConfigRequest(id: String): Dynamic;
    public function unassignTierConfigRequest(id: String): Dynamic;
    public function listTierAccounts(filters: QueryParams): Array<Dynamic>;
    public function getTierAccount(id: String): Dynamic;
    public function listTierConfigs(filters: QueryParams): Array<Dynamic>;
    public function getTierConfig(id: String): Dynamic;
}
