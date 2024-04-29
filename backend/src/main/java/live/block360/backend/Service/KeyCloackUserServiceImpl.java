package live.block360.backend.Service;

import jakarta.ws.rs.core.Response;
import live.block360.backend.Repository.FeatureToggleRepository;
import live.block360.backend.config.KeyCloakConfig;
import live.block360.backend.model.FeatureToggle;
import live.block360.backend.model.UserRegistrationRecord;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.RolesResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class KeyCloackUserServiceImpl implements KeycloackUserService {

    private final FeatureToggleRepository featureToggleRepository;
    private String realm = "bloc360";

    private Keycloak keycloak;

    private KeyCloakConfig keyCloakConfig;

    public KeyCloackUserServiceImpl(FeatureToggleRepository featureToggleRepository, Keycloak keycloak) {
        this.featureToggleRepository = featureToggleRepository;
        this.keycloak = keycloak;
    }

    @Override
    public UserRegistrationRecord createUser(UserRegistrationRecord userRegistrationRecord) {
        FeatureToggle featureToggle = featureToggleRepository.findByName("KeyCloack Create User");
        if (featureToggle != null && featureToggle.isEnabled()) {
            UserRepresentation user = new UserRepresentation();
            user.setEnabled(true);
            user.setUsername(userRegistrationRecord.username());
            user.setEmail(userRegistrationRecord.email());
            user.setFirstName(userRegistrationRecord.firstName());
            user.setLastName(userRegistrationRecord.lastName());
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

        } else {
            throw new RuntimeException("feature toggle is off");
        }
    }

        private RolesResource getRolesResource () {
            return keycloak.realm(realm).roles();
        }
        public UserResource getUserResource (String userId){
            UsersResource usersResource = getUsersResource();
            return usersResource.get(userId);
        }

        private UsersResource getUsersResource () {
            RealmResource realm1 = keycloak.realm(realm);
            return realm1.users();
        }

        @Override
        public UserRepresentation getUserById (String userId){

            return getUsersResource().get(userId).toRepresentation();
        }
}









