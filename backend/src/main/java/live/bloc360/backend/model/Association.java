package live.bloc360.backend.model;

import jakarta.persistence.*;
import live.bloc360.backend.dto.AssociationDTO;
import live.bloc360.backend.dto.StairAssociationDTO;
import lombok.*;


import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name="association")
public class Association {
   //Creaza asociatia
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    private String adress;

    private String cui;

    private String registerComert;

    private String bankAccount;

    private String bankName;
    //Scari
    @OneToMany(mappedBy = "association", cascade = CascadeType.ALL,fetch = FetchType.EAGER)
    private List<StairAssociation> stairs;

    @OneToMany(mappedBy = "association", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    private List<HouseHold> households;

    //Citire index

    private boolean coldWater;
    private boolean hotWater;
    private boolean gas;
    private boolean heating;

    //Zi emitere Facturi
    @Temporal(TemporalType.DATE)
    private Date indexDate;


    private String adminUsername;

    public AssociationDTO convertToDTO() {
     List<StairAssociationDTO> stairDTOs = stairs.stream()
             .map(stair -> StairAssociationDTO.builder()
                     .id(stair.getId())
                     .name(stair.getName())
                     .build())
             .collect(Collectors.toList());


     return AssociationDTO.
                builder().
                name(getName()).
                adress(getAdress()).
                cui(getCui()).
                registerComert(getRegisterComert()).
                bankAccount(getBankAccount()).
                bankName(getBankName()).
                stairs(stairDTOs).
                houseHolds(getHouseholds()).
                coldWater(isColdWater()).
                hotWater(isHotWater()).
                gas(isGas()).
                heating(isHeating()).
                indexDate(getIndexDate()).
                adminUsername(getAdminUsername()).
                build();
    }
}
