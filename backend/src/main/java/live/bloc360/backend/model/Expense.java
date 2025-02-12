package live.bloc360.backend.model;


import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class Expense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String provider;
    private String serialNumber;
    private BigDecimal amount;

    @Enumerated(EnumType.ORDINAL)
    private ConsumptionType consumptionType;

    @Temporal(TemporalType.DATE)
    private Date documentDate;

    @Temporal(TemporalType.TIMESTAMP)
    private Date dueDate;

    private String description;
    private String reference;
    private boolean repeatable;

    @ManyToMany
    @JoinTable(
            name = "expense_household",
            joinColumns = @JoinColumn(name = "expense_id"),
            inverseJoinColumns = @JoinColumn(name = "household_id")
    )
    private List<HouseHold> houseHoldList = new ArrayList<>();

    @OneToMany(mappedBy = "expense", cascade = CascadeType.ALL)
    private List<Payment> paymentList = new ArrayList<>();
}
