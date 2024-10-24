package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "appartment")
public class Appartment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String appartmentNumber;

    @ManyToOne
    @JoinColumn(name = "stair_id")
    private Stair stair;

    @OneToOne
    @JoinColumn(name = "household_id")
    private HouseHold houseHold;


}
