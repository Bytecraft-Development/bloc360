package live.bloc360.backend.repository;

import live.bloc360.backend.model.ExpenseModule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ExpenseModuleRepository extends JpaRepository<ExpenseModule, Integer> {
}
