package live.bloc360.backend.Association;


import live.bloc360.backend.BaseTest;
import live.bloc360.backend.Utils.StringUtils;
import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static live.bloc360.backend.Utils.Constants.*;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class AssociationTests extends BaseTest {


    @Test
    public void createAssociation() throws IOException, InterruptedException {
        CreateAssociationDTO createAssociationDTO = new CreateAssociationDTO();
        createAssociationDTO.setName(QA_PREFIX + StringUtils.generateRandomString(5));
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL +  CREATE_ASSOCIATION_ENDPOINT))
                .header(CONTENT_TYPE, APPLICATION_JSON)
                .POST(HttpRequest.BodyPublishers.ofString(mapper.writeValueAsString(createAssociationDTO)))
                .build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        assertNotNull(response);
        assertEquals(200, response.statusCode());
        assertEquals("Association created", response.body());

        //TODO Verify Association was added to DB

    }

}
