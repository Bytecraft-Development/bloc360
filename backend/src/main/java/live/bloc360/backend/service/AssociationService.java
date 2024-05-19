package live.bloc360.backend.service;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.model.Association;

public interface AssociationService {
    Association createAssociation(CreateAssociationDTO createAssociationDTO, String adminUsername);
}