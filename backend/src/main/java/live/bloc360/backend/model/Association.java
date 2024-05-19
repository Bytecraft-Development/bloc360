package live.bloc360.backend.model;

import jakarta.persistence.*;
import live.bloc360.backend.dto.AssociationDTO;
import lombok.*;


import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name="association")
public class Association {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private String adminUsername;

    @OneToOne
    private CompanyInfo companyInfo;

    @ManyToOne
    private Expense expense;

    public AssociationDTO convertToDTO() {
        return AssociationDTO.
                builder().
                id(getId()).
                name(getName()).
                build();
    }

}
