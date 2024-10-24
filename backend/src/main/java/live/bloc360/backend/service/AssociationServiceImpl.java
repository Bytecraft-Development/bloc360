package live.bloc360.backend.service;

import jakarta.transaction.Transactional;
import live.bloc360.backend.model.*;
import live.bloc360.backend.repository.*;
import live.bloc360.backend.exceptions.BusinessException;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.keycloak.admin.client.resource.UsersResource;
import org.springframework.http.HttpStatus;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;
import org.keycloak.representations.idm.UserRepresentation;


import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AssociationServiceImpl implements AssociationService {

    private final AssociationRepository associationRepository;
    private final BlockRepository blockRepository;
    private final HouseRepository houseRepository;
    private final StairRepository stairRepository;
    private final HouseHoldRepository houseHoldRepository;
    private final KeyCloakUserServiceImpl keyCloakUserServiceImpl;

    @Transactional
    public Association createAssociation(Association createAssociation, String adminUsername) {
       if (userHasAssociation(adminUsername)) {
           throw new BusinessException(HttpStatus.BAD_REQUEST, "User already has an association");
        }

        if (associationRepository.findByName(createAssociation.getName()).isPresent()) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "Association already exists");
        }

        Association association = Association.builder()
                .name(createAssociation.getName())
                .address(createAssociation.getAddress())
                .cui(createAssociation.getCui())
                .registerComert(createAssociation.getRegisterComert())
                .bankAccount(createAssociation.getBankAccount())
                .bankName(createAssociation.getBankName())
                .coldWater(createAssociation.isColdWater())
                .hotWater(createAssociation.isHotWater())
                .gas(createAssociation.isGas())
                .heating(createAssociation.isHeating())
                .indexDate(createAssociation.getIndexDate())
                .hasBlocks(createAssociation.isHasBlocks())
                .hasHouses(createAssociation.isHasHouses())
                .adminUsername(adminUsername)
                .build();

        Association savedAssociation = associationRepository.save(association);


        return savedAssociation;
    }

    @Transactional
    public Optional<Association> getAssociation(Integer associationId) {
        Optional<Association> association = associationRepository.findById(associationId);
        return association;
    }



    @Transactional
    public void addBlocksToAssociation(Integer associationId, List<Block> blocks) {
        Association association = associationRepository.findById(associationId)
                .orElseThrow(() -> new BusinessException(HttpStatus.NOT_FOUND, "Association not found"));

        for (Block block : blocks) {
            block.setAssociation(association);
            blockRepository.save(block);
        }
    }

    @Transactional
    public void addHouseToAssociation(Integer associationId, List<House> houses) {
        Association association = associationRepository.findById(associationId)
                .orElseThrow(() -> new BusinessException(HttpStatus.NOT_FOUND, "Association not found"));

        for (House house : houses) {
            house.setAssociation(association);
            houseRepository.save(house);
        }
    }

    @Transactional
    public void addStairToBlock(Integer blockId, List<Stair> stairs) {
        Block block = blockRepository.findById(blockId)
                .orElseThrow(() -> new BusinessException(HttpStatus.NOT_FOUND, "Block not found"));

        for(Stair stair : stairs) {
            stair.setBlock(block);
            stairRepository.save(stair);
        }
    }

    @Transactional
    public void addHouseHoldToStair(Integer stairId, HouseHold houseHold) {
        Stair stair = stairRepository.findById(stairId)
                .orElseThrow(() -> new BusinessException(HttpStatus.NOT_FOUND, "Stair not found"));

        houseHold.setStair(stair);
        houseHoldRepository.save(houseHold);
    }

    @Transactional
    public void addHouseHoldToHouse(Integer houseId, HouseHold houseHold) {
        House house = houseRepository.findById(houseId)
                .orElseThrow(() -> new BusinessException(HttpStatus.NOT_FOUND, "House not found"));

        houseHold.setHouse(house);
        houseHoldRepository.save(houseHold);
    }
    public List<Block> getBlocksForAssociation(Integer associationId) {
        List<Block> blocks = blockRepository.findByAssociationId(associationId);
        return blocks.stream()
                .map(block -> new Block(block.getId(), block.getName()))
                .collect(Collectors.toList());
    }



    public boolean userHasAssociation(String username) {
        UsersResource usersResource = keyCloakUserServiceImpl.getUsersResource();
        List<UserRepresentation> users = usersResource.search(username);

        if (users.isEmpty()) {
            throw new RuntimeException("User not found");
        }
        return associationRepository.findByAdminUsername(username).isPresent();
    }

    public Optional<Association> findByAdminUsername(String adminUsername) {
        return associationRepository.findByAdminUsername(adminUsername);
    }
}