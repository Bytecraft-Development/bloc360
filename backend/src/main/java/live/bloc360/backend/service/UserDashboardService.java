package live.bloc360.backend.service;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.model.Payment;
import live.bloc360.backend.repository.HouseHoldRepository;
import live.bloc360.backend.repository.PaymentRepository;
import live.bloc360.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/*@Service
public class UserDashboardService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private HouseHoldRepository houseHoldRepository;

    @Autowired
    private UserRepository userRepository;

    public BigDecimal getTotalPaymentAmount(UUID userId) {
        Optional<HouseHold> houseHoldOpt = houseHoldRepository.findByUser_Uuid(userId);


        if (!houseHoldOpt.isPresent()) {
            return BigDecimal.ZERO;
        }

        HouseHold houseHold = houseHoldOpt.get();

        List<Payment> payments = paymentRepository.findByHouseHoldId(houseHold.getId());
        System.out.println("aici e id-ul lui household" + houseHold.getId());
        return payments.stream()
                .map(Payment::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}*/

 /*   public int getNumberOfPeopleInHouseHold(UUID userId) {
        Optional<HouseHold> houseHoldOpt = houseHoldRepository.findByUser_Uuid(userId);
        if (!houseHoldOpt.isPresent()) {
            return 0;
        }
        HouseHold houseHold = houseHoldOpt.get();
        return houseHold.getNumberOfHouseHoldMembers();
    }
}*/

   /* public List<PaymentHistoryDTO> getPaymentHistory(String userId) {
        HouseHold houseHold = houseHoldRepository.findByUserId(userId);
        if (houseHold == null) {
            return List.of();
        }

        List<Payment> payments = paymentRepository.findByHouseHoldId(houseHold.getId());
        return payments.stream()
                .map(payment -> new PaymentHistoryDTO(payment.getId(), payment.getValue(), payment.getDueDate(), payment.isPaid()))
                .toList();
    }*/
