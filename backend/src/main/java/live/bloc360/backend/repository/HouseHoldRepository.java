package live.bloc360.backend.repository;

import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.HouseHold;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface HouseHoldRepository extends JpaRepository<HouseHold, Integer> {
    /*Optional<HouseHold> findByUser_Uuid(UUID userId);*/
}
