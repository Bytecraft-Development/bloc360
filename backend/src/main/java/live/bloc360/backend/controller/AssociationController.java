package live.bloc360.backend.controller;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.service.AssociationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.security.oauth2.jwt.Jwt;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
@CrossOrigin
public class AssociationController {

private final AssociationService associationService;

  @PostMapping("/createAssociation")
    public ResponseEntity<String> createAssociation(@RequestBody CreateAssociationDTO createAssociationDTO, Authentication authentication) {
     try{
          Jwt tokenColect = (Jwt) authentication.getCredentials();
          String adminUsername = (String) tokenColect.getClaims().get("preferred_username");
         createAssociationDTO.setAdminUsername(adminUsername);
         associationService.createAssociation(createAssociationDTO,adminUsername);
         return ResponseEntity.ok("Association created");
     }catch (Exception e){
         return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Association creation failed");
     }
  }


}
