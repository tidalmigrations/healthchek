package healthchek

import java.net.URL
import java.net.MalformedURLException
import kotlin.system.exitProcess
import java.net.HttpURLConnection
import java.net.UnknownHostException

class App(val url: URL, val expectedStatus: Int? = null) {
    fun run() {
        val expectedStatus = this.expectedStatus
        with(this.url.openConnection() as HttpURLConnection) {
            connectTimeout = 5000
            readTimeout = 5000
            requestMethod = "HEAD"

            val actualStatus = responseCode
            expectedStatus?.let {
                assert(expectedStatus == actualStatus) {
                    "expected HTTP status $expectedStatus, got $actualStatus"
                }
            }
        }
    }
}

fun die(message: String) {
    System.err.println(message)
    exitProcess(1)
}

fun usage() {
    die("Usage: java -jar healthchek.jar URL [STATUS]")
}

fun main(args: Array<String>) {
    try {
        // Check if there were 1 or 2 arguments provided
        require(args.size in 1..2) 
        // Check if the first argument is a valid URL
        val url = URL(args[0])
        // Check if the second argument is a valid Int or Null
        val expectedStatus = args.getOrNull(1)?.toInt()

        App(url, expectedStatus).run()
    } catch (e: Throwable) {
        when (e) {
            is IllegalArgumentException,
            is MalformedURLException -> usage()
            is UnknownHostException -> die("${e.message}: IP address of a host could not be determined")
            else -> die("${e.message}")
        }
    }
    println("OK")
}
