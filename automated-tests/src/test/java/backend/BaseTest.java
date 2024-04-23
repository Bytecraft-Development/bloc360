package backend;



import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.http.HttpClient;

public class BaseTest {

    protected final HttpClient client = HttpClient.newHttpClient();
    protected final ObjectMapper mapper = new ObjectMapper();


}
