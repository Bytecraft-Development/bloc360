package live.bloc360.backend.repository;

import live.bloc360.backend.model.Association;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AssociationRepository extends JpaRepository<Association, Integer> {

    Optional<Association> findByName(String name);
    Optional<Association> findByAdminUsername(String adminUsername);

}
