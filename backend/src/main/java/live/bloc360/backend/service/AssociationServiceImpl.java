package live.bloc360.backend.service;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.model.FeatureToggle;
import live.bloc360.backend.repository.FeatureToggleRepository;
import live.bloc360.backend.repository.AssociationRepository;
import live.bloc360.backend.exceptions.BusinessException;
import live.bloc360.backend.model.Association;
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

    @Override
    public Association createAssociation(CreateAssociationDTO createAssociationDTO,String adminUsername) {
        FeatureToggle featureToggle = featureToggleRepository.findByName("Association Create");
//        if (featureToggle == null || !featureToggle.isEnabled()) {
//            throw new RuntimeException("Feature Toggle is not enable");
//        }

        if (userHasAssociation(adminUsername)) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "User already has an association");
        }
        associationRepository.findByName(createAssociationDTO.getName()).ifPresent(association -> {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "Association already exists");
        });
        Association association = Association
                .builder()
                .name(createAssociationDTO.getName())
                .adminUsername(adminUsername)
                .build();
        return associationRepository.save(association);
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
