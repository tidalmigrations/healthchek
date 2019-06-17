import java.net.HttpURLConnection
import java.net.MalformedURLException
import java.net.URL
import java.net.UnknownHostException
import kotlin.system.exitProcess

fun main(args: Array<String>) {
    try {
        require(args.size in 1..2)

        val url = URL(args[0])
        val expectedStatus = args.getOrNull(1)?.toInt()

        with(url.openConnection() as HttpURLConnection) {
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

fun die(message: String) {
    System.err.println(message)
    exitProcess(1)
}

fun usage() {
    die("Usage: java -jar healthchek.jar URL [STATUS]")
}
