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
@Table(name="household")
public class HouseHold {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    public enum Type {
        HOUSE, APARTMENT, OTHER
    }

    @Enumerated(EnumType.STRING)
    private Type type;

    @ManyToOne
    @JoinColumn(name = "association_id")
    private Association association;

    @ManyToOne
    @JoinColumn(name = "stair_id")
    private StairAssociation stair;

    private Integer numberOfHouseHoldMembers;

    private Double surface;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "houseHold", cascade = CascadeType.ALL)
    private List<Payment> paymentList = new ArrayList<>();

}
