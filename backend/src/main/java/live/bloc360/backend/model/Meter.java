package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.*;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "meter")
public class Meter {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Long serialNumber;

    @Temporal(TemporalType.TIMESTAMP)
    private Date indexDate;
    private ConsumptionType consumptionType;
    @OneToMany(mappedBy = "meter", cascade = CascadeType.ALL)
    private List<MeterReading> meterReadings = new ArrayList<>();
    @ManyToOne
    private HouseHold houseHold;

    public Long getMonthlyReading(LocalDate queryDate) {
        Optional<MeterReading> latestReading = this.meterReadings.stream()
                .filter(meterReading -> meterReading.getReadingDate().getYear() == queryDate.getYear()
                        && meterReading.getReadingDate().getMonth() == queryDate.getMonth())
                .max((meterReading1, meterReading2) -> meterReading1.getReadingDate().getDayOfMonth() - meterReading2.getReadingDate().getDayOfMonth());

        if (latestReading.isPresent()) {
            return latestReading.get().getIndex();
        } else {
            return -1L;
        }
    }

}
