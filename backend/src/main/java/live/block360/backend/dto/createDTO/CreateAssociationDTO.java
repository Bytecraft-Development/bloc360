package live.block360.backend.dto.createDTO;


import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CreateAssociationDTO {
    @NotNull(message = "Name can not be null")
    private String name;
}