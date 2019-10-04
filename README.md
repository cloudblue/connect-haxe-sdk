# Connect Haxe SDK

This is a version of the SDK for Incram Micro's Connect platform, written in Haxe. While it allows to write connectors in Haxe itself, the generated code can be used to write connectors in other languages:

* C++.
* Java.
* PHP (requires compiling with Haxe 4 or higher).

Other platforms that will be added in the future:

* C#.
* JavaScript (do not use yet, it has a secirity flaw due to the use of `eval`).
* Python (will work with Haxe 4.1 onwards).

In order to compile the SDK, you must have Haxe installed on your machine. To install it on Ubuntu, simply do:

```shell script
$ sudo app install haxe
```

Haxelib and Neko are installed by default (you need Neko to run the unit tests). To install on other platforms, follow installation instructions on [Haxe webpage](https://haxe.org/).

You need to install some libraries to build the SDK using Haxelib:

```shell script
$ haxelib install dox
$ haxelib install hxcpp
$ haxelib install hxcs
$ haxelib install hxjava
$ haxelib install hxnodejs
```

To build the SDK for all the available targets, type the following:

```shell script
$ haxe lib.hxml
```

A `_build` folder will be generated with subfolders for every target (except Python and JavaScript, which are exported to a single file). In the near future, all preparations to use the SDK on the target languages will be make by the build script itself. By now, if you want to use it for example in Java, you should go to the `_build\java` folder, rename `Empty.jar` to `connect.jar`, and use the JAR file in your project.

To run an example written in Haxe, type:

```shell script
$ haxe example.hxml
```

It compiles the `Example.hx` file to Java and runs it.

To generate the documentation, type:

```shell script
$ haxe doc.hxml
```

To run the unit tests, type:

```shell script
$ haxe unittests.hxml
```
