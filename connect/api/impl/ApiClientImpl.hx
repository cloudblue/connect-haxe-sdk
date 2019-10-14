package connect.api.impl;

#if !js
import haxe.io.StringInput;
#end


private typedef Multipart = {
    argname: String,
    filename: String,
    contents: String,
}


class ApiClientImpl implements IApiClient {
    public function new() {}

    public function get(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams): Dynamic {
        return checkResponse(syncRequest('GET', parsePath(resource, id, suffix), params));
    }


    public function getString(resource: String, ?id: String, ?suffix: String,
            ?params: QueryParams): String {
        return checkStringResponse(syncRequest('GET', parsePath(resource, id, suffix), params));
    }


    public function put(resource: String, id: String, data: String): Dynamic {
        return checkResponse(syncRequest('PUT', parsePath(resource, id), data));
    }


    public function post(resource: String, ?id: String, ?suffix: String, ?data: String): Dynamic {
        return checkResponse(syncRequest('POST', parsePath(resource, id, suffix), data));
    }


    public function postFile(resource: String, ?id: String, ?suffix: String,
        argname: String, filename: String, contents: String): Dynamic {
        return checkResponse(syncRequest('POST', parsePath(resource, id, suffix), null, {
            argname: argname,
            filename: filename,
            contents: contents
        }));
    }


    public function delete(resource: String, id: String, ?suffix: String): Dynamic {
        return checkResponse(syncRequest('DELETE', parsePath(resource, id, suffix)));
    }


    /**
        Sends a synchronous request to Connect.

        @param method The REST method to use (i.e. "GET", "POST", "PUT"...).
        @param path A path to append to the apiUrl of this configuration (i.e. "requests").
        @param params Request query params.
        @param data String encoded post data.
        @returns a Response object with the response status and text
    **/
    private function syncRequest(method: String, path: String,
            ?params: QueryParams, ?data: String, ?multipart: Multipart) : Response {
        var fullUrl = Env.getConfig().getApiUrl() + path +
            ((params != null) ? params.toString() : '');
        
        if (Env.getLogger().getLevel() != LoggerLevel.Error) {
            writeRequestCall(method, fullUrl, data);
        }

        #if js
            initXMLHttpRequest();

            var url = Env.getConfig().getApiUrl() + path +
                ((params != null) ? params.toString() : '');

            var xhr = new js.html.XMLHttpRequest();
            xhr.timeout = 300000;
            xhr.open(method.toUpperCase(), url, false);

            xhr.setRequestHeader('Authorization', Env.getConfig().getApiKey());
            xhr.setRequestHeader('Content-Type', 'application/json');

            if (data != null) {
                xhr.send(data);
            } else if (multipart != null) {
                var formData = new js.html.FormData();
                formData.append(multipart.argname, multipart.contents);
                xhr.send(formData);
            } else {
                xhr.send();
            }

            if (xhr.readyState == js.html.XMLHttpRequest.UNSENT) {
                if (Env.getLogger().getLevel() == LoggerLevel.Error) {
                    writeRequestCall(method, fullUrl, data);
                    writeRequestResponse(new Response(status, xhr.responseText));
                }
                throw xhr.responseText != null
                    ? xhr.responseText
                    : 'Error sending ${method} request to "${url}."';
            }

            var response = new Response(xhr.status, xhr.responseText);
        #else
            var status:Null<Int> = null;
            var responseBytes = new haxe.io.BytesOutput();

            var http = new haxe.Http(Env.getConfig().getApiUrl() + path);
            http.cnxTimeout = 300;

            http.setHeader('Authorization', Env.getConfig().getApiKey());
            http.setHeader('Content-Type', 'application/json');

            if (params != null) {
                for (name in params.keys()) {
                    http.setParameter(name, params.get(name));
                }
            }

            if (data != null) {
                http.setPostData(data);
            }

            if (multipart != null) {
                http.fileTransfer(
                    multipart.argname,
                    multipart.filename,
                    new StringInput(multipart.contents),
                    multipart.contents.length,
                    'multipart/form-data'
                );
            }

            http.onStatus = function(status_) { status = status_; };
            http.onError = function(msg) {
                if (Env.getLogger().getLevel() == LoggerLevel.Error) {
                    writeRequestCall(method, fullUrl, data);
                    writeRequestResponse(new Response(status, msg));
                }
                throw msg;
            }
            http.customRequest(false, responseBytes, null, method.toUpperCase());

            while (status == null) {} // Wait for async request
            var response = new Response(status, responseBytes.getBytes().toString());
        #end

        if (Env.getLogger().getLevel() == LoggerLevel.Error && response.status >= 400) {
            writeRequestCall(method, fullUrl, data);
        }
        if (Env.getLogger().getLevel() != LoggerLevel.Error || response.status >= 400) {
            writeRequestResponse(response);
        }
        
        return response;
    }


    private function writeRequestCall(method: String, fullUrl: String, data: String) {
        Env.getLogger()._write('> Http ${method} Request to ${fullUrl}');
        if (data != null) {
            Env.getLogger()._write('> * Data: ${data}');
        }
    }


    private function writeRequestResponse(response: Response) {
        Env.getLogger()._write('> * Status: ${response.status}');
        
        if (Inflection.isJson(response.text)) {
            var beautified = Inflection.beautify(response.text,
                Env.getLogger().getLevel() != LoggerLevel.Debug);
            var responsePrefix = (Env.getLogger().getLevel() == LoggerLevel.Debug)
                ? '> * Response:'
                : '> * Response (compact):';
            if (Env.getLogger().getLevel() == LoggerLevel.Debug || Inflection.isJsonArray(beautified)) {
                Env.getLogger()._write(responsePrefix);
                Env.getLogger()._write('> ```json');
                Env.getLogger()._write('> ${beautified}');
                Env.getLogger()._write('> ```');
            } else {
                Env.getLogger()._write('${responsePrefix} ${beautified}');
            }
        } else {
            Env.getLogger()._write('> * Response: ${response.text}');
        }
        Env.getLogger()._write('');
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
            js.Lib.eval(_JS_CODE);
            _isXMLHttpRequestInit = true;
        }
    }
#end
}
