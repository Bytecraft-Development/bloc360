package live.bloc360.backend.dto.createDTO;


import jakarta.validation.constraints.NotEmpty;
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
    @NotEmpty(message = "Name can not be null")
    private String name;
    private String adminUsername;
}