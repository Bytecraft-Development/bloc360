package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "meterReading")
public class MeterReading {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate readingDate;

    private Long index;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "meter_id")
    private Meter meter;

    public MeterReading(LocalDate readingDate, Long index) {
        this.readingDate = readingDate;
        this.index = index;
    }


    @Override
    public String toString() {
        return "MeterReading{" +
                "readingDate=" + readingDate +
                ", index=" + index +
                '}';
    }
}
