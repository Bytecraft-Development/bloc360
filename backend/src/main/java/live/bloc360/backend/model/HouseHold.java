package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
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
    private Integer numberOfHouseHoldMembers;

    private Double surface;
    @OneToMany(mappedBy = "houseHold", cascade = CascadeType.ALL)
    private List<Payment> paymentList = new ArrayList<>();

    @OneToMany(mappedBy = "houseHold", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Meter> meterList = new ArrayList<>();


    public Long getMonthlyConsumption(LocalDate localDate, ConsumptionType consumptionType) {
        Long consumption = 0L;
        List<Meter> filteredMeters = meterList.stream()
                .filter(meter -> meter.getConsumptionType().equals(consumptionType))
                .toList();

        for (Meter meter : filteredMeters) {
            consumption = consumption + meter.getMonthlyReading(localDate) - meter.getMonthlyReading(localDate.minusMonths(1));
        }
        return consumption;
    }
}