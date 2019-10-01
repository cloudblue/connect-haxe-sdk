package connect.api;


interface IApiClient {
    /**
        Get a resource if 'id' is specified, or a list of reosurces otherwise.

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
        Get a string

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
        Put data to one resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to put data on.
        @param data The data object to put (normally the modified resource).
        @returns An object with the modified resource.
        @throws String if the request fails.
    **/
    public function put(resource: String, id: String, data: String): Dynamic;


    /**
        Post data.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param data The data object to post.
        @returns An object.
        @throws String if the request fails.
    **/
    public function post(resource: String, ?id: String, ?suffix: String, ?data: String): Dynamic;


    /**
        Post a file using the Content-Type "multipart/form-data".

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
        Delete resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to delete.
        @param suffix Optional path suffix (i.e. "delete").
        @returns An object.
        @throws String if the request fails.
    **/
    public function delete(resource: String, id: String, ?suffix: String): Dynamic;
}