package live.bloc360.backend.service;

import live.bloc360.backend.model.UserRegistrationRecord;
import org.keycloak.representations.idm.UserRepresentation;

public interface KeycloackUserService {

    UserRegistrationRecord createUser(UserRegistrationRecord record);
    UserRepresentation getUserById(String userId);
}
