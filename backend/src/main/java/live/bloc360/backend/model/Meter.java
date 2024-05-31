package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name="meter")
public class Meter {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Long serialNumber;

    @Temporal(TemporalType.TIMESTAMP)
    private Date indexDate;

    @ElementCollection
    private Map<Long, Date> indexLog = new HashMap<Long, Date>();
    @ManyToOne
    private HouseHold houseHold;

}
