package live.bloc360.backend.dto;

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

    private List<StairAssociationDTO> stairs;

    private List<HouseHoldDTO> households;

    private boolean coldWater;
    private boolean hotWater;
    private boolean gas;
    private boolean heating;

    private String indexDate;

    private String adminUsername;

    private String type;

}