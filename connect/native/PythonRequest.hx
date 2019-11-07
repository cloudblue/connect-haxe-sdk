package connect.native;

#if python
import connect.api.Response;
import python.Bytes;
import python.Dict;


class PythonRequest {
    public static function request(method: String, url: String, headers:Dict<String, Dynamic>,
            body: String, fileArg: String, fileName: String, fileContent: Bytes,
            timeout: Float): Response {
        python.Syntax.code("import requests");
        final resp = (fileContent == null)
            ? python.Syntax.code(
                "requests.request({0}, {1}, headers={2}, data={3}.encode() if {3} else None, timeout={4})",
                method, url, headers, body, timeout)
            : python.Syntax.code(
                "requests.request({0}, {1}, headers={2}, files={{3}: ({4}: {5})}, timeout={6})",
                method, url, headers, fileArg, fileName, fileContent, timeout);
        return new Response(resp.status_code, resp.text);
    }
}
#end
