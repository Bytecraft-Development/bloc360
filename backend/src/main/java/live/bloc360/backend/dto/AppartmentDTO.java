package live.bloc360.backend.dto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AppartmentDTO {
    private String appartmentNumber;
    private Integer stairId;
}
