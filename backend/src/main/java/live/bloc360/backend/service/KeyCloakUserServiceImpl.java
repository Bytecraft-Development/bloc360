package live.bloc360.backend.service;

import live.bloc360.backend.model.*;
import live.bloc360.backend.repository.AppartmentRepository;
import live.bloc360.backend.repository.FeatureToggleRepository;
import live.bloc360.backend.repository.HouseHoldRepository;
import live.bloc360.backend.repository.StairRepository;
import lombok.RequiredArgsConstructor;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class KeyCloakUserServiceImpl implements KeycloackUserService {

    private final FeatureToggleRepository featureToggleRepository;
    private final Keycloak keycloak;
    private final StairRepository stairRepository;
    private final AppartmentRepository appartmentRepository;
    private final HouseHoldRepository houseHoldRepository;

    @Value("${keycloak.realm}")
    private String realm;

    @Value("${default.group.users}")
    private String defaultGroupUsers;

    @Value("${default.group.admin}")
    private String defaultGroupAdmins;

    @Override
    public UserRegistrationRecord createUser(UserRegistrationRecord userRegistrationRecord) {
        FeatureToggle featureToggle = featureToggleRepository.findByName("KeyCloak Create User");
        if (featureToggle == null || !featureToggle.isEnabled()) {
            throw new RuntimeException("feature toggle KeyCloak Create User is off");
        }

        UserRepresentation user = new UserRepresentation();
        user.setEnabled(true);
        user.setUsername(userRegistrationRecord.username());
        user.setEmail(userRegistrationRecord.email());
        user.setFirstName(userRegistrationRecord.firstName());
        user.setLastName(userRegistrationRecord.lastName());
        user.setGroups(List.of(defaultGroupUsers));
        user.setEmailVerified(true);

        CredentialRepresentation credentialRepresentation = new CredentialRepresentation();
        credentialRepresentation.setValue(userRegistrationRecord.password());
        credentialRepresentation.setTemporary(false);
        credentialRepresentation.setType(CredentialRepresentation.PASSWORD);

        List<CredentialRepresentation> list = new ArrayList<>();
        list.add(credentialRepresentation);
        user.setCredentials(list);
        UsersResource usersResource = getUsersResource();
        usersResource.create(user);
        return userRegistrationRecord;

    }

    public UserRegistrationRecord createHouseHoldUser(UserRegistrationRecord userRegistrationRecord) {
        UserRepresentation user = new UserRepresentation();
        user.setEnabled(true);
        user.setUsername(userRegistrationRecord.username());
        user.setEmail(userRegistrationRecord.email());
        user.setFirstName(userRegistrationRecord.firstName());
        user.setLastName(userRegistrationRecord.lastName());
        user.setGroups(List.of(defaultGroupUsers));
        user.setEmailVerified(true);

        CredentialRepresentation credentialRepresentation = new CredentialRepresentation();
        credentialRepresentation.setValue(userRegistrationRecord.password());
        credentialRepresentation.setTemporary(false);
        credentialRepresentation.setType(CredentialRepresentation.PASSWORD);
        user.setCredentials(List.of(credentialRepresentation));

        UsersResource usersResource = getUsersResource();
        usersResource.create(user);

        Integer associationId = userRegistrationRecord.associationId();
        String appartmentNumber = userRegistrationRecord.appartmentNumber();

        List<Stair> stairs = stairRepository.findByBlock_Association_Id(associationId);

        Appartment appartment = stairs.stream()
                .flatMap(stair -> appartmentRepository.findByStairAndAppartmentNumber(stair, appartmentNumber).stream())
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Apartamentul nu a fost găsit."));

        HouseHold household = HouseHold.builder()
                .apartmentNumber(appartment.getAppartmentNumber())
                .stair(appartment.getStair())
                .appartment(appartment)
                .userId(userRegistrationRecord.username())
                .build();
        houseHoldRepository.save(household);

        appartment.setHouseHold(household);
        appartmentRepository.save(appartment);

        return userRegistrationRecord;
    }

    public UsersResource getUsersResource() {
        RealmResource realm1 = keycloak.realm(realm);
        return realm1.users();
    }

    @Override
    public UserRepresentation getUserById(String userId) {
        return getUsersResource().get(userId).toRepresentation();
    }

    public List<UserRepresentation> getAllUsers() {
        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();
        return usersResource.list();
    }

}









