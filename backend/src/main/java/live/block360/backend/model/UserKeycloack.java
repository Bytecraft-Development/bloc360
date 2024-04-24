package live.block360.backend.model;

import lombok.*;

@Data
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserKeycloack {
  private String username;
  private String email;
  private String firstName;
  private String lastName;
  private String password;


}
