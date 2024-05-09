package live.bloc360.backend.service;

import live.bloc360.backend.dto.createDTO.CreateAssociationDTO;
import live.bloc360.backend.model.FeatureToggle;
import live.bloc360.backend.repository.FeatureToggleRepository;
import live.bloc360.backend.repository.AssociationRepository;
import live.bloc360.backend.exceptions.BusinessException;
import live.bloc360.backend.model.Association;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AssociationServiceImpl implements AssociationService {

    private final AssociationRepository associationRepository;
    private final FeatureToggleRepository featureToggleRepository;
    @Override
    public Association createAssociation(CreateAssociationDTO createAssociationDTO) {
        FeatureToggle featureToggle = featureToggleRepository.findByName("Association Create");
        if (featureToggle != null && featureToggle.isEnabled()) {
            associationRepository.findByName(createAssociationDTO.getName()).ifPresent(association -> {
                throw new BusinessException(HttpStatus.BAD_REQUEST, "Association already exists");
            });
            Association association = Association
                    .builder()
                    .name(createAssociationDTO.getName())
                    .build();
            return associationRepository.save(association);
        }
        else {
            throw new RuntimeException("Feature Toggle is not enable");
        }
    }


    }
