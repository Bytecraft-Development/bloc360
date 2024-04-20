package backend.HelloWorldTests;

import backend.BaseTest;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static org.junit.jupiter.api.Assertions.*;


public class HelloWorldTests extends BaseTest {

    private final static String BASE_URL = "https://bloc360.live:8080/hello";

    @Test
    public void testHelloWorld() throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL))
                .GET()
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        assertNotNull(response);
        assertEquals(200, response.statusCode());
        assertEquals("Hello 16 aprilie 2024", response.body());
    }
}