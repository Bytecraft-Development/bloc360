package live.bloc360.backend.controller;

import jakarta.validation.Valid;
import live.bloc360.backend.model.Payment;
import live.bloc360.backend.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping("/createPayment")
    public ResponseEntity<Payment> createPayment(@Valid @RequestBody Payment payment) {
        try {
            Payment createdPayment = paymentService.createPayment(payment);
            return new ResponseEntity<>(createdPayment, HttpStatus.CREATED);
        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}