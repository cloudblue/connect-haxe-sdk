/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/


class MavenCentralDeployer {
    public static function main(): Void {
        //final user = Sys.getEnv('mvn_user');
        //final password = Sys.getEnv('mvn_password');
        call('start', 'post');
    }


    private static function call(path: String, method: String, ?body: String): String {
        final output = new haxe.io.BytesOutput();
        final http = new haxe.Http(getUrl('start'));
        if (body != null) {
            http.setPostData(body);
        }
        var status = -1;
        http.onStatus = newStatus -> status = newStatus;
        http.onError = msg -> throw msg;
        http.customRequest(false, output, null, method.toUpperCase());
        while (status == null) {}
        return output.getBytes().toString();
    }
    
    
    private static function getUrl(path: String) {
        final profileId = 'com.github.javicerveraingram';
        final baseUrl = 'http://localhost:8081/nexus/service/local/staging/profiles';
        return '$baseUrl/$profileId/$path';
    }
}
