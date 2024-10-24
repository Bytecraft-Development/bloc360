package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "household")
public class HouseHold {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String appartmentNumber;

    @ManyToOne
    @JoinColumn(name = "stair_id")
    private Stair stair;

    @ManyToOne
    @JoinColumn(name = "house_id")
    private House house;
}