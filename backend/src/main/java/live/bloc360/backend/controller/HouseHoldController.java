package live.bloc360.backend.controller;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.service.HouseHoldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HouseHoldController {
    @Autowired
    private HouseHoldService houseHoldService;

    @PostMapping("/create")
    public ResponseEntity<HouseHold> createHouseHold(@RequestBody HouseHold houseHold) {
        try {
            HouseHold savedHouseHold = houseHoldService.saveHouseHold(houseHold);
            return new ResponseEntity<>(savedHouseHold, HttpStatus.CREATED);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}