/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api.impl;

import connect.logger.ILoggerFormatter;
import connect.logger.Logger;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.Dictionary;
import connect.util.Util;
#if !js
import haxe.io.BytesInput;
#end


class ApiClientImpl extends Base implements IApiClient {
    public function syncRequest(method: String, url: String, headers: Dictionary, body: String,
        fileArg: String, fileName: String, fileContent: Blob, certificate:String) : Response {
            return this.syncRequestWithLogger(method, url, headers, body,
                fileArg, fileName, fileContent, certificate,Env.getLogger());
        }

    public function syncRequestWithLogger(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate:String,logger:Logger) : Response {
    #if cs
        final response = syncRequestCs(method, url, headers, body, fileArg, fileName, fileContent, certificate);
    #elseif js
        final response = syncRequestJs(method, url, headers, body, fileArg, fileName, fileContent, certificate);
    #elseif use_tink
        final response = syncRequestTink(method, url, headers, body, fileArg, fileName, fileContent, certificate);
    #elseif python
        final response = syncRequestPython(method, url, headers, body, fileArg, fileName, fileContent, certificate);
    #else
        final response = syncRequestStd(method, url, headers, body, fileArg, fileName, fileContent, certificate);
    #end

        final level = (response.status >= 400 || response.status == -1)
            ? Logger.LEVEL_ERROR
            : Logger.LEVEL_INFO;
        logRequest(level, method, url, headers, body, response, logger);

        if (response.status != -1) {
            return response;
        } else {
            throw response.text;
        }
    }


    public function new() {}


#if cs
    private static function syncRequestCs(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        try {
            final boundary = '---------------------------${StringTools.hex(Std.int(Date.now().getTime() * 1000))}';

            final request = cast(connect.native.CsHttpWebRequest.Create(url), connect.native.CsHttpWebRequest);
            request.Method = method.toUpperCase();

            if (headers != null) {
                final csHeaders = new connect.native.CsWebHeaderCollection();
                for (key in headers.keys()) {
                    final value = headers.getString(key);
                    if (key == 'Content-Type') {
                        if (value == 'multipart/form-data') {
                            request.ContentType = 'multipart/form-data; boundary=' + boundary;
                        } else {
                            request.ContentType = value;
                        }
                    } else {
                        csHeaders.Add(key, value);
                    }
                }
                request.Headers = csHeaders;
            }

            if (body != null) {
                final encoding = cs.system.text.Encoding.UTF8;
                final data = encoding.GetBytes(body);
                final stream = request.GetRequestStream();
                request.ContentLength = data.Length;
                stream.Write(data, 0, data.Length);
                stream.Dispose();
            } else if (fileArg != null && fileName != null && fileContent != null) {
                final formItem = 'Content-Disposition: form-data; filename="$fileName";\r\nContent-Type: application/octet-stream\r\n\r\n';
                final encoding = cs.system.text.Encoding.UTF8;
                final boundaryBytes = encoding.GetBytes('\r\n--$boundary\r\n');
                final formBytes = encoding.GetBytes(formItem);
                final fileBytes = new cs.NativeArray<cs.types.UInt8>(4096);
                final stream = request.GetRequestStream();
                request.ServicePoint.Expect100Continue = false;
                stream.Write(boundaryBytes, 0, boundaryBytes.Length);
                stream.Write(formBytes, 0, formBytes.Length);
                var current = 0;
                while (current < fileContent.length()) {
                    final amount = Std.int(Math.min(4096, fileContent.length() - current));
                    for (offset in 0...amount) {
                        fileBytes.SetValue(fileContent._getBytes().get(current + offset), offset);
                    }
                    stream.Write(fileBytes, 0, amount);
                    current += amount;
                }
                stream.Dispose();
            }

            final response = cast(request.GetResponse(), connect.native.CsHttpWebResponse);
            final reader = new cs.system.io.StreamReader(response.GetResponseStream());
            return new Response(cast(response.StatusCode, Int), reader.ReadToEnd(), null);
        } catch (ex: Dynamic) {
            return new Response(-1, Std.string(ex), null);
        }
    }


#elseif js
    private static function syncRequestJs(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate:String) : Response {
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
            final blob = new js.html.Blob([fileContent._getBytes().getData()]);
            formData.append(fileArg, blob, fileName);
            xhr.send(formData);
        } else {
            xhr.send();
        }

        if (xhr.readyState == js.html.XMLHttpRequest.UNSENT) {
            final message = (xhr.responseText != null)
                ? xhr.responseText
                : 'Error sending ${method} request to "${url}."';
            return new Response(-1, message, xhr.response);
        }

        return new Response(xhr.status, xhr.responseText, xhr.response);
    }


#elseif use_tink
    private static function syncRequestTink(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate:String) : Response {
        final methods = [
            'GET' => tink.http.Method.GET,
            'PUT' => tink.http.Method.PUT,
            'POST' => tink.http.Method.POST
        ];

        var tinkMethod: tink.http.Method = null;
        try {
            tinkMethod = methods.get(method.toUpperCase());
        } catch (e: Dynamic) {
            return new Response(-1, 'Invalid request method ${method}', null);
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
        if (parsedHeaders.length > 0) {
            options.set('headers', parsedHeaders);
        }
        if (body != null) {
            options.set('body', body);
        }

        tink.http.Client.fetch(url, options.toObject()).all().handle(function(o) {
            switch (o) {
                case Success(res):
                    response = new Response(res.header.statusCode, res.body.toString(), null);
                case Failure(res):
                    response = new Response(-1, Std.string(res), null);
            }
        });
        
        // Wait for async request
        while (response == null) {}

        return response;
    }


#elseif python
    private static function syncRequestPython(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate: String) : Response {
        try {
            return connect.native.PythonRequest.request(
                method, url, headers, body, fileArg, fileName, fileContent, 300, certificate);
        } catch (ex: Dynamic) {
            return new Response(-1, Std.string(ex), null);
        }
    }


#else
    public function syncRequestStd(method: String, url: String, headers: Dictionary, body: String,
            fileArg: String, fileName: String, fileContent: Blob, certificate:String) : Response {
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
                new BytesInput(fileContent._getBytes()),
                fileContent.length(),
                'multipart/form-data'
            );
        }

        http.onStatus = function(status_) { status = status_; };
        http.onError = function(msg) {
            status = -1;
            responseBytes.writeString(msg);
        }
        http.customRequest(false, responseBytes, null, method.toUpperCase());

        while (status == null) {} // Wait for async request
        final bytes = responseBytes.getBytes();
        return new Response(status, bytes.toString(), Blob._fromBytes(bytes));
    }
#end


    private static function logRequest(level: Int, method: String, url: String,
            headers: Dictionary, body: String, response: Response, ?logger:Null<Logger> = null): Void {
        final firstMessage = 'Http ${method.toUpperCase()} request to ${url}';
        for (handler in logger.getHandlers()) {
            final fmt = handler.formatter;
            final requestList = new Collection<String>();
            if (headers != null) {
                requestList.push('Headers:\n${getHeadersTable(headers, fmt)}');
            }
            if (body != null) {
                requestList.push(getFormattedData(body, 'Body', fmt));
            }
            if (response.status != -1) {
                requestList.push('Status: ${response.status}');
                requestList.push(getFormattedData(response.text, 'Response', fmt));
            } else {
                requestList.push(getFormattedData(response.text, 'Exception', fmt));
            }
            final requestLogger:Logger = logger != null ? logger : Env.getLogger();
            requestLogger._writeToHandler(
                level,
                fmt.formatBlock(level, '$firstMessage\n${fmt.formatList(level, requestList)}'),
                handler);
        }
    }


    private static function getHeadersTable(headers: Dictionary, fmt: ILoggerFormatter): String {
        final fixedHeaders = (Env.getLogger().getLevel() == Logger.LEVEL_DEBUG)
            ? headers
            : maskHeaders(headers);
        final headerKeys = [for (key in fixedHeaders.keys()) key];
        final headersCol = new Collection<Collection<String>>()
            .push(new Collection<String>().push('Name').push('Value'));
        Lambda.iter(headerKeys, function(key) {
            headersCol.push(
                new Collection<String>()
                    .push(key)
                    .push(fixedHeaders.get(key))
            );
        });
        return fmt.formatTable(Env.getLogger().getLevel(),headersCol);
    }


    private static function maskHeaders(headers: Dictionary): Dictionary {
        return Dictionary.fromObject(Util.maskFields(headers.toObject()));
    }


    private static function getFormattedData(data: String, title: String, fmt: ILoggerFormatter)
            : String {
        final compact = Env.getLogger().getLevel() != Logger.LEVEL_DEBUG;
        if (Util.isJson(data)) {
            final prefix = compact ? '$title (compact): ' : '$title:\n';
            final block = fmt.formatCodeBlock(
                Env.getLogger().getLevel(),
                Util.beautify(
                    data,
                    Env.getLogger().isCompact(),
                    Env.getLogger().getLevel() != Logger.LEVEL_DEBUG,
                    Env.getLogger().isBeautified()),
                'json');
            return '$prefix$block';
        } else {
            final fixedBody = compact
                ? StringTools.lpad(data.substr(data.length - 4), '*', data.length)
                : data;
            return '$title: $fixedBody';
        }
    }


#if js
    private static inline final _JS_CODE = 'var Url=require("url"),spawn=require("child_process").spawn,fs=require("fs");global.XMLHttpRequest = function(){"use strict";var S,w,N=this,v=require("http"),g=require("https"),T={},s=!1,C={"User-Agent":"node-XMLHttpRequest",Accept:"*/*"},D={},O={},r=["accept-charset","accept-encoding","access-control-request-headers","access-control-request-method","connection","content-length","content-transfer-encoding","cookie","cookie2","date","expect","host","keep-alive","origin","referer","te","trailer","transfer-encoding","upgrade","via"],o=["TRACE","TRACK","CONNECT"],R=!1,q=!1,n={};this.UNSENT=0,this.OPENED=1,this.HEADERS_RECEIVED=2,this.LOADING=3,this.DONE=4,this.readyState=this.UNSENT,this.onreadystatechange=null,this.responseText="",this.responseXML="",this.status=null,this.statusText=null,this.withCredentials=!1;this.open=function(e,t,s,r,n){if(this.abort(),q=!1,!function(e){return e&&-1===o.indexOf(e)}(e))throw new Error("SecurityError: Request method not allowed");T={method:e,url:t.toString(),async:"boolean"!=typeof s||s,user:r||null,password:n||null},L(this.OPENED)},this.setDisableHeaderCheck=function(e){s=e},this.setRequestHeader=function(e,t){if(this.readyState!==this.OPENED)throw new Error("INVALID_STATE_ERR: setRequestHeader can only be called when state is OPEN");if(function(e){return s||e&&-1===r.indexOf(e.toLowerCase())}(e)){if(R)throw new Error("INVALID_STATE_ERR: send flag is true");e=O[e.toLowerCase()]||e,O[e.toLowerCase()]=e,D[e]=D[e]?D[e]+", "+t:t}else console.warn(\'Refused to set unsafe header \\"\'+e+\'\\"\')},this.getResponseHeader=function(e){return"string"==typeof e&&this.readyState>this.OPENED&&w&&w.headers&&w.headers[e.toLowerCase()]&&!q?w.headers[e.toLowerCase()]:null},this.getAllResponseHeaders=function(){if(this.readyState<this.HEADERS_RECEIVED||q)return"";var e="";for(var t in w.headers)"set-cookie"!==t&&"set-cookie2"!==t&&(e+=t+": "+w.headers[t]+"\\r\\n");return e.substr(0,e.length-2)},this.getRequestHeader=function(e){return"string"==typeof e&&O[e.toLowerCase()]?D[O[e.toLowerCase()]]:""},this.send=function(e){if(this.readyState!==this.OPENED)throw new Error("INVALID_STATE_ERR: connection must be opened before send() is called");if(R)throw new Error("INVALID_STATE_ERR: send has already been called");var n,t=!1,s=!1,r=Url.parse(T.url);switch(r.protocol){case"https:":t=!0;case"http:":n=r.hostname;break;case"file:":s=!0;break;case void 0:case null:case"":n="localhost";break;default:throw new Error("Protocol not supported.")}if(s){if("GET"!==T.method)throw new Error("XMLHttpRequest: Only GET method is supported");if(T.async)fs.readFile(r.pathname,"utf8",function(e,t){e?N.handleError(e):(N.status=200,N.responseText=t,L(N.DONE))});else try{this.responseText=fs.readFileSync(r.pathname,"utf8"),this.status=200,L(N.DONE)}catch(e){this.handleError(e)} }else{var o=r.port||(t?443:80),a=r.pathname+(r.search?r.search:"");for(var i in C)O[i.toLowerCase()]||(D[i]=C[i]);if(D.Host=n,"["===r.host[0]&&(D.Host="["+D.Host+"]"),t&&443===o||80===o||(D.Host+=":"+r.port),T.user){void 0===T.password&&(T.password="");var h=new Buffer(T.user+":"+T.password);D.Authorization="Basic "+h.toString("base64")}"GET"===T.method||"HEAD"===T.method?e=null:e?(D["Content-Length"]=Buffer.isBuffer(e)?e.length:Buffer.byteLength(e),this.getRequestHeader("Content-Type")||(D["Content-Type"]="text/plain;charset=UTF-8")):"POST"===T.method&&(D["Content-Length"]=0);var d={host:n,port:o,path:a,method:T.method,headers:D,agent:!1,withCredentials:N.withCredentials};if(q=!1,T.async){var u=t?g.request:v.request;R=!0,N.dispatchEvent("readystatechange");var c=function(e){N.handleError(e)};S=u(d,function e(t){if(301!==(w=t).statusCode&&302!==w.statusCode&&303!==w.statusCode&&307!==w.statusCode)w.setEncoding("utf8"),L(N.HEADERS_RECEIVED),N.status=w.statusCode,w.on("data",function(e){e&&(N.responseText+=e),R&&L(N.LOADING)}),w.on("end",function(){R&&(L(N.DONE),R=!1)}),w.on("error",function(e){N.handleError(e)});else{T.url=w.headers.location;var s=Url.parse(T.url);n=s.hostname;var r={hostname:s.hostname,port:s.port,path:s.path,method:303===w.statusCode?"GET":T.method,headers:D,withCredentials:N.withCredentials};(S=u(r,e).on("error",c)).end()} }).on("error",c),e&&S.write(e),S.end(),N.dispatchEvent("loadstart")}else{var f=".node-xmlhttprequest-content-"+process.pid,l=".node-xmlhttprequest-sync-"+process.pid;fs.writeFileSync(l,"","utf8");for(var p="var http = require(\'http\'), https = require(\'https\'), fs = require(\'fs\');var doRequest = http"+(t?"s":"")+".request;var options = "+JSON.stringify(d)+";var responseText = \'\';var req = doRequest(options, function(response) {response.setEncoding(\'utf8\');response.on(\'data\', function(chunk) {  responseText += chunk;});response.on(\'end\', function() {fs.writeFileSync(\'"+f+"\', JSON.stringify({err: null, data: {statusCode: response.statusCode, headers: response.headers, text: responseText} }), \'utf8\');fs.unlinkSync(\'"+l+"\');});response.on(\'error\', function(error) {fs.writeFileSync(\'"+f+"\', JSON.stringify({err: error}), \'utf8\');fs.unlinkSync(\'"+l+"\');});}).on(\'error\', function(error) {fs.writeFileSync(\'"+f+"\', JSON.stringify({err: error}), \'utf8\');fs.unlinkSync(\'"+l+"\');});"+(e?"req.write(\'"+JSON.stringify(e).slice(1,-1).replace(/\'/g,"\\\'")+"\');":"")+"req.end();",E=spawn(process.argv[0],["-e",p]);fs.existsSync(l););var y=JSON.parse(fs.readFileSync(f,"utf8"));E.stdin.end(),fs.unlinkSync(f),y.err?N.handleError(y.err):(w=y.data,N.status=y.data.statusCode,N.responseText=y.data.text,L(N.DONE))} } },this.handleError=function(e){this.status=0,this.statusText=e,this.responseText=e.stack,q=!0,L(this.DONE),this.dispatchEvent("error")},this.abort=function(){S&&(S.abort(),S=null),D=C,this.status=0,this.responseText="",this.responseXML="",q=!0,this.readyState===this.UNSENT||this.readyState===this.OPENED&&!R||this.readyState===this.DONE||(R=!1,L(this.DONE)),this.readyState=this.UNSENT,this.dispatchEvent("abort")},this.addEventListener=function(e,t){e in n||(n[e]=[]),n[e].push(t)},this.removeEventListener=function(e,t){e in n&&(n[e]=n[e].filter(function(e){return e!==t}))},this.dispatchEvent=function(e){if("function"==typeof N["on"+e]&&N["on"+e](),e in n)for(var t=0,s=n[e].length;t<s;t++)n[e][t].call(N)};var L=function(e){e!=N.LOADING&&N.readyState===e||(N.readyState=e,(T.async||N.readyState<N.OPENED||N.readyState===N.DONE)&&N.dispatchEvent("readystatechange"),N.readyState!==N.DONE||q||(N.dispatchEvent("load"),N.dispatchEvent("loadend")))} };';
    private static var _isXMLHttpRequestInit: Bool = false;

    private static function initXMLHttpRequest(): Void {
        if (!_isXMLHttpRequestInit) {
            js.Syntax.code(_JS_CODE);
            _isXMLHttpRequestInit = true;
        }
    }
#end
}
