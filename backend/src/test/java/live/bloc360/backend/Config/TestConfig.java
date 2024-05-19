package live.bloc360.backend.Config;

import jakarta.annotation.PostConstruct;
import live.bloc360.backend.Utils.Constants;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TestConfig {

    @Value("${baseUrl}")
    private String baseUrl;

    @PostConstruct
    public void init() {
        Constants.BASE_URL = baseUrl;
    }
}
