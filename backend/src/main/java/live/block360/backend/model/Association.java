package live.block360.backend.model;

import jakarta.persistence.*;
import live.block360.backend.dto.AssociationDTO;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "association")
public class Association {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    public AssociationDTO convertToDTO() {
        return AssociationDTO.
                builder().
                id(getId()).
                name(getName()).
                build();
    }

}
