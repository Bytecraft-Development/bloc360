package live.bloc360.backend.service;

import live.bloc360.backend.model.*;

import java.util.List;
import java.util.Optional;

public interface AssociationService {
    Association createAssociation(Association createAssociation, String adminUsername);
    Optional<Association> findByAdminUsername(String adminUsername);
    void addBlocksToAssociation(Integer associationId, List<Block> blocks);
    void addHouseToAssociation(Integer associationId, House house);
    void addStairToBlock(Integer blockId, List<Stair> stairs);
    void addHouseHoldToStair(Integer stairId, HouseHold houseHold);
    void addHouseHoldToHouse(Integer houseId, HouseHold houseHold);
    List<Block> getBlocksForAssociation(Integer associationId);
}