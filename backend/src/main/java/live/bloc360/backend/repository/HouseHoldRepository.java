package live.bloc360.backend.repository;


import live.bloc360.backend.model.HouseHold;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HouseHoldRepository extends JpaRepository<HouseHold, Integer> {
    List<HouseHold> findByStairId(Integer stairId);

}
