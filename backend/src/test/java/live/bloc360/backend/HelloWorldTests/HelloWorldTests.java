package live.bloc360.backend.HelloWorldTests;


import live.bloc360.backend.BaseTest;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static live.bloc360.backend.Utils.Constants.BASE_URL;
import static live.bloc360.backend.Utils.Constants.HELLO_ENDPOINT;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
@ActiveProfiles("test")
public class HelloWorldTests extends BaseTest {

    @Test
    public void testHelloWorld() throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + HELLO_ENDPOINT))
                .GET()
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        assertNotNull(response);
        assertEquals(200, response.statusCode());
//        assertEquals("Hello Bloc360Team", response.body());
    }
}