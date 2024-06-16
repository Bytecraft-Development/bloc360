package live.bloc360.backend.service;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.model.FeatureToggle;
import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.model.StairAssociation;
import live.bloc360.backend.repository.FeatureToggleRepository;
import live.bloc360.backend.repository.AssociationRepository;
import live.bloc360.backend.exceptions.BusinessException;
import live.bloc360.backend.model.Association;
import live.bloc360.backend.repository.HouseHoldRepository;
import live.bloc360.backend.repository.StairAssociationRepository;
import lombok.RequiredArgsConstructor;
import org.keycloak.admin.client.resource.UsersResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.keycloak.representations.idm.UserRepresentation;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AssociationServiceImpl implements AssociationService {

    private final AssociationRepository associationRepository;
    private final FeatureToggleRepository featureToggleRepository;
    private final KeyCloakUserServiceImpl keyCloakUserServiceImpl;
    private final StairAssociationRepository stairAssociationRepository;
    private final HouseHoldRepository houseHoldRepository;

    @Override
    public Association createAssociation(Association createAssociation, String adminUsername) {
        if (userHasAssociation(adminUsername)) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "User already has an association");
        }
        associationRepository.findByName(createAssociation.getName()).ifPresent(association -> {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "Association already exists");
        });

        Association association = Association.builder()
                .name(createAssociation.getName())
                .adress(createAssociation.getAdress())
                .cui(createAssociation.getCui())
                .registerComert(createAssociation.getRegisterComert())
                .bankAccount(createAssociation.getBankAccount())
                .bankName(createAssociation.getBankName())
                .coldWater(createAssociation.isColdWater())
                .hotWater(createAssociation.isHotWater())
                .gas(createAssociation.isGas())
                .heating(createAssociation.isHeating())
                .indexDate(createAssociation.getIndexDate())
                .adminUsername(adminUsername)
                .build();

        // Save the association first
        association = associationRepository.save(association);

        // Save standalone households
        List<HouseHold> households = createAssociation.getHouseholds();
        if (households != null) {
            for (HouseHold houseHold : households) {
                houseHold.setAssociation(association);
                houseHoldRepository.save(houseHold);
            }
        }

        // Save stairs and their households
        List<StairAssociation> stairs = createAssociation.getStairs();
        if (stairs != null) {
            for (StairAssociation stair : stairs) {
                stair.setAssociation(association);
                stair = stairAssociationRepository.save(stair);

                List<HouseHold> stairHouseholds = stair.getHouseholds();
                if (stairHouseholds != null) {
                    for (HouseHold houseHold : stairHouseholds) {
                        houseHold.setAssociation(association);
                        houseHold.setStair(stair);
                        houseHoldRepository.save(houseHold);
                    }
                }
            }
        }

        return association;
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
