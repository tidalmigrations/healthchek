# healthchek

Small utility to check if the HEAD HTTP request to the specified URL responds
with the expected HTTP status code. 

## Usage

```
java -jar healthchek.jar <url> <status>
```

Replace `<url>` and `<status>` with appropriate URL to check and the expected HTTP response status code, for example:

```
java -jar healthchek.jar http://example.com/ 200
```

## Requirements

`healthchek` is written in [Kotlin](https://kotlinlang.org/), so to build it you need
to have Kotlin compiler installed.

### SDKMAN!

The easy way to install Kotlin on UNIX based systems (Linux, macOS, etc) is by
using SDKMAN! Run the following in a terminal and follow the instructions:

```
curl -s https://get.sdkman.io | bash
```

Next open a new terminal and install Kotlin with:

```
sdk install kotlin
```

### Homebrew

Alternatively, on macOS you can install the compiler via
[Homebrew](https://brew.sh/):

```
brew update
brew install kotlin
```

## Build

Compile the application using the Kotlin compiler:

```
kotlinc src/* -include-runtime -d healthchek.jar
```

## Proxy settings

HTTP or HTTPS proxy settings can be specified as described on the [Java
Networking and
Proxies](https://docs.oracle.com/javase/8/docs/technotes/guides/net/proxies.html)
page.

It could be either provided as `java` command-line flags:

```
java \
    -Dhttp.proxyHost=<http_proxy_host> \
    -Dhttp.proxyPort=<http_proxy_port> \
    -jar healthchek.jar <url> <status>
```

Alternatively, it could be provided using the `JAVA_TOOL_OPTIONS` environment
variable, for example:

```
export JAVA_TOOL_OPTIONS="-Dhttp.proxyHost=<host> -Dhttp.proxyPort=<port>"
java -jar healthchek.jar <url> <status>
```

## Use as Docker container

To use `healthchek` utility as a Docker container, run the following:

```
docker build -t healthchek .
docker container run -it --rm healthchek <url> <status>
```
