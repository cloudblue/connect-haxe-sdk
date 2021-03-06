# Connect Haxe SDK

This is a version of the SDK for [CloudBlue Connect](https://www.cloudblue.com/connect/) platform, written in Haxe. While it allows to write connectors in Haxe itself, the generated code can be used in other languages:

* C#.
* Java.
* JavaScript.
* PHP.
* Python.

Documentation on how to use the SDK is available [here](https://cloudblue.github.io/connect-haxe-sdk/).

## Building

In order to compile the SDK, you must have Haxe 4.0 or higher installed on your machine. On Debian-based Linux distributions, such as Ubuntu and Mint, Haxe can be installed by typing the following on a terminal:

```shell script
$ sudo apt install haxe
```

Haxelib and Neko are installed by default (you need Neko to run the unit tests) with this procedure. At the time of writing this README, Haxe 4.0 has not yet been published to the official repositories nor Haxe's PPA, so in the meantime you'll have to follow the installation instructions on the [Haxe webpage](https://haxe.org/). Using this procedure, Neko has to be installed separately.

You need to install some libraries to build the SDK using Haxelib:

```shell script
$ haxelib install dox
$ haxelib install hxcs
$ haxelib install hxjava
$ haxelib install hxnodejs
$ haxelib install munit
```

To build the SDK for all the available targets, type the following on a terminal:

```shell script
$ haxe package.hxml
```

## Examples

Examples require you to open the "examples/config.json" file and provide valid credentials.

To run an example written in Haxe, type:

```shell script
$ haxe example.hxml
```

This translates the file `examples/Example.hx` to PHP and runs it.

To run examples written in Java, JavaScript, PHP or Python, respectively run the following on a terminal:

```shell script
$ ./example_cs.sh
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

## Generating docs and running tests

To generate the documentation, type:

```shell script
$ haxe doc.hxml
```

Documentation with be generated in the `doc` folder.

To run the unit tests on Haxe's builtin interpreter, type:

```shell script
$ haxelib run munit test -neko
```

To run the unit tests on all supported platforms, type:

```shell script
$ haxelib run munit test -cs -java -js -php -python
```

To enable code coverage reporting, just add `-coverage` to the previous command. Right now, it does not work on JavaScript.
