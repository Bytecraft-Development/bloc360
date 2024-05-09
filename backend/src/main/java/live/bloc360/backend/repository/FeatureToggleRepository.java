package live.bloc360.backend.repository;

import live.bloc360.backend.model.FeatureToggle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeatureToggleRepository extends JpaRepository<FeatureToggle, Integer> {
    FeatureToggle findByName(String name);
}
