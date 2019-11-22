package connect.api;


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
        @returns A `Response` object.
    **/
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob) : Response;
}
