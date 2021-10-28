# healthchek

Small utility to check if a specified endpoint is available and (optionally)
responds with some expected HTTP status code. 

## Usage

```
java -jar healthchek.jar URL [STATUS]
```

Replace `URL` and `STATUS` with appropriate URL to check and the expected HTTP
response status code.

For example, the following command will just check that `http://example.com` is
available:

```
java -jar healthchek.jar http://example.com/
```

And the following command will check for `http://example.com` availability and
also will check that the response code in `200`. Please note the `-ea` flag,
this enables JVM assertions.

```
java -ea -jar healthchek.jar http://example.com/ 200
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
    -ea -jar healthchek.jar <url> <status>
```

Alternatively, it could be provided using the `JAVA_TOOL_OPTIONS` environment
variable, for example:

```
export JAVA_TOOL_OPTIONS="-Dhttp.proxyHost=<host> -Dhttp.proxyPort=<port>"
java -ea -jar healthchek.jar <url> <status>
```

## Use as Docker container

To use `healthchek` utility as a Docker container, run the following:

```
docker buildx build -t healthchek .x
docker container run -it --rm healthchek <url> <status>
```

## Deploying to production

Note: Tidal tools pulls the `latest` tag so updating that image will release it to be used by tidal tools. Tidal tools will only download the new image isn't already present on the system.

To release to production merge any changes to the master branche and that will result in a new image being deployed with the `latest` tag and in use in production.

You can see the [trigger here that is configured to deploy](https://console.cloud.google.com/cloud-build/triggers/edit/1e85456b-fa93-4e93-8d90-ae084bb35458?project=tidal-1529434400027)

The [cloudbuild.yaml](./cloudbuild.yaml) file specifies the build steps.

From the same Cloud Build section in the GCP Console you can also see the status of the builds.
