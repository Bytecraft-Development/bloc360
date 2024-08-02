package live.bloc360.backend.service;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.model.User;
import live.bloc360.backend.repository.HouseHoldRepository;
import live.bloc360.backend.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class HouseHoldService {

    @Autowired
    private HouseHoldRepository houseHoldRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private KeyCloakUserServiceImpl keyCloakUserServiceImpl;

   /* @Transactional
    public HouseHold saveHouseHold(HouseHold houseHold) {
        List<UserRepresentation> users = keyCloakUserServiceImpl.getAllUsers();
        if (!users.isEmpty()) {
            UserRepresentation keycloakUser = users.get(0);
            User user = mapToUserEntity(keycloakUser);
            User existingUser = userRepository.findByUuid(UUID.fromString(String.valueOf(user.getUuid())));
            if (existingUser == null) {
                user = userRepository.save(user);
            } else {
                user = existingUser;
            }
            houseHold.setUser(user);
        }
        return houseHoldRepository.save(houseHold);
    }*/

    private User mapToUserEntity(UserRepresentation keycloakUser) {
        User user = new User();
        user.setUuid(UUID.fromString(keycloakUser.getId()));
        System.out.println("aici e UUID" + user.getUuid());
        user.setUserName(keycloakUser.getUsername());
        return user;
    }
}



