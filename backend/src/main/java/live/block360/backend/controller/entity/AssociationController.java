package live.block360.backend.controller.entity;

import live.block360.backend.Service.ServiceInterface.AssociationService;
import live.block360.backend.dto.createDTO.CreateAssociationDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
@RequiredArgsConstructor
@CrossOrigin
public class AssociationController {

private final AssociationService associationService;

  @PostMapping("/createAssociation")
    public ResponseEntity<String> createAssociation(@RequestBody CreateAssociationDTO createAssociationDTO) {
     try{
         associationService.createAssociation(createAssociationDTO);
         return ResponseEntity.ok("Association created");
     }catch (Exception e){
         return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Association creation failed");
     }
  }


}
