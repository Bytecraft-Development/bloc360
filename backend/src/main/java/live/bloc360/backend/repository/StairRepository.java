package live.bloc360.backend.repository;

import live.bloc360.backend.model.Stair;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface StairRepository extends JpaRepository<Stair, Integer> {
    List<Stair> findByBlock_Association_Id(Integer associationId);
    List<Stair> findByBlockId(Integer blockId);
}
