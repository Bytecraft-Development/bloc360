package live.bloc360.backend.repository;

import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {
   List<Payment> findByHouseHoldId(Integer houseHoldId);
}
