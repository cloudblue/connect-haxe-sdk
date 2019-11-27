package tests.mocks;

import connect.Blob;
import connect.Dictionary;
import connect.api.Response;
import connect.api.IApiClient;
import connect.api.Query;


class ApiClientMock extends Mock implements IApiClient {
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob) : Response {
        this.calledFunction('syncRequest', [method, url, headers, body, fileArg, fileName, fileContent]);
        return new Response(200, null, null);
    }
    

    public function get(resource: String, ?id: String, ?suffix: String,
            ?params: Query): String {
        return null;
    }


    public function getString(resource: String, ?id: String, ?suffix: String,
            ?params: Query): String {
        return null;
    }


    public function put(resource: String, id: String, body: String): String {
        return null;
    }


    public function post(resource: String, ?id: String, ?suffix: String, ?body: String): String {
        return null;
    }


    public function postFile(resource: String, ?id: String, ?suffix: String,
            argname: String, filename: String, contents: Blob): Dynamic {
        return null;
    }


    public function delete(resource: String, id: String, ?suffix: String): String {
        return null;
    }
}
