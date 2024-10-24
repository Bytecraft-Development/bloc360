package live.bloc360.backend.service;

import live.bloc360.backend.dto.AppartmentDTO;
import live.bloc360.backend.model.Appartment;
import live.bloc360.backend.model.Stair;
import live.bloc360.backend.repository.AppartmentRepository;
import live.bloc360.backend.repository.StairRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AppartmentService {
    private final AppartmentRepository appartmentRepository;
    private final StairRepository stairRepository;

    public AppartmentService(AppartmentRepository appartmentRepository, StairRepository stairRepository) {
        this.appartmentRepository = appartmentRepository;
        this.stairRepository = stairRepository;
    }

    public List<Appartment> createAppartments(List<AppartmentDTO> appartmentRequests) {
        List<Appartment> appartments = new ArrayList<>();
        for (AppartmentDTO request : appartmentRequests) {
            Stair stair = stairRepository.findById(request.getStairId())
                    .orElseThrow(() -> new RuntimeException("Stair not found"));
            Appartment appartment = Appartment.builder()
                    .appartmentNumber(request.getAppartmentNumber())
                    .stair(stair)
                    .build();
            appartments.add(appartmentRepository.save(appartment));
        }
        return appartments;
    }

    public List<Appartment> getAvailableAppartments() {
        return appartmentRepository.findByHouseHoldIsNull();
    }

}