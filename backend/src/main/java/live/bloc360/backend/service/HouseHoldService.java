package live.bloc360.backend.service;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.repository.HouseHoldRepository;
import org.springframework.stereotype.Service;

@Service
public class HouseHoldService {

    private HouseHoldRepository houseHoldRepository;

    public HouseHold saveHouseHold(HouseHold houseHold) {
        return houseHoldRepository.save(houseHold);
    }
}
