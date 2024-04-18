package live.block360.backend.Service;

import live.block360.backend.dto.createDTO.CreateAssociationDTO;
import live.block360.backend.model.Association;

public interface AssociationService {
    Association createAssociation(CreateAssociationDTO  createAssociationDTO);
}