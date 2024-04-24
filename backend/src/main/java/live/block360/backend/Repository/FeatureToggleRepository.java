package live.block360.backend.Repository;

import live.block360.backend.model.CompanyInfo;
import live.block360.backend.model.FeatureToggle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeatureToggleRepository extends JpaRepository<FeatureToggle, Integer> {
    FeatureToggle findByName(String name);
}
