package connect.api;

import haxe.io.Bytes;


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
            fileArg: String, fileName: String, fileContent: Bytes) : Response;
    

    /**
        Get a Connect resource if 'id' is specified, or a list of reosurces otherwise.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to get.
        @param suffix Optional path suffix (i.e. "approve").
        @param params Query params.
        @returns An object with the requested resource, or a string if parse == false.
        @throws String if the request fails.
    **/
    public function get(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams): Dynamic;


    /**
        Send a GET request to Connect that returns a string.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to get.
        @param suffix Optional path suffix (i.e. "approve").
        @param params Query params.
        @returns A string with the response.
        @throws String if the request fails.
    **/
    public function getString(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams): String;


    /**
        Put data to one Connect resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to put data on.
        @param body The body to put (normally the modified resource).
        @returns An object with the modified resource.
        @throws String if the request fails.
    **/
    public function put(resource: String, id: String, body: String): Dynamic;


    /**
        Post data to Connect.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param body The body to post.
        @returns An object.
        @throws String if the request fails.
    **/
    public function post(resource: String, ?id: String, ?suffix: String, ?body: String): Dynamic;


    /**
        Post a file to Connect using the Content-Type "multipart/form-data".

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param argname Argument name in the request.
        @param filename Name of the file to send.
        @param contents Contents of the file.
        @returns An object.
        @throws String if the request fails.
    **/
    public function postFile(resource: String, ?id: String, ?suffix: String,
        argname: String, filename: String, contents: String): Dynamic;


    /**
        Delete Connect resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to delete.
        @param suffix Optional path suffix (i.e. "delete").
        @returns An object.
        @throws String if the request fails.
    **/
    public function delete(resource: String, id: String, ?suffix: String): Dynamic;
}
