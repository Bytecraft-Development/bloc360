package live.block360.backend.Service;

import jakarta.ws.rs.core.Response;
import live.block360.backend.Repository.FeatureToggleRepository;
import live.block360.backend.model.FeatureToggle;
import live.block360.backend.model.UserRegistrationRecord;
import lombok.RequiredArgsConstructor;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service

public class KeyCloackUserServiceImpl implements KeycloackUserService {

    private final FeatureToggleRepository featureToggleRepository;
    private String realm="bloc360";

   private Keycloak keycloak;

    public KeyCloackUserServiceImpl(FeatureToggleRepository featureToggleRepository, Keycloak keycloak) {
        this.featureToggleRepository = featureToggleRepository;
        this.keycloak=keycloak;
    }

    @Override
    public UserRegistrationRecord createUser(UserRegistrationRecord record) {
        FeatureToggle featureToggle = featureToggleRepository.findByName("KeyCloack Create User");
        if(featureToggle!=null &&featureToggle.isEnabled()) {
            UserRepresentation user = new UserRepresentation();
            user.setEnabled(true);
            user.setUsername(record.username());
            user.setEmail(record.email());
            user.setFirstName(record.firstName());
            user.setLastName(record.lastName());
            user.setEmailVerified(true);

            CredentialRepresentation credentialRepresentation = new CredentialRepresentation();
            credentialRepresentation.setValue(record.password());
            credentialRepresentation.setTemporary(false);
            credentialRepresentation.setType(CredentialRepresentation.PASSWORD);

            List<CredentialRepresentation> list = new ArrayList<>();
            list.add(credentialRepresentation);
            user.setCredentials(list);

            RealmResource realm1 = keycloak.realm(realm);
            UsersResource usersResource = realm1.users();
            Response response = usersResource.create(user);
            if (Objects.equals(201, response.getStatus())) {
                return record;

            }
            return null;
        }else {
            throw new RuntimeException("feature toggle is off");
        }
    }

    @Override
    public UserRepresentation getUserById(String userId) {
        return null;
    }
}
