package live.block360.backend.controller;

import live.block360.backend.Service.AnafService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
@RequiredArgsConstructor
@CrossOrigin
public class CompanyInfoController {
   @Autowired
   private final AnafService anafService;

   @PostMapping("/createCompany")
    public ResponseEntity<String> createCompany(@RequestBody String jsonBody) {
       try{
           anafService.makeAnafRequest(jsonBody);
           return ResponseEntity.ok("Company Info Created");
       }catch (Exception e){
           return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
       }
   }
}
