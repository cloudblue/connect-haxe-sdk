package tests.mocks;

import connect.api.ITierApi;
import connect.api.QueryParams;
import haxe.Json;


class TierApiMock extends Mock implements ITierApi {
    public function new() {
        super();
        this.accountList = Mock.parseJsonFile('tests/mocks/data/tieraccount_list.json');
        this.configList = Mock.parseJsonFile('tests/mocks/data/tierconfig_list.json');
    }


    public function listTierConfigRequests(filters: QueryParams): String {
        this.calledFunction('listTierConfigRequests', [filters]);
        return null;
    }


    public function createTierConfigRequest(body: String): String {
        this.calledFunction('createTierConfigRequest', [body]);
        return null;
    }


    public function getTierConfigRequest(id: String): String {
        this.calledFunction('getTierConfigRequest', [id]);
        return null;
    }

    public function updateTierConfigRequest(id: String, tcr: String): String {
        this.calledFunction('updateTierConfigRequest', [id, tcr]);
        return null;
    }


    public function pendTierConfigRequest(id: String): String {
        this.calledFunction('pendTierConfigRequest', [id]);
        return null;
    }


    public function inquireTierConfigRequest(id: String): String {
        this.calledFunction('inquireTierConfigRequest', [id]);
        return null;
    }


    public function approveTierConfigRequest(id: String, data: String): String {
        this.calledFunction('approveTierConfigRequest', [id, data]);
        return null;
    }


    public function failTierConfigRequest(id: String, data: String): String {
        this.calledFunction('failTierConfigRequest', [id, data]);
        return null;
    }


    public function assignTierConfigRequest(id: String): String {
        this.calledFunction('assignTierConfigRequest', [id]);
        return null;
    }


    public function unassignTierConfigRequest(id: String): String {
        this.calledFunction('unassignTierConfigRequest', [id]);
        return null;
    }


    public function listTierAccounts(filters: QueryParams): String {
        this.calledFunction('listTierAccounts', [filters]);
        return Json.stringify(this.accountList);
    }


    public function getTierAccount(id: String): String {
        this.calledFunction('getTierAccount', [id]);
        final accounts = this.accountList.filter((account) -> account.id == id);
        if (accounts.length > 0) {
            return Json.stringify(accounts[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    public function listTierConfigs(filters: QueryParams): String {
        this.calledFunction('listTierConfigs', [filters]);
        return Json.stringify(this.configList);
    }


    public function getTierConfig(id: String): String {
        this.calledFunction('getTierConfig', [id]);
        final configs = this.configList.filter((config) -> config.id == id);
        if (configs.length > 0) {
            return Json.stringify(configs[0]);
        } else {
            throw 'Http Error #404';
        }
    }


    private final accountList: Array<Dynamic>;
    private final configList: Array<Dynamic>;
}
