package live.bloc360.backend.dto;

import live.bloc360.backend.model.StairAssociation;
import lombok.*;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AssociationDTO {

    private String name;

    private String adress;

    private String cui;

    private String registerComert;

    private String bankAccount;

    private String bankName;

    private List<StairAssociationDTO> scari;

    private boolean apaRece;
    private boolean apaCalda;
    private boolean gaz;
    private boolean incalzire;

    private Date indexDate;

    private String adminUsername;


}