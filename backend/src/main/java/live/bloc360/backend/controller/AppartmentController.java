package live.bloc360.backend.controller;

import live.bloc360.backend.dto.AppartmentDTO;
import live.bloc360.backend.model.Appartment;
import live.bloc360.backend.service.AppartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@Controller
@CrossOrigin
public class AppartmentController {

    @Autowired
    private final AppartmentService appartmentService;

    public AppartmentController(AppartmentService appartmentService) {
        this.appartmentService = appartmentService;
    }

    @PostMapping("/create")
    public ResponseEntity<List<Appartment>> createAppartments(@RequestBody List<AppartmentDTO> appartmentRequests) {
        List<Appartment> createdAppartments = appartmentService.createAppartments(appartmentRequests);
        return ResponseEntity.ok(createdAppartments);
    }

    @GetMapping("/available")
    public ResponseEntity<List<Appartment>> getAvailableAppartments() {
        List<Appartment> availableAppartments = appartmentService.getAvailableAppartments();
        return ResponseEntity.ok(availableAppartments);
    }
}