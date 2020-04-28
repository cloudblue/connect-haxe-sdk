/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package test.mocks;

import connect.api.Response;
import connect.api.IApiClient;
import connect.api.Query;
import connect.util.Blob;
import connect.util.Dictionary;


class ApiClientMock extends Mock implements IApiClient {
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob) : Response {
        this.calledFunction('syncRequest', [method, url, headers, body, fileArg, fileName, fileContent]);
        return new Response(200, null, null);
    }
}
