package frontend;



import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class AbstractFrontendTest {

    protected static WebDriver driver = new ChromeDriver();


    @BeforeAll
    public static void setUp() {
        // Set up WebDriver
        System.setProperty("webdriver.chrome.driver", "G:\\IntelliJ Workspace\\Chromedriver\\chromedriver.exe");
        driver = new ChromeDriver();
    }


    @AfterAll
    public static void tearDown() {
        // Close the WebDriver
        if (driver != null) {
            driver.quit();
        }
    }
}
