package live.bloc360.backend.service;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.model.Payment;
import live.bloc360.backend.repository.HouseHoldRepository;
import live.bloc360.backend.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private HouseHoldRepository houseHoldRepository;

    @Transactional
    public Payment createPayment(Payment payment) {
        Optional<HouseHold> optionalHouseHold = houseHoldRepository.findById(payment.getHouseHold().getId());
        if (optionalHouseHold.isEmpty()) {
            throw new IllegalArgumentException("HouseHold not found");
        }

        payment.setHouseHold(optionalHouseHold.get());

        return paymentRepository.save(payment);
    }

}