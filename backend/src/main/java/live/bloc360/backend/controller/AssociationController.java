package live.bloc360.backend.controller;

import live.bloc360.backend.exceptions.BusinessException;
import live.bloc360.backend.model.*;
import live.bloc360.backend.repository.AssociationRepository;
import live.bloc360.backend.repository.BlockRepository;
import live.bloc360.backend.service.AssociationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@CrossOrigin
public class AssociationController {

    @Autowired
    private final AssociationService associationService;

    @Autowired
    private final AssociationRepository associationRepository;

    @Autowired
    private final BlockRepository blockRepository;

    @PostMapping("/createAssociation")
    public ResponseEntity<Map<String, Object>> createAssociation(@RequestBody Association createAssociationDTO, Authentication authentication) {
        try {
            Jwt tokenColect = (Jwt) authentication.getCredentials();
            String adminUsername = (String) tokenColect.getClaims().get("preferred_username");
            Association createdAssociation = associationService.createAssociation(createAssociationDTO, adminUsername);

            Map<String, Object> response = new HashMap<>();
            response.put("associationId", createdAssociation.getId());
            response.put("message", "Association created");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("message", "Association creation failed"));
        }
    }

    @PostMapping("/addBlocks")
    public ResponseEntity<String> addBlocks(@RequestParam Integer associationId, @RequestBody List<Map<String, String>> blockData) {

        List<Block> blocks = blockData.stream()
                .map(data -> {
                    Block block = new Block();
                    block.setName(data.get("name"));
                    return block;
                })
                .collect(Collectors.toList());

        try {
            associationService.addBlocksToAssociation(associationId, blocks);
            return ResponseEntity.status(HttpStatus.CREATED).body("Blocks added successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add blocks");
        }
    }

    @PostMapping("/addHouse")
    public ResponseEntity<String> addHouseToAssociation(@RequestParam Integer associationId, @RequestBody List<Map<String, String>> houseData) {
       List<House> houses = houseData.stream().map(data-> {
           House house = new House();
           house.setName(data.get("name"));
           return house;
       }).collect(Collectors.toList());

        try {
            associationService.addHouseToAssociation(associationId, houses);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (BusinessException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/addStair")
    public ResponseEntity<String> addStairToBlock(@RequestParam Integer blockId, @RequestBody List<Map<String, String>> stairData) {
        List<Stair> stairs = stairData.stream()
                .map(data -> {
                    Stair stair = new Stair();
                    stair.setName(data.get("name"));
                    return stair;
                })
                .collect(Collectors.toList());

        try {
            associationService.addStairToBlock(blockId, stairs);
            return ResponseEntity.status(HttpStatus.CREATED).body("Stairs added successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add stairs");
        }
    }

    @PostMapping("/addHouseHoldToStair")
    public ResponseEntity<Void> addHouseHoldToStair(@RequestParam Integer stairId, @RequestBody HouseHold houseHold) {
        try {
            associationService.addHouseHoldToStair(stairId, houseHold);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (BusinessException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/addHouseHoldToHouse")
    public ResponseEntity<Void> addHouseHoldToHouse(@RequestParam Integer houseId, @RequestBody HouseHold houseHold) {
        try {
            associationService.addHouseHoldToHouse(houseId, houseHold);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (BusinessException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    @GetMapping("/blocks")
    public ResponseEntity<List<Block>> getBlocksForAssociation(@RequestParam Integer associationId) {
        List<Block> blocks = associationService.getBlocksForAssociation(associationId);
        return ResponseEntity.ok(blocks);
    }

    @GetMapping("/association")
    public ResponseEntity<Association> getAssociation(Authentication authentication) {
        Jwt token = (Jwt) authentication.getCredentials();
        String adminUsername = (String) token.getClaims().get("preferred_username");
        Optional<Association> association = associationService.findByAdminUsername(adminUsername);
        if (!association.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(association.get());
    }


}





