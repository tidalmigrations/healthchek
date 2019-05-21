import java.lang.Integer.parseInt
import java.net.HttpURLConnection
import java.net.URL
import kotlin.system.exitProcess

fun main(args: Array<String>) {
    if (args.size != 2) {
        usage()
    }

    val url = URL(args[0])
    val expectedStatus = parseInt(args[1])

    val connection = url.openConnection() as HttpURLConnection
    connection.requestMethod = "HEAD"

    val status = connection.responseCode

    if (status != expectedStatus) {
        System.err.println("$url : expected $expectedStatus, got $status")
        exitProcess(1)
    }

    println("$url : OK")
}

fun usage() {
    System.err.println("Usage:\n  java -jar healthchek.jar <url> <status>")
    exitProcess(1)
}
