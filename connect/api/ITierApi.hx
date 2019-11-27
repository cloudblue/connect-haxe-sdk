package connect.api;


@:dox(hide)
interface ITierApi {
    public function listTierConfigRequests(filters: Query): String;
    public function createTierConfigRequest(body: String): String;
    public function getTierConfigRequest(id: String): String;
    public function updateTierConfigRequest(id: String, tcr: String): String;
    public function pendTierConfigRequest(id: String): String;
    public function inquireTierConfigRequest(id: String): String;
    public function approveTierConfigRequest(id: String, data: String): String;
    public function failTierConfigRequest(id: String, data: String): String;
    public function assignTierConfigRequest(id: String): String;
    public function unassignTierConfigRequest(id: String): String;
    public function listTierAccounts(filters: Query): String;
    public function getTierAccount(id: String): String;
    public function listTierConfigs(filters: Query): String;
    public function getTierConfig(id: String): String;
}
