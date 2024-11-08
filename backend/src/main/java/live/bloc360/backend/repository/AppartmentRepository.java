package live.bloc360.backend.repository;

import live.bloc360.backend.model.Appartment;
import live.bloc360.backend.model.Stair;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AppartmentRepository extends JpaRepository<Appartment, Integer> {
    List<Appartment> findByHouseHoldIsNull();
    Optional<Appartment> findByStairAndNumber(Stair stair, String number);
}
