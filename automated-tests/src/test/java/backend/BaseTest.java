package backend;




import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;

import java.io.IOException;
import java.net.http.HttpClient;
import java.net.http.HttpResponse;


public class BaseTest {

    protected final HttpClient client = HttpClient.newHttpClient();


}
