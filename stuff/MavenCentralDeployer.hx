package stuff;

class MavenCentralDeployer {
    public static function main(): Void {
        final user = Sys.getEnv('mvn_user');
        final password = Sys.getEnv('mvn_password');
        trace('mvn_user=$user');
        trace('mvn_password=$password');
    }
}