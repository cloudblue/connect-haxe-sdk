package connect.native;

#if python
import connect.api.Response;
import python.Dict;


class PythonRequest {
    public static function request(method: String, url: String, headers:Dict<String, Dynamic>,
            data: String, timeout: Float): Response {
        python.Syntax.code("import requests");
        var resp = python.Syntax.code(
            "requests.request({0}, {1}, headers={2}, data={3}.encode() if {3} else None, timeout={4})",
            method, url, headers, data, timeout);
        return new Response(resp.status_code, resp.text);
    }
}
#end
