# Connect Haxe SDK

This is a version of the SDK for Incram Micro's Connect platform, written in Haxe. While it allows to write connectors in Haxe itself, the generated code can be used to write connectors in other languages:

* Java.
* PHP (requires compiling with Haxe 4 or higher).

Other platforms that will be added in the future:

* C++.
* C#.
* JavaScript (do not use it yet, it has a security flaw due to the use of `eval`).
* Python (will work with Haxe 4.1 onwards).

In order to compile the SDK, you must have Haxe installed on your machine. To install it on Ubuntu, simply do:

```shell script
$ sudo apt install haxe
```

Haxelib and Neko are installed by default (you need Neko to run the unit tests). To install on other platforms, follow the installation instructions on the [Haxe webpage](https://haxe.org/).

You need to install some libraries to build the SDK using Haxelib:

```shell script
$ haxelib install dox
$ haxelib install hxcpp
$ haxelib install hxcs
$ haxelib install hxjava
$ haxelib install hxnodejs
```

To build the SDK for all the available targets, type the following on a terminal:

```shell script
$ haxe package.hxml
```

A `_build/_packages` folder will be generated with subfolders for every target language. For example, if you want to use it in Java, you should go to the `_build/_packages/java` folder, and copy `connect.jar` to your project.

To run an example written in Haxe, type:

```shell script
$ haxe example.hxml
```

It compiles the `examples/Example.hx` file to Java and runs it.

To generate the documentation, type:

```shell script
$ haxe doc.hxml
```

Documentation with be generated in the `doc` folder.

To run the unit tests, type:

```shell script
$ haxe unittests.hxml
```
