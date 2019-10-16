import sys.FileSystem;
#if !packager
import connect.Env;
import connect.Logger;
import connect.Processor;
import connect.models.Account;
import connect.models.Action;
import connect.models.Activation;
import connect.models.Agreement;
import connect.models.AgreementStats;
import connect.models.Asset;
import connect.models.Category;
import connect.models.Choice;
import connect.models.Configuration;
import connect.models.Configurations;
import connect.models.Connection;
import connect.models.Constraints;
import connect.models.Contact;
import connect.models.ContactInfo;
import connect.models.Contract;
import connect.models.Conversation;
import connect.models.Country;
import connect.models.CustomerUiSettings;
import connect.models.Document;
import connect.models.DownloadLink;
import connect.models.Event;
import connect.models.Events;
import connect.models.ExtIdHub;
import connect.models.Family;
import connect.models.Hub;
import connect.models.HubStats;
import connect.models.IdModel;
import connect.models.Instance;
import connect.models.Item;
import connect.models.Marketplace;
import connect.models.Media;
import connect.models.Message;
import connect.models.Model;
import connect.models.Param;
import connect.models.PhoneNumber;
import connect.models.Product;
import connect.models.ProductConfigurationParam;
import connect.models.ProductStats;
import connect.models.ProductStatsInfo;
import connect.models.Renewal;
import connect.models.Request;
import connect.models.Template;
import connect.models.TierAccount;
import connect.models.Tiers;
import connect.models.User;
#end

class Packager {
    public static function main() {
#if packager
        var classes = getClassNames();
        createJavaPackage();
        createPhpPackage(classes);
        createPythonPackage(classes);
#end
    }

#if packager
    private static inline var EOL = '\r\n';

    private static function getClassNames(): Array<String> {
        var xmlContent = sys.io.File.getContent('_build/connect.xml');
        var root = Xml.parse(xmlContent).firstElement();
        var iter = root.elementsNamed('class');
        return [
            for (class_ in iter)
                if (StringTools.startsWith(class_.get('path'), 'connect.')
                        && class_.get('path').indexOf('._') == -1
                        && class_.get('path').indexOf('.impl.') == -1)
                    class_.get('path')
        ];
    }


    private static function getPackages(classNames: Array<String>): Array<String> {
        var packages: Array<String> = [];
        for (className in classNames) {
            var package_ = getPackage(className);
            if (packages.indexOf(package_) == -1) {
                packages.push(package_);
            }
        }
        return packages;
    }


    private static function getPackage(className: String): String {
        return className.split('.').slice(0, -1).join('.');
    }


    private static function stripPackage(className: String): String {
        return className.split('.').pop();
    }


    private static function createPath(path: String): Void {
        if (!FileSystem.exists(path)) {
            FileSystem.createDirectory(path);
        }
    }


    private static function createJavaPackage(): Void {
        createPath('_build/_packages/java');
        sys.io.File.copy('_build/java/Packager.jar', '_build/_packages/java/connect.jar');
    }


    private static function createPhpPackage(classes: Array<String>): Void {
        createPath('_build/_packages/php');
        var file = sys.io.File.write('_build/_packages/php/connect.php');
        file.writeString('<?php' + EOL + EOL);
        file.writeString("set_include_path(get_include_path().PATH_SEPARATOR.__DIR__.'/lib');" + EOL);
        file.writeString("spl_autoload_register(" + EOL);
        file.writeString("    function($class){" + EOL);
        file.writeString("        $file = stream_resolve_include_path(str_replace('\\\\', '/', $class) .'.php');" + EOL);
        file.writeString("        if ($file) {" + EOL);
        file.writeString("            include_once $file;" + EOL);
        file.writeString("        }" + EOL);
        file.writeString("    }" + EOL);
        file.writeString(");" + EOL);
        file.writeString("\\php\\Boot::__hx__init();" + EOL);
        file.close();
        copyPath('_build/php/lib', '_build/_packages/php/lib');
    }


    private static function createPythonPackage(classes: Array<String>): Void {
        // Get list of packages
        var packages = getPackages(classes);

        // Create package folders
        for (pkg in packages) {
            var pkgPath = StringTools.replace(pkg, '.', '/');
            createPath('_build/_packages/python/${pkgPath}');
        }

        // Copy haxe code
        sys.io.File.copy('_build/connect.py', '_build/_packages/python/connect/autogen.py');

        // Create __init__.py files
        for (pkg in packages) { 
            var pkgPath = StringTools.replace(pkg, '.', '/');
            var pkgClasses = [for (cls in classes) if (getPackage(cls) == pkg) stripPackage(cls)];
            var file = sys.io.File.write('_build/_packages/python/${pkgPath}/__init__.py');
            
            // Write imports
            for (cls in pkgClasses) {
                var autogenName = StringTools.replace(pkg, '.', '_') + '_' + cls;
                file.writeString('from connect.autogen import ${autogenName} as ${cls}' + EOL);
            }
            file.writeString(EOL + EOL);

            // Write __all__
            file.writeString('__all__ = [' + EOL);
            for (cls in pkgClasses) {
                file.writeString('    \'${cls}\',' + EOL);
            }
            file.writeString(']' + EOL);

            file.close();
        }

        // Create setup.py file
        var file = sys.io.File.write('_build/_packages/python/setup.py');
        file.writeString("from setuptools import setup" + EOL + EOL + EOL);
        file.writeString("setup(" + EOL);
        file.writeString("    name='connect'," + EOL);
        file.writeString("    author='Ingram Micro'," + EOL);
        file.writeString("    version='0.0.0'," + EOL);
        file.writeString("    keywords='connect ingram sdk'," + EOL);
        file.writeString("    packages=[" + packages.map(function(pkg) { return '\'${pkg}\''; }).join(', ') + "]," + EOL);
        file.writeString("    description='Connect Python SDK'," + EOL);
        //file.writeString("    url='https://github.com/ingrammicro/connect-python-sdk'," + EOL);
        file.writeString("    license='Apache Software License'," + EOL);
        file.writeString("    install_requires=['requests==2.21.0']" + EOL);
        file.writeString(")" + EOL);
        file.close();
    }


    private static function copyPath(src: String, dest: String): Void {
        createPath(dest);
        var dirContents = FileSystem.readDirectory(src);
        for (entry in dirContents) {
            var fullSrcName = '${src}/${entry}';
            var fullDestName = '${dest}/${entry}';
            if (FileSystem.isDirectory(fullSrcName)) {
                copyPath(fullSrcName, fullDestName);
            } else {
                sys.io.File.copy(fullSrcName, fullDestName);
            }
        }
    }
#end
}
