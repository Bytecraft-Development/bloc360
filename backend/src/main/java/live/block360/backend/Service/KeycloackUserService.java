package live.block360.backend.Service;

import live.block360.backend.model.UserRegistrationRecord;
import org.keycloak.representations.idm.UserRepresentation;

public interface KeycloackUserService {

    UserRegistrationRecord createUser(UserRegistrationRecord record);
    UserRepresentation getUserById(String userId);
}
