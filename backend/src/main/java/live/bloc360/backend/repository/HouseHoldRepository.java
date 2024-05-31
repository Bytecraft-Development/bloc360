package live.bloc360.backend.repository;

import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.HouseHold;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HouseHoldRepository extends JpaRepository<HouseHold, Integer> {

}
