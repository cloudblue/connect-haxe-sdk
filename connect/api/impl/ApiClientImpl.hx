package connect.api.impl;

import haxe.Constraints.Function;
import haxe.io.Bytes;
#if python
import haxe.io.UInt8Array;
#end
#if !js
import haxe.io.BytesInput;
#end


class ApiClientImpl extends Base implements IApiClient {
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Bytes) : Response {
        // Write call info
        writeRequestCall(Env.getLogger().info, method, url, headers, body);

        #if js
            initXMLHttpRequest();

            final xhr = new js.html.XMLHttpRequest();
            xhr.timeout = 300000;
            xhr.open(method.toUpperCase(), url, false);

            if (headers != null) {
                for (key in headers.keys()) {
                    xhr.setRequestHeader(key, headers.get(key));
                }
            }

            if (body != null) {
                xhr.send(body);
            } else if (fileArg != null && fileName != null && fileContent != null) {
                final formData = new js.html.FormData();
                final blob = new js.html.Blob([fileContent.getData()]);
                formData.append(fileArg, blob, fileName);
                xhr.send(formData);
            } else {
                xhr.send();
            }

            if (xhr.readyState == js.html.XMLHttpRequest.UNSENT) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                    writeRequestCall(Env.getLogger().error, method, url, headers, body);
                }
                Env.getLogger().error('> * Exception: ${xhr.responseText}');
                Env.getLogger().error('');
                throw xhr.responseText != null
                    ? xhr.responseText
                    : 'Error sending ${method} request to "${url}."';
            }

            final response = new Response(xhr.status, xhr.responseText);
        #elseif use_tink
            final methods = [
                'GET' => tink.http.Method.GET,
                'PUT' => tink.http.Method.PUT,
                'POST' => tink.http.Method.POST
            ];

            var tinkMethod: tink.http.Method = null;
            try {
                tinkMethod = methods.get(method.toUpperCase());
            } catch (e: Dynamic) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                    writeRequestCall(Env.getLogger().error, method, url, headers, body);
                }
                Env.getLogger().error('');
                throw 'Invalid request method ${method}';
            }

            var response: Response = null;

            final parsedHeaders = new Array<tink.http.Header.HeaderField>();
            if (headers != null) {
                for (key in headers.keys()) {
                    parsedHeaders.push(new tink.http.Header.HeaderField(key, headers.get(key)));
                }
            }

            final options = new Dictionary();
            options.set('method', tinkMethod);
            if (parsedHeaders.keys().length > 0) {
                options.set('headers', parsedHeaders);
            }
            if (body != null) {
                options.set('body', body);
            }

            tink.http.Client.fetch(url, options.toObject()).all().handle(function(o) {
                switch (o) {
                    case Success(res):
                        response = new Response(res.header.statusCode, res.body.toString());
                    case Failure(res):
                        if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                            writeRequestCall(Env.getLogger().error, method, url, headers, body);
                        }
                        Env.getLogger().error('> * Exception: ${res}');
                        Env.getLogger().error('');
                        throw res.toString();
                }
            });
            
            // Wait for async request
            while (response == null) {}
        #elseif python
            final parsedHeaders = new python.Dict<String, Dynamic>();
            if (headers != null) {
                for (key in headers.keys()) {
                    parsedHeaders.set(key, headers.get(key));
                }
            }

            var response: Response = null;
            try {
                final contentsArr = [for (b in UInt8Array.fromBytes(fileContent)) b];
                final pythonBytes = (contentsArr.length > 0)
                    ? new python.Bytes(contentsArr)
                    : null;
                response = connect.native.PythonRequest.request(
                    method, url, parsedHeaders, body, fileArg, fileName, pythonBytes, 300);
            } catch (ex: Dynamic) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                    writeRequestCall(Env.getLogger().error, method, url, headers, body);
                }
                Env.getLogger().error('> * Exception: ${ex}');
                Env.getLogger().error('');
                throw ex;
            }
        #else
            var status:Null<Int> = null;
            final responseBytes = new haxe.io.BytesOutput();

            final http = new haxe.Http(url);
            http.cnxTimeout = 300;

            if (headers != null) {
                for (key in headers.keys()) {
                    http.setHeader(key, headers.get(key));
                }
            }

            if (body != null) {
                http.setPostData(body);
            }

            if (fileArg != null && fileName != null && fileContent != null) {
                http.fileTransfer(
                    fileArg,
                    fileName,
                    new BytesInput(fileContent),
                    fileContent.length,
                    'multipart/form-data'
                );
            }

            http.onStatus = function(status_) { status = status_; };
            http.onError = function(msg) {
                if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR) {
                    writeRequestCall(Env.getLogger().error, method, url, headers, body);
                }
                Env.getLogger().error(
                    '> * Exception (${status}): ${responseBytes.getBytes().toString()}');
                Env.getLogger().error('');
                throw msg;
            }
            http.customRequest(false, responseBytes, null, method.toUpperCase());

            while (status == null) {} // Wait for async request
            final response = new Response(status, responseBytes.getBytes().toString());
        #end

        // If error response, write call to error log level
        if (Env.getLogger().getLevel() == Logger.LEVEL_ERROR && response.status >= 400) {
            writeRequestCall(Env.getLogger().error, method, url, headers, body);
        }

        // Write response to error or info level, depending on status
        writeRequestResponse(
            (response.status >= 400) ? Env.getLogger().error : Env.getLogger().info,
            response);
        
        return response;
    }


    public function get(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams): Dynamic {
        return checkResponse(connectSyncRequest('GET', parsePath(resource, id, suffix),
            getHeaders(), params));
    }


    public function getString(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams): String {
        return checkStringResponse(connectSyncRequest('GET', parsePath(resource, id, suffix),
            getHeaders(), params));
    }


    public function put(resource: String, id: String, body: String): Dynamic {
        return checkResponse(connectSyncRequest('PUT', parsePath(resource, id),
            getHeaders(), body));
    }


    public function post(resource: String, ?id: String, ?suffix: String, ?body: String): Dynamic {
        return checkResponse(connectSyncRequest('POST', parsePath(resource, id, suffix),
            getHeaders(), body));
    }


    public function postFile(resource: String, ?id: String, ?suffix: String,
        fileArg: String, fileName: String, fileContents: Bytes): Dynamic {
        return checkResponse(connectSyncRequest('POST', parsePath(resource, id, suffix),
            getHeaders('multipart/form-data'), null, fileArg, fileName, fileContents));
    }


    public function delete(resource: String, id: String, ?suffix: String): Dynamic {
        return checkResponse(connectSyncRequest('DELETE', parsePath(resource, id, suffix), getHeaders()));
    }


    public function new() {}


    private function connectSyncRequest(method: String, path: String, headers: Dictionary,
            ?params: QueryParams, ?data: String,
            ?fileArg: String, ?fileName: String, ?fileContent: Bytes) : Response {
        final url = Env.getConfig().getApiUrl() + path + ((params != null) ? params.toString() : '');
        return this.syncRequest(method, url, headers, data, fileArg, fileName, fileContent);
    }


    private function getHeaders(contentType: String = 'application/json'): Dictionary {
        final headers = new Dictionary();
        headers.set('Authorization', Env.getConfig().getApiKey());
        headers.set('Content-Type', contentType);
        return headers;
    }


    private function writeRequestCall(loggerFunc: Function, method: String, url: String,
            headers: Dictionary, body: String) {
        var maskedHeaders = headers;
        if (loggerFunc != Env.getLogger().debug && headers != null) {
            maskedHeaders = new Dictionary();
            for (key in headers.keys()) {
                if (key == 'Authorization') {
                    var auth = Std.string(headers.get('Authorization'));
                    if (StringTools.startsWith(auth, 'ApiKey ')) {
                        final parts = auth.split(':');
                        if (parts.length > 1) {
                            final join = parts.slice(1).join(':');
                            auth = parts[0] + ':'
                                + StringTools.lpad(join.substr(join.length - 4), '*', join.length);
                        } else {
                            auth = 'ApiKey '
                                + StringTools.lpad(auth.substr(auth.length - 4), '*', auth.length - 7);
                        }
                    } else {
                        auth = StringTools.lpad(auth.substr(auth.length - 4), '*', auth.length);
                    }
                    maskedHeaders.set('Authorization', auth);
                } else {
                    maskedHeaders.set(key, headers.get(key));
                }
            }
        }

        Reflect.callMethod(Env.getLogger(), loggerFunc,
            ['> Http ${method.toUpperCase()} Request to ${url}']);
        if (maskedHeaders != null) {
            Reflect.callMethod(Env.getLogger(), loggerFunc, ['> * Headers:']);
            Reflect.callMethod(Env.getLogger(), loggerFunc, ['> | Name | Value |']);
            Reflect.callMethod(Env.getLogger(), loggerFunc, ['> | ---- | ----- |']);
            for (key in maskedHeaders.keys()) {
                Reflect.callMethod(Env.getLogger(), loggerFunc,
                    ['> | ${key} | ${maskedHeaders.get(key)} |']);
            }
        }
        if (body != null) {
            if (Inflection.isJson(body)) {
                final compact = Env.getLogger().getLevel() != Logger.LEVEL_DEBUG;
                final prefix = compact ? '> * Body (compact):' : '> * Body:';
                final formatted = getFormattedData(body, prefix, compact);
                Reflect.callMethod(Env.getLogger(), loggerFunc, [formatted]);
            } else {
                body = StringTools.lpad(body.substr(body.length - 4), '*', body.length);
                Reflect.callMethod(Env.getLogger(), loggerFunc, ['> * Body: ${body}']);
            }
        }
    }


    private function writeRequestResponse(loggerFunc: Function, response: Response) {
        Reflect.callMethod(Env.getLogger(), loggerFunc, ['> * Status: ${response.status}']);
        if (Inflection.isJson(response.text)) {
            final compact = Env.getLogger().getLevel() != Logger.LEVEL_DEBUG;
            final prefix = compact ? '> * Response (compact):' : '> * Response:';
            final formatted = getFormattedData(response.text, prefix, compact);
            Reflect.callMethod(Env.getLogger(), loggerFunc, [formatted]);
        } else {
            var text = response.text;
            text = StringTools.lpad(text.substr(text.length - 4), '*', text.length);
            Reflect.callMethod(Env.getLogger(), loggerFunc, ['> * Response: ${text}']);
        }
        Reflect.callMethod(Env.getLogger(), loggerFunc, ['']);
    }


    private function getFormattedData(data: String, prefix: String, compact: Bool): String {
        final beautified = Inflection.beautify(data, compact);
        if (!compact || Inflection.isJsonArray(beautified)) {
            return prefix + '\r\n'
                + '> ```json' + '\r\n'
                + '> ${beautified}' + '\r\n'
                + '> ```';
        } else {
            return '${prefix} ${beautified}';
        }
    }


    private function parsePath(resource: String, ?id: String, ?suffix: String): String {
        return resource
            + (id != null ? "/" + id : "")
            + (suffix != null ? "/" + suffix : "");
    }


    private function checkResponse(response: Response): Dynamic {
        if (response.status < 400) {
            return haxe.Json.parse(response.text);
        } else {
            throw response.text;
        }
    }


    private function checkStringResponse(response: Response): String {
        if (response.status < 400) {
            return response.text;
        } else {
            throw response.text;
        }
    }


#if js
    private static inline var _JS_CODE = 'var Url=require("url"),spawn=require("child_process").spawn,fs=require("fs");global.XMLHttpRequest = function(){"use strict";var S,w,N=this,v=require("http"),g=require("https"),T={},s=!1,C={"User-Agent":"node-XMLHttpRequest",Accept:"*/*"},D={},O={},r=["accept-charset","accept-encoding","access-control-request-headers","access-control-request-method","connection","content-length","content-transfer-encoding","cookie","cookie2","date","expect","host","keep-alive","origin","referer","te","trailer","transfer-encoding","upgrade","via"],o=["TRACE","TRACK","CONNECT"],R=!1,q=!1,n={};this.UNSENT=0,this.OPENED=1,this.HEADERS_RECEIVED=2,this.LOADING=3,this.DONE=4,this.readyState=this.UNSENT,this.onreadystatechange=null,this.responseText="",this.responseXML="",this.status=null,this.statusText=null,this.withCredentials=!1;this.open=function(e,t,s,r,n){if(this.abort(),q=!1,!function(e){return e&&-1===o.indexOf(e)}(e))throw new Error("SecurityError: Request method not allowed");T={method:e,url:t.toString(),async:"boolean"!=typeof s||s,user:r||null,password:n||null},L(this.OPENED)},this.setDisableHeaderCheck=function(e){s=e},this.setRequestHeader=function(e,t){if(this.readyState!==this.OPENED)throw new Error("INVALID_STATE_ERR: setRequestHeader can only be called when state is OPEN");if(function(e){return s||e&&-1===r.indexOf(e.toLowerCase())}(e)){if(R)throw new Error("INVALID_STATE_ERR: send flag is true");e=O[e.toLowerCase()]||e,O[e.toLowerCase()]=e,D[e]=D[e]?D[e]+", "+t:t}else console.warn(\'Refused to set unsafe header \\"\'+e+\'\\"\')},this.getResponseHeader=function(e){return"string"==typeof e&&this.readyState>this.OPENED&&w&&w.headers&&w.headers[e.toLowerCase()]&&!q?w.headers[e.toLowerCase()]:null},this.getAllResponseHeaders=function(){if(this.readyState<this.HEADERS_RECEIVED||q)return"";var e="";for(var t in w.headers)"set-cookie"!==t&&"set-cookie2"!==t&&(e+=t+": "+w.headers[t]+"\\r\\n");return e.substr(0,e.length-2)},this.getRequestHeader=function(e){return"string"==typeof e&&O[e.toLowerCase()]?D[O[e.toLowerCase()]]:""},this.send=function(e){if(this.readyState!==this.OPENED)throw new Error("INVALID_STATE_ERR: connection must be opened before send() is called");if(R)throw new Error("INVALID_STATE_ERR: send has already been called");var n,t=!1,s=!1,r=Url.parse(T.url);switch(r.protocol){case"https:":t=!0;case"http:":n=r.hostname;break;case"file:":s=!0;break;case void 0:case null:case"":n="localhost";break;default:throw new Error("Protocol not supported.")}if(s){if("GET"!==T.method)throw new Error("XMLHttpRequest: Only GET method is supported");if(T.async)fs.readFile(r.pathname,"utf8",function(e,t){e?N.handleError(e):(N.status=200,N.responseText=t,L(N.DONE))});else try{this.responseText=fs.readFileSync(r.pathname,"utf8"),this.status=200,L(N.DONE)}catch(e){this.handleError(e)}}else{var o=r.port||(t?443:80),a=r.pathname+(r.search?r.search:"");for(var i in C)O[i.toLowerCase()]||(D[i]=C[i]);if(D.Host=n,"["===r.host[0]&&(D.Host="["+D.Host+"]"),t&&443===o||80===o||(D.Host+=":"+r.port),T.user){void 0===T.password&&(T.password="");var h=new Buffer(T.user+":"+T.password);D.Authorization="Basic "+h.toString("base64")}"GET"===T.method||"HEAD"===T.method?e=null:e?(D["Content-Length"]=Buffer.isBuffer(e)?e.length:Buffer.byteLength(e),this.getRequestHeader("Content-Type")||(D["Content-Type"]="text/plain;charset=UTF-8")):"POST"===T.method&&(D["Content-Length"]=0);var d={host:n,port:o,path:a,method:T.method,headers:D,agent:!1,withCredentials:N.withCredentials};if(q=!1,T.async){var u=t?g.request:v.request;R=!0,N.dispatchEvent("readystatechange");var c=function(e){N.handleError(e)};S=u(d,function e(t){if(301!==(w=t).statusCode&&302!==w.statusCode&&303!==w.statusCode&&307!==w.statusCode)w.setEncoding("utf8"),L(N.HEADERS_RECEIVED),N.status=w.statusCode,w.on("data",function(e){e&&(N.responseText+=e),R&&L(N.LOADING)}),w.on("end",function(){R&&(L(N.DONE),R=!1)}),w.on("error",function(e){N.handleError(e)});else{T.url=w.headers.location;var s=Url.parse(T.url);n=s.hostname;var r={hostname:s.hostname,port:s.port,path:s.path,method:303===w.statusCode?"GET":T.method,headers:D,withCredentials:N.withCredentials};(S=u(r,e).on("error",c)).end()}}).on("error",c),e&&S.write(e),S.end(),N.dispatchEvent("loadstart")}else{var f=".node-xmlhttprequest-content-"+process.pid,l=".node-xmlhttprequest-sync-"+process.pid;fs.writeFileSync(l,"","utf8");for(var p="var http = require(\'http\'), https = require(\'https\'), fs = require(\'fs\');var doRequest = http"+(t?"s":"")+".request;var options = "+JSON.stringify(d)+";var responseText = \'\';var req = doRequest(options, function(response) {response.setEncoding(\'utf8\');response.on(\'data\', function(chunk) {  responseText += chunk;});response.on(\'end\', function() {fs.writeFileSync(\'"+f+"\', JSON.stringify({err: null, data: {statusCode: response.statusCode, headers: response.headers, text: responseText}}), \'utf8\');fs.unlinkSync(\'"+l+"\');});response.on(\'error\', function(error) {fs.writeFileSync(\'"+f+"\', JSON.stringify({err: error}), \'utf8\');fs.unlinkSync(\'"+l+"\');});}).on(\'error\', function(error) {fs.writeFileSync(\'"+f+"\', JSON.stringify({err: error}), \'utf8\');fs.unlinkSync(\'"+l+"\');});"+(e?"req.write(\'"+JSON.stringify(e).slice(1,-1).replace(/\'/g,"\\\'")+"\');":"")+"req.end();",E=spawn(process.argv[0],["-e",p]);fs.existsSync(l););var y=JSON.parse(fs.readFileSync(f,"utf8"));E.stdin.end(),fs.unlinkSync(f),y.err?N.handleError(y.err):(w=y.data,N.status=y.data.statusCode,N.responseText=y.data.text,L(N.DONE))}}},this.handleError=function(e){this.status=0,this.statusText=e,this.responseText=e.stack,q=!0,L(this.DONE),this.dispatchEvent("error")},this.abort=function(){S&&(S.abort(),S=null),D=C,this.status=0,this.responseText="",this.responseXML="",q=!0,this.readyState===this.UNSENT||this.readyState===this.OPENED&&!R||this.readyState===this.DONE||(R=!1,L(this.DONE)),this.readyState=this.UNSENT,this.dispatchEvent("abort")},this.addEventListener=function(e,t){e in n||(n[e]=[]),n[e].push(t)},this.removeEventListener=function(e,t){e in n&&(n[e]=n[e].filter(function(e){return e!==t}))},this.dispatchEvent=function(e){if("function"==typeof N["on"+e]&&N["on"+e](),e in n)for(var t=0,s=n[e].length;t<s;t++)n[e][t].call(N)};var L=function(e){e!=N.LOADING&&N.readyState===e||(N.readyState=e,(T.async||N.readyState<N.OPENED||N.readyState===N.DONE)&&N.dispatchEvent("readystatechange"),N.readyState!==N.DONE||q||(N.dispatchEvent("load"),N.dispatchEvent("loadend")))}};';
    private static var _isXMLHttpRequestInit: Bool = false;

    private static function initXMLHttpRequest(): Void {
        if (!_isXMLHttpRequestInit) {
            js.Syntax.code(_JS_CODE);
            _isXMLHttpRequestInit = true;
        }
    }
#end
}
