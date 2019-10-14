package tests.unit;

import connect.Dictionary;
import connect.Env;
import connect.models.Asset;
import connect.models.Model;
import tests.mocks.Mock;


class AssetTest extends haxe.unit.TestCase {
    override public function setup() {
        Env._reset(new Dictionary()
            .setString('IFulfillmentApi', 'tests.mocks.FulfillmentApiMock'));
    }


    public function testList() {
        // Check subject
        var assets = Asset.list(null);
        assertEquals(2, assets.length());
        assertEquals('AS-392-283-000-0', assets.get(0).id);
        assertEquals('AS-392-283-001-0', assets.get(1).id);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('listRequests'));
        assertEquals(
            [null].toString(),
            apiMock.callArgs('listAssets', 0).toString());
    }


    public function testGetOk() {
        // Check subject
        var asset = Asset.get('AS-392-283-000-0');
        assertTrue(asset != null);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAsset'));
        assertEquals(
            ['AS-392-283-000-0'].toString(),
            apiMock.callArgs('getAsset', 0).toString());
    }


    public function testGetKo() {
        // Check subject
        var asset = Asset.get('AS-XXX-XXX-XXX-X');
        assertTrue(asset == null);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAsset'));
        assertEquals(
            ['AS-XXX-XXX-XXX-X'].toString(),
            apiMock.callArgs('getAsset', 0).toString());
    }


    public function testGetRequests() {
        // Check subject
        var asset = Asset.get('AS-392-283-000-0');
        var requests = asset.getRequests();
        assertEquals(1, requests.length());
        assertEquals('PR-5852-1608-0000', requests.get(0).id);

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAssetRequests'));
        assertEquals(
            ['AS-392-283-000-0'].toString(),
            apiMock.callArgs('getAssetRequests', 0).toString());
    }


    public function testGetRequestsEmpty() {
        // Check subject
        var asset = Model.parse(Asset, {id: 'AS-XXX-XXX-XXX-X'});
        var requests = asset.getRequests();
        assertEquals(0, requests.length());

        // Check mocks
        var apiMock = cast(Env.getFulfillmentApi(), Mock);
        assertEquals(1, apiMock.callCount('getAssetRequests'));
        assertEquals(
            ['AS-XXX-XXX-XXX-X'].toString(),
            apiMock.callArgs('getAssetRequests', 0).toString());
    }


    public function testGetNewItems() {
        var asset = Asset.get('AS-392-283-000-0');
        var newItems = asset.getNewItems();
        assertEquals(2, newItems.length());
        assertEquals('TEAM_ST3L2T1Y', newItems.get(0).id);
        assertEquals('100', newItems.get(0).quantity);
        assertEquals('0', newItems.get(0).oldQuantity);
        assertEquals('TEAM_ST3L2TAC1M', newItems.get(1).id);
        assertEquals('200', newItems.get(1).quantity);
        assertEquals('0', newItems.get(1).oldQuantity);
    }


    public function testGetChangedItems() {
        var asset = Asset.get('AS-392-283-000-0');
        var changedItems = asset.getChangedItems();
        assertEquals(2, changedItems.length());
        assertEquals('UPSIZE_TEST', changedItems.get(0).id);
        assertEquals('201', changedItems.get(0).quantity);
        assertEquals('200', changedItems.get(0).oldQuantity);
        assertEquals('DOWNSIZE_TEST', changedItems.get(1).id);
        assertEquals('199', changedItems.get(1).quantity);
        assertEquals('200', changedItems.get(1).oldQuantity);
    }


    public function testGetRemovedItems() {
        var asset = Asset.get('AS-392-283-000-0');
        var removedItems = asset.getRemovedItems();
        assertEquals(1, removedItems.length());
        assertEquals('DELETE_TEST', removedItems.get(0).id);
        assertEquals('0', removedItems.get(0).quantity);
        assertEquals('200', removedItems.get(0).oldQuantity);
    }


    public function testGetParamByIdOk() {
        var asset = Asset.get('AS-392-283-000-0');
        var param = asset.getParamById('activationCode');
        assertTrue(param != null);
        assertEquals('activationCode', param.id);
    }


    public function testGetParamByIdKo() {
        var asset = Asset.get('AS-392-283-000-0');
        var param = asset.getParamById('invalid-id');
        assertTrue(param == null);
    }


    public function testGetItemByIdOk() {
        var asset = Asset.get('AS-392-283-000-0');
        var item = asset.getItemById('TEAM_ST3L2T1Y');
        assertTrue(item != null);
        assertEquals('TEAM_ST3L2T1Y', item.id);
    }


    public function testGetItemByIdKo() {
        var asset = Asset.get('AS-392-283-000-0');
        var item = asset.getItemById('invalid-id');
        assertTrue(item == null);
    }


    public function testGetItemByMpnOk() {
        var asset = Asset.get('AS-392-283-000-0');
        var item = asset.getItemByMpn('TEAM-ST3L2T1Y');
        assertTrue(item != null);
        assertEquals('TEAM-ST3L2T1Y', item.mpn);
    }


    public function testGetItemByMpnKo() {
        var asset = Asset.get('AS-392-283-000-0');
        var item = asset.getItemByMpn('invalid-mpn');
        assertTrue(item == null);
    }


    public function testGetItemByGlobalIdOk() {
        var asset = Asset.get('AS-392-283-000-0');
        var item = asset.getItemByGlobalId('XXX');
        assertTrue(item != null);
        assertEquals('XXX', item.globalId);
    }


    public function testGetItemByGlobalIdKo() {
        var asset = Asset.get('AS-392-283-000-0');
        var item = asset.getItemByGlobalId('invalid-id');
        assertTrue(item == null);
    }
}
