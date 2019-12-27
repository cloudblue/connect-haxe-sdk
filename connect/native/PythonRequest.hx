/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.native;

#if python
import connect.api.Response;
import haxe.io.Bytes;
import python.Syntax;


class PythonRequest {
    public static function request(method: String, url: String, headers: Dictionary,
            body: String, fileArg: String, fileName: String, fileContent: Blob,
            timeout: Float): Response {
        Syntax.code("import requests");

        final parsedHeaders = new python.Dict<String, Dynamic>();
        if (headers != null) {
            for (key in headers.keys()) {
                parsedHeaders.set(key, headers.get(key));
            }
        }

        final pythonBytes = (fileArg != null && fileName != null && fileContent != null)
            ? new python.Bytes(fileContent._toArray())
            : null;

        final resp = (fileContent == null)
            ? Syntax.code(
                "requests.request({0}, {1}, headers={2}, data={3}.encode() if {3} else None, timeout={4})",
                method, url, parsedHeaders, body, timeout)
            : Syntax.code(
                "requests.request({0}, {1}, headers={2}, files={ {3}: ({4}, {5}) }, timeout={6})",
                method, url, parsedHeaders, fileArg, fileName, pythonBytes, timeout);
        final contentBytes = Bytes.ofData(resp.content);
        return new Response(resp.status_code, resp.text, Blob._fromBytes(contentBytes));
    }
}
#end
