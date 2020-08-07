/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/

import sys.FileSystem;
#if !packager
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
import connect.models.BillingAnniversary;
import connect.models.BillingInfo;
import connect.models.BillingStats;
import connect.models.BillingStatsInfo;
import connect.models.BillingStatsRequest;
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
import connect.models.ItemBilling;
import connect.models.Listing;
import connect.models.ListingRequest;
import connect.models.ListingSourcing;
import connect.models.Marketplace;
import connect.models.Media;
import connect.models.Message;
import connect.models.Model;
import connect.models.Param;
import connect.models.Period;
import connect.models.PhoneNumber;
import connect.models.Product;
import connect.models.ProductConfigurationParam;
import connect.models.ProductStats;
import connect.models.ProductStatsInfo;
import connect.models.Renewal;
import connect.models.Subscription;
import connect.models.SubscriptionRequest;
import connect.models.SubscriptionRequestAttributes;
import connect.models.Template;
import connect.models.TierAccount;
import connect.models.TierConfig;
import connect.models.TierConfigRequest;
import connect.models.Tiers;
import connect.models.UsageCategory;
import connect.models.UsageFile;
import connect.models.UsageParam;
import connect.models.UsageRecord;
import connect.models.UsageStats;
import connect.models.User;
import connect.util.DateTime;
#end

class Connect {
    public static function main() {
    #if packager
        final version = StringTools.trim(sys.io.File.getContent('VERSION'));
        final classes = getClassNames();
        createCsPackage(version, classes);
        createJavaPackage(version);
        createJsPackage(classes);
        createPhpPackage(classes);
        createPythonPackage(version, classes);
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


    private static function createCsPackage(version: String, classes: Array<String>): Void {
        final outDir = '_build/cs/bin';
        copyLicense(outDir);
        sys.io.File.copy('stuff/CS_README.md', '$outDir/README.md');
        final nuspec = sys.io.File.getContent('stuff/Connect.nuspec');
        final fixedNuspec = StringTools.replace(nuspec, '__VERSION__', version);
        sys.io.File.saveContent('$outDir/Connect.nuspec', fixedNuspec);
    }
    
    
    private static function createJavaPackage(version: String): Void {
        final outDir = '_build/java';
        final outFile = '$outDir/connect.sdk-$version.jar';
        copyLicense(outDir);
        sys.io.File.copy('stuff/JAVA_README.md', '$outDir/README.md');
        sys.io.File.copy('stuff/gitignore_java', '$outDir/.gitignore');
        sys.io.File.copy('stuff/connect-sources.jar', '$outDir/connect.sdk-$version-sources.jar');
        sys.io.File.copy('stuff/connect-javadoc.jar', '$outDir/connect.sdk-$version-javadoc.jar');
        final pom = sys.io.File.getContent('stuff/pom.xml');
        final fixedPom = StringTools.replace(pom, '__VERSION__', version);
        sys.io.File.saveContent('$outDir/connect.sdk-$version.pom', fixedPom);
        if (FileSystem.exists(outFile)) {
            FileSystem.deleteFile(outFile);
        }
        FileSystem.rename('$outDir/Connect.jar', outFile);
    }


    private static function createJsPackage(classes: Array<String>): Void {
        final outDir = '_build/js';
        copyLicense(outDir);

        // Get list of packages
        final packages = getPackages(classes).map(function(pkg) {
            if (StringTools.startsWith(pkg, 'connect.')) {
                return pkg.substr(8);
            } else if (StringTools.startsWith(pkg, 'connect')) {
                return pkg.substr(7);
            } else {
                return pkg;
            }
        }).filter(pkg -> pkg != '');

        // Append module exports
        final file = sys.io.File.append('$outDir/connect.js');
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
        copyLicense('_build/php');
    }


    private static function createPythonPackage(version: String, classes: Array<String>): Void {
        // Define output directory
        final outDir = '_build/python';

        // Get list of packages
        final packages = getPackages(classes);

        // Create package folders
        for (pkg in packages) {
            final pkgPath = StringTools.replace(pkg, '.', '/');
            createPath('$outDir/$pkgPath');
        }

        // Copy license and readme files
        copyLicense(outDir);
        sys.io.File.copy('stuff/PYTHON_README.md', '$outDir/README.md');

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

        file.writeString("from os import path" + EOL);
        file.writeString("from setuptools import setup" + EOL + EOL + EOL);
        file.writeString("with open(path.join(path.abspath(path.dirname(__file__)), 'README.md')) as fhandle:" + EOL);
        file.writeString("    README = fhandle.read()" + EOL + EOL + EOL);
        file.writeString("setup(" + EOL);
        file.writeString("    name='connect-sdk-haxe-port'," + EOL);
        file.writeString("    version='" + version + "'," + EOL);
        file.writeString("    description='CloudBlue Connect SDK, generated from Haxe'," + EOL);
        file.writeString("    long_description=README," + EOL);
        file.writeString("    long_description_content_type='text/markdown'," + EOL);
        file.writeString("    author='Ingram Micro'," + EOL);
        file.writeString("    author_email='connect-service-account@ingrammicro.com'," + EOL);
        file.writeString("    keywords='connect sdk cloudblue ingram micro ingrammicro cloud automation'," + EOL);
        file.writeString("    packages=[" + packages.map(function(pkg) { return '\'${pkg}\''; }).join(', ') + "]," + EOL);
        file.writeString("    url='https://github.com/cloudblue/connect-haxe-sdk'," + EOL);
        file.writeString("    license='Apache Software License'," + EOL);
        file.writeString("    install_requires=['requests==2.21.0']" + EOL);
        file.writeString(")" + EOL);
        file.close();
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
        createPath(destPath);
        sys.io.File.copy('LICENSE', destPath + '/LICENSE');
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
