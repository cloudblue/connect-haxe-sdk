# Connect Haxe SDK

This is a version of the SDK for Incram Micro's Connect platform, written in Haxe. While it allows to write connectors in Haxe itself, the generated code can be used to write connectors in other languages:

* Java.
* JavaScript.
* PHP.
* Python.

Other platforms that will be added in the future:

* C++.
* C#.

In order to compile the SDK, you must have Haxe 4.0 or higher installed on your machine. When this README was last updated, Haxe 4.0 was not officialy released, so installing from the official repositories of your distro will get you Haxe 3:

```shell script
$ sudo apt install haxe
```

Haxelib and Neko are installed by default (you need Neko to run the unit tests) with this procedure, but while Haxe 4.0 is released to your distribution, you'll have to follow the installation instructions on the [Haxe webpage](https://haxe.org/).

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

A `_packages` folder will be generated with subfolders for every target language. For example, if you want to use it in Java, you should go to the `_packages/connect.java` folder, and copy `connect.jar` to your project.

To run an example written in Haxe, type:

```shell script
$ haxe example.hxml
```

This translates the file `examples/Example.hx` to PHP and runs it.

To generate the documentation, type:

```shell script
$ haxe doc.hxml
```

Documentation with be generated in the `doc` folder.

To run the unit tests, type:

```shell script
$ haxe unittests.hxml
```
