/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.Env;
import connect.logger.Logger;
import connect.util.Blob;
import connect.util.Dictionary;
import connect.models.IdModel;

@:dox(hide)
class ConnectHelper {
    private static var logger = Env.getLogger();

    /* Sets the logger that will be usef in all subsequent calls */
    public static function setLogger(logger:Logger):Void {
        ConnectHelper.logger = logger;
    }

    /**
        Get a Connect resource if 'id' is specified, or a list of reosurces otherwise.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to get.
        @param suffix Optional path suffix (i.e. "approve").
        @param params Query params.
        @param rqlParams Indicates whether params should be sent as SQL (query params otherwise).
        @param logLevel Log level to use.
        @returns A string with the response.
        @throws String if the request fails.
    **/
    public static function get(resource:String, ?id:String, ?suffix:String,
            ?params:Query, rqlParams:Bool = false, ?logLevel:Int): String {
        return checkResponse(connectSyncRequest('GET', parsePath(resource, id, suffix),
            getHeaders(), params, rqlParams, null, null, null, null, logLevel));
    }

    /**
        Put data to one Connect resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to put data on.
        @param suffix Optional path suffix (i.e. "approve").
        @param body The body to put (normally the modified resource).
        @param logLevel Log level to use.
        @returns A string with the response.
        @throws String if the request fails.
    **/
    public static function put(resource:String, id:String, suffix:String,
            body:String, ?logLevel:Int):String {
        return checkResponse(connectSyncRequest('PUT', parsePath(resource, id, suffix),
            getHeaders(), null, false, body, null, null, null, logLevel));
    }

    /**
        Post data to Connect.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param body The body to post.
        @param logLevel Log level to use.
        @returns An object.
        @throws String if the request fails.
    **/
    public static function post(resource:String, ?id:String, ?suffix:String,
            ?body:String, ?logLevel:Int):String {
        return checkResponse(connectSyncRequest('POST', parsePath(resource, id, suffix),
            getHeaders(), null, false, body, null, null, null, logLevel));
    }

    /**
        Post a file to Connect using the Content-Type "multipart/form-data".

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Optional id of the resource to post data to.
        @param suffix Optional path suffix (i.e. "approve").
        @param argname Argument name in the request.
        @param filename Name of the file to send.
        @param contents Contents of the file.
        @param logLevel Log level to use.
        @returns An object.
        @throws String if the request fails.
    **/
    public static function postFile(resource:String, ?id:String, ?suffix:String,
            fileArg:String, fileName:String, fileContents:Blob, ?logLevel:Int):Dynamic {
        return checkResponse(connectSyncRequest('POST', parsePath(resource, id, suffix),
            getHeaders(false), null, false, null, fileArg, fileName, fileContents, logLevel));
    }

    /**
        Delete Connect resource.

        @param resource Resource path (e.g. "requests" for the Fulfillment API).
        @param id Id of the resource to delete.
        @param suffix Optional path suffix (i.e. "delete").
        @param logLevel Log level to use.
        @returns A string with the response.
        @throws String if the request fails.
    **/
    public static function delete(resource:String, id:String, ?suffix:String, ?logLevel:Int):String {
        return checkResponse(connectSyncRequest('DELETE', parsePath(resource, id, suffix), getHeaders(),
            null, false, null, null, null, null, logLevel));
    }

    private static function connectSyncRequest(method:String, path:String, headers:Dictionary,
            params:Null<Query>, rqlParams:Bool, data:Null<String>,
            fileArg:Null<String>, fileName:Null<String>, fileContent:Null<Blob>,
            logLevel:Null<Int>):Response {
        final paramsStr = (params != null)
            ? (rqlParams ? params.toString() : params.toPlain())
            : '';
        final url = Env.getConfig().getApiUrl() + path + paramsStr;
        return Env.getApiClient().syncRequestWithLogger(method, url, headers, data,
            fileArg, fileName, fileContent, null, logger, logLevel);
    }

    private static function parsePath(resource:String, ?id:String, ?suffix:String):String {
        return resource
            + (id != null && id != '' ? '/' + id : '')
            + (suffix != null && suffix != '' ? '/' + suffix : '');
    }

    private static function getHeaders(addContentType:Bool = true):Dictionary {
        final headers = new Dictionary();
        headers.set('Authorization', Env.getConfig().getApiKey());
        if (addContentType) {
            headers.set('Content-Type', 'application/json');
        } else {
            headers.set('Accept', 'application/json');
        }
        return headers;
    }

    private static function checkResponse(response:Response):String {
        if (response.status < 400) {
            return response.text;
        } else {
            throw response.text;
        }
    }
}
