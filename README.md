# Connect Haxe SDK

This is a version of the SDK for Incram Micro's Connect platform, written in Haxe. While it allows to write connectors in Haxe itself, the generated code can be used to write connectors in other languages:

* Java.
* JavaScript.
* PHP.
* Python.

C# support will be coming in the future.

Documentation on how to use the SDK is available [here](https://cloudblue.github.io/connect-haxe-sdk/).

In order to compile the SDK, you must have Haxe 4.0 or higher installed on your machine. On Debian-based Linux distributions, such as Ubuntu and Mint, Haxe can be installed by typing the following on a terminal:

```shell script
$ sudo apt install haxe
```

Haxelib and Neko are installed by default (you need Neko to run the unit tests) with this procedure. At the time of writing this README, Haxe 4.0 has not yet been published to the official repositories nor Haxe's PPA, so in the meantime you'll have to follow the installation instructions on the [Haxe webpage](https://haxe.org/). Using this procedure, Neko has to be installed separately.

You need to install some libraries to build the SDK using Haxelib:

```shell script
$ haxelib install dox
$ haxelib install hx3compat
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

To run examples written in Java, JavaScript, PHP or Python, respectively run the following on a terminal:

```shell script
$ ./example_java.sh
$ ./example_js.sh
$ ./example_php.sh
$ ./example_py.sh
```

The Python version automatically creates a Python3 virtual environment with venv on the `_build` dir.

If you want to run all the examples, run:

```shell script
$ ./run_examples.sh
```

To generate the documentation, type:

```shell script
$ haxe doc.hxml
```

Documentation with be generated in the `doc` folder.

To run the unit tests on Haxe's builtin interpreter, type:

```shell script
$ haxe unittests.hxml
```

To run the unit tests on all supported platforms, type:

```shell script
$ haxe unittests_platforms.hxml
```
