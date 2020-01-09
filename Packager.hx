/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/

import sys.FileSystem;
#if !packager
import connect.DateTime;
import connect.Env;
import connect.Processor;
import connect.logger.Logger;
import connect.models.Account;
import connect.models.Action;
import connect.models.Activation;
import connect.models.Agreement;
import connect.models.AgreementStats;
import connect.models.Asset;
import connect.models.AssetRequest;
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
import connect.models.Template;
import connect.models.TierAccount;
import connect.models.TierConfig;
import connect.models.TierConfigRequest;
import connect.models.Tiers;
import connect.models.UsageFile;
import connect.models.UsageRecord;
import connect.models.UsageRecords;
import connect.models.User;
#end

class Packager {
    public static function main() {
    #if packager
        final classes = getClassNames();
        createJavaPackage();
        createJSPackage(classes);
        createPhpPackage(classes);
        createPythonPackage(classes);
    #elseif js
        js.Syntax.code("global.$hxClasses = $hxClasses;");
    #end
    }

#if packager
    private static final EOL = '\r\n';

    private static function getClassNames(): Array<String> {
        final xmlContent = sys.io.File.getContent('_build/connect.xml');
        final root = Xml.parse(xmlContent).firstElement();
        final iter = root.elementsNamed('class');
        return [
            for (class_ in iter)
                if (StringTools.startsWith(class_.get('path'), 'connect.')
                        && class_.get('path').indexOf('._') == -1
                        && class_.get('path').indexOf('.impl.') == -1)
                    class_.get('path')
        ];
    }


    private static function getPackages(classNames: Array<String>): Array<String> {
        final packages: Array<String> = [];
        for (className in classNames) {
            final pkg = getPackage(className);
            if (packages.indexOf(pkg) == -1) {
                packages.push(pkg);
            }
        }
        return packages;
    }


    private static function getPackage(className: String): String {
        return className.split('.').slice(0, -1).join('.');
    }


    private static function getClassesInPackage(classNames: Array<String>, pkg: String)
            : Array<String> {
        return [for(cls in classNames) if (getPackage(cls) == pkg) stripPackage(cls)];
    }


    private static function stripPackage(className: String): String {
        return className.split('.').pop();
    }


    private static function createPath(path: String): Void {
        if (!FileSystem.exists(path)) {
            FileSystem.createDirectory(path);
        }
    }


    private static function copyLicense(destPath: String): Void {
        sys.io.File.copy('LICENSE', destPath + '/LICENSE');
    }


    private static function createJavaPackage(): Void {
        createPath('_packages/connect.java');
        copyLicense('_packages/connect.java');
        sys.io.File.copy('_build/java/Packager.jar', '_packages/connect.java/connect.jar');
        sys.io.File.copy('stuff/pom.xml', '_packages/connect.java/pom.xml');
    }


    private static function createJSPackage(classes: Array<String>): Void {
        createPath('_packages/connect.js');
        copyLicense('_packages/connect.js');

        // Get list of packages
        final packages = getPackages(classes).map(function(pkg) {
            if (StringTools.startsWith(pkg, 'connect.')) {
                return pkg.substr(8);
            } else if (StringTools.startsWith(pkg, 'connect')) {
                return pkg.substr(7);
            } else {
                return pkg;
            }
        }).filter(function(pkg) { return  pkg != ""; });

        // Copy JavaScript code
        sys.io.File.copy('_build/connect.js', '_packages/connect.js/connect.js');
        
        // Append module exports
        final file = sys.io.File.append('_packages/connect.js/connect.js');
        file.writeString(EOL);
        file.writeString('module.exports = {' + EOL);
        final pkgClasses = getClassesInPackage(classes, 'connect');
        for (cls in pkgClasses) {
            file.writeString('    ${cls}: global.$$hxClasses["connect.${cls}"],' + EOL);
        }
        for (pkg in packages) {
            final pkgClasses = getClassesInPackage(classes, 'connect.' + pkg);
            file.writeString('    ${pkg}: {' + EOL);
            for (cls in pkgClasses) {
                file.writeString('        ${cls}: global.$$hxClasses["connect.${pkg}.${cls}"],' + EOL);
            }
            file.writeString('    },' + EOL);
        }
        file.writeString('}' + EOL);
        file.close();
    }


    private static function createPhpPackage(classes: Array<String>): Void {
        createPath('_packages/connect.php');
        copyLicense('_packages/connect.php');
        final file = sys.io.File.write('_packages/connect.php/connect.php');
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
        copyPath('_build/php/lib', '_packages/connect.php/lib');
    }


    private static function createPythonPackage(classes: Array<String>): Void {
        // Define output directory
        final outDir = '_build/python';

        // Get list of packages
        final packages = getPackages(classes);

        // Create package folders
        for (pkg in packages) {
            final pkgPath = StringTools.replace(pkg, '.', '/');
            createPath('$outDir/$pkgPath');
        }

        // Copy haxe code
        //sys.io.File.copy('_build/connect.py', '_packages/connect.py/connect/autogen.py');

        // Copy license
        copyLicense(outDir);

        // Create __init__.py files
        for (pkg in packages) { 
            final pkgPath = StringTools.replace(pkg, '.', '/');
            final pkgClasses = getClassesInPackage(classes, pkg);
            final file = sys.io.File.write('$outDir/${pkgPath}/__init__.py');
            
            // Write imports
            for (cls in pkgClasses) {
                final autogenName = StringTools.replace(pkg, '.', '_') + '_' + cls;
                file.writeString('from connect.autogen import ${autogenName} as ${cls}' + EOL);
            }
            file.writeString(EOL + EOL);

            if (pkg == 'connect') {
                file.writeString('SYNCREQUEST_PATH = \'connect.autogen.connect_api_impl_ApiClientImpl.syncRequest\'' + EOL + EOL);
            }

            // Write __all__
            file.writeString('__all__ = [' + EOL);
            if (pkg == 'connect') {
                file.writeString('    \'SYNCREQUEST_PATH\',' + EOL);
            }
            for (cls in pkgClasses) {
                file.writeString('    \'${cls}\',' + EOL);
            }
            file.writeString(']' + EOL);

            file.close();
        }

        // Create setup.py file
        final file = sys.io.File.write('$outDir/setup.py');
        file.writeString("from setuptools import setup" + EOL + EOL + EOL);
        file.writeString("setup(" + EOL);
        file.writeString("    name='cbconnect'," + EOL);
        file.writeString("    author='Ingram Micro'," + EOL);
        file.writeString("    author_email='connect-service-account@ingrammicro.com'," + EOL);
        file.writeString("    version='18.0'," + EOL);
        file.writeString("    keywords='connect sdk cloudblue ingram micro ingrammicro cloud'," + EOL);
        file.writeString("    packages=[" + packages.map(function(pkg) { return '\'${pkg}\''; }).join(', ') + "]," + EOL);
        file.writeString("    description='CloudBlue Connect SDK, generated from Haxe'," + EOL);
        file.writeString("    url='https://github.com/cloudblue/connect-haxe-sdk'," + EOL);
        file.writeString("    license='Apache Software License'," + EOL);
        file.writeString("    install_requires=['requests==2.21.0']" + EOL);
        file.writeString(")" + EOL);
        file.close();
    }


    private static function copyPath(src: String, dest: String): Void {
        createPath(dest);
        final dirContents = FileSystem.readDirectory(src);
        for (entry in dirContents) {
            final fullSrcName = '${src}/${entry}';
            final fullDestName = '${dest}/${entry}';
            if (FileSystem.isDirectory(fullSrcName)) {
                copyPath(fullSrcName, fullDestName);
            } else {
                sys.io.File.copy(fullSrcName, fullDestName);
            }
        }
    }
#end
}
