package healthchek

import kotlin.test.Test
import kotlin.test.assertNull
import java.net.URL

class AppTest {
    @Test fun testAppRun() {
        val url = URL("https://tidalmigrations.com")
        val expectedStatus = 200
        val classUnderTest = App(url, expectedStatus)
        val exception = kotlin.runCatching {
            classUnderTest.run()
        }.exceptionOrNull()

        assertNull(exception, "Should not throw exceptions")
    }
}
