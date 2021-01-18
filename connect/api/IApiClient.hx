/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.util.Blob;
import connect.util.Dictionary;
import connect.logger.Logger;

interface IApiClient {
    /**
        Sends a synchronous request.

        @param method The REST method to use (i.e. "GET", "POST", "PUT", "DELETE").
        @param url The full URL to send the request to, including query params.
        @param headers A `Dictionary` with the headers to use.
        @param body String encoded post body or `null`.
        @param fileArg Argument name of file to send in multipart requests, or `null`.
        @param fileName File name of file to send in multipart requests, or `null`.
        @param fileContent File content of file to send in multipart requests, or `null`.
        @param certificate Certificate to send in the request, or `null`.
        @returns A `Response` object.
    **/
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String, ?logLevel: Null<Int> = null) : Response;

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
        fileArg: String, fileName: String, fileContent: Blob, certificate: String, logger:Logger, ?logLevel: Null<Int> = null) : Response;
}
