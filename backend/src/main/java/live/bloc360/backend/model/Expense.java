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
public class Expense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String type;
    private boolean consumable;
    private boolean repeatable;
    private boolean distribute;
    private String serialNumber;
    @Enumerated(EnumType.ORDINAL)
    private ConsumptionType consumptionType;

    @Temporal(TemporalType.DATE)
    private Date documentDate;

    @Temporal(TemporalType.TIMESTAMP)
    private Date dueDate;

    private BigDecimal amount;
    private String description;
    private String reference;
    @OneToMany(mappedBy = "expense", cascade = CascadeType.ALL)
    private List<Payment> paymentList = new ArrayList<>();

}
