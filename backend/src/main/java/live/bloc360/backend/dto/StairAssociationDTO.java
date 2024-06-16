package live.bloc360.backend.dto;

import live.bloc360.backend.model.HouseHold;
import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class StairAssociationDTO {
    private Integer id;
    private String name;
    private List<HouseHoldDTO> households;
}