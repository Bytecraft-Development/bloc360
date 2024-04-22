package live.block360.backend.Service;


import live.block360.backend.Repository.CompanyInfoRepository;
import live.block360.backend.model.CompanyInfo;
import lombok.RequiredArgsConstructor;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;



@Service
@RequiredArgsConstructor
public class AnafServiceImpl implements AnafService {

    private final CompanyInfoRepository companyInfoRepository;

    @Override
    public void makeAnafRequest(String cui) {
        String url = "https://facturacloud.ro/app/index.php?section=apianaf";
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String formattedDate = dateFormat.format(date);
        String json = "[{\"cui\": " + cui + ", \"data\": \"" + formattedDate + "\"}]";
        // Utilizarea stringului JSON în cererea HTTP sau în alte scopuri
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost request = new HttpPost(url);

        try {
            // Setarea corpului cererii ca un StringEntity cu tipul "application/json"
            StringEntity stringEntity = new StringEntity(json, ContentType.APPLICATION_JSON);
            request.setEntity(stringEntity);

            // Executarea cererii și obținerea răspunsului
            HttpResponse response = httpClient.execute(request);

            // Citirea răspunsului
            BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }
            result.toString();
            // Afișarea răspunsului
            result.toString();

            // Închiderea clientului HTTP
            httpClient.close();

            // Parcurgerea răspunsului și parsarea datelor
            parseResponse(result.toString());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private void parseResponse(String response) {
           try {

                // pe viitor user-ul creat sau logat logica pentru a fii creaat deja pe entitatea de company info//
               CompanyInfo companyInfo = new CompanyInfo();

               // Parsarea răspunsului JSON
               ObjectMapper objectMapper = new ObjectMapper();
               JsonNode jsonNode = objectMapper.readTree(response);

               // Obținerea valorilor din răspuns și salvarea lor în variabile
               int cod = jsonNode.get("cod").asInt();
               String message = jsonNode.get("message").asText();


               // Accesarea elementului "found" și salvarea sub-elementelor în variabile
               JsonNode foundNode = jsonNode.get("found").get(0);
               if (foundNode==null) {
                   throw new Exception("Cui Invalid");
               }
               JsonNode dateGeneraleNode = foundNode.get("date_generale");
               int cui = dateGeneraleNode.get("cui").asInt();
               String data = dateGeneraleNode.get("data").asText();
               String denumire = dateGeneraleNode.get("denumire").asText();
               String adresa = dateGeneraleNode.get("adresa").asText();
               String nrRegFiscala =dateGeneraleNode.get("nrRegCom").asText();
               String caen = dateGeneraleNode.get("cod_CAEN").asText();
               String fiscalCompany = dateGeneraleNode.get("organFiscalCompetent").asText();


               CompanyInfo company = new CompanyInfo()
                       .builder()
                       .CUI(cui)
                       .name(denumire)
                       .address(adresa)
                       .registrationFiscalNumber(nrRegFiscala)
                       .CAEN(caen)
                       .fiscalCompany(fiscalCompany)
                       .build();

               companyInfoRepository.save(company);
           } catch (Exception e) {
               e.printStackTrace();
           }
       }




    }



