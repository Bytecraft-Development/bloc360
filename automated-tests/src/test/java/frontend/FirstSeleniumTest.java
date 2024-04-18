package frontend;

import Pages.CommonPage;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;



public class FirstSeleniumTest extends AbstractFrontendTest{

    public static String homepageUrl = "https://bloc360.live/";

    @Test
    public void seleniumTest() {
        driver.get(homepageUrl);
        CommonPage commonPage = new CommonPage(driver);
        Assertions.assertNotNull(commonPage);

    }
}
