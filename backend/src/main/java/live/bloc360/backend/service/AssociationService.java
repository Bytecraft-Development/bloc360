package live.bloc360.backend.service;

import live.bloc360.backend.model.*;

import java.util.List;
import java.util.Optional;

public interface AssociationService {
    Association createAssociation(Association createAssociation, String adminUsername);
    Optional<Association> findByAdminUsername(String adminUsername);
    Optional<Association> getAssociation(Integer associationId);
    void addBlocksToAssociation(Integer associationId, List<Block> blocks);
    void addStairToBlock(Integer blockId, List<Stair> stairs);
    void addHouseHoldToStair(Integer stairId, List<HouseHold> houseHold);
    List<Block> getBlocksForAssociation(Integer associationId);
    List<HouseHold> getHouseholdsByStairId(Integer stairId);
    List<HouseHold> getHouseholdsByBlockIds(List<Integer> blockIds);
}