package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name="adress")
public class Adress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String country;
    private String county;
    private String city;
    private String postalCode;
    private String streetName;
    private String streetNumber;
    private String blockFlat;
    private String extraDetails;
}
