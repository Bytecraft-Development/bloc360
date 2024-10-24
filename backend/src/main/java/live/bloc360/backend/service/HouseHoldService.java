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



}









