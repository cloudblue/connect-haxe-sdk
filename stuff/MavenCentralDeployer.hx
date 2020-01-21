/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/


class MavenCentralDeployer {
    public static function main(): Void {
        start();
    }

    private static final host = 'https://oss.sonatype.org';


    private static function start() {
        call('start', 'post');
    }


    private static function call(path: String, method: String, ?body: String): String {
        haxe.Http.PROXY = {
            port: 443,
            host: host,
            auth: {
                user: Sys.getEnv('mvn_user'),
                pass: Sys.getEnv('mvn_password')
            }
        };
        final http = new haxe.Http(getUrl('start'));
        if (body != null) http.setPostData(body);
        var status = -1;
        http.onStatus = newStatus -> status = newStatus;
        http.onError = msg -> throw msg;
        final output = new haxe.io.BytesOutput();
        http.customRequest(false, output, null, method.toUpperCase());
        while (status == null) {}
        return output.getBytes().toString();
    }
    

    private static function getUrl(path: String) {
        final profileId = 'com.github.javicerveraingram';
        final baseUrl = '$host/service/local/staging/profiles';
        return '$baseUrl/$profileId/$path';
    }
}
