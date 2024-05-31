package live.bloc360.backend.controller;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.service.HouseHoldService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/households")
public class HouseHoldController {

    private HouseHoldService houseHoldService;

    @PostMapping("/create")
    public HouseHold createHouseHold(@RequestBody HouseHold houseHold) {
        return houseHoldService.saveHouseHold(houseHold);
    }
}