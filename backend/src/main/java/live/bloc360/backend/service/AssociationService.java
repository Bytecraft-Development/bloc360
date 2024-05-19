package live.bloc360.backend.service;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.model.Association;

import java.util.Optional;

public interface AssociationService {
    Association createAssociation(CreateAssociationDTO createAssociationDTO, String adminUsername);
    Optional<Association> findByAdminUsername(String adminUsername);
}