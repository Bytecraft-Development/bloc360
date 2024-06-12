package live.bloc360.backend.service;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.model.FeatureToggle;
import live.bloc360.backend.model.StairAssociation;
import live.bloc360.backend.repository.FeatureToggleRepository;
import live.bloc360.backend.repository.AssociationRepository;
import live.bloc360.backend.exceptions.BusinessException;
import live.bloc360.backend.model.Association;
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

    @Override
    public Association createAssociation(Association createAssociation, String adminUsername) {
        if (userHasAssociation(adminUsername)) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "User already has an association");
        }
        associationRepository.findByName(createAssociation.getName()).ifPresent(association -> {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "Association already exists");
        });

        // Initialize the association without stairs
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

          association = associationRepository.save(association);

        for (StairAssociation stair : createAssociation.getStairs()) {
            stair.setAssociation(association);
            stairAssociationRepository.save(stair);
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
