package backend.HelloWorldTests;

import backend.BaseTest;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static Utils.Constants.BASE_URL;
import static Utils.Constants.HELLO_ENDPOINT;
import static org.junit.jupiter.api.Assertions.*;


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
        assertEquals("Hello 16 aprilie 2024", response.body());
    }
}