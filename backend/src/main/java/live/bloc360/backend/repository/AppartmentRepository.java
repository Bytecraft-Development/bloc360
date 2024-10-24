package live.bloc360.backend.repository;

import live.bloc360.backend.model.Appartment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AppartmentRepository extends JpaRepository<Appartment, Integer> {
    List<Appartment> findByHouseHoldIsNull();
}
