package live.bloc360.backend.model;


import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.Date;


@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Expense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String type;
    private boolean consumable;
    private boolean repeatable;
    private boolean distribute;
    private String serialNumber;

    @Temporal(TemporalType.DATE)
    private Date documentDate;

    @Temporal(TemporalType.TIMESTAMP)
    private Date dueDate;

    private BigDecimal amount;
    private String description;
    private String reference;
    @OneToOne
    @JoinColumn(name = "payment_id")
    private Payment payment;

}
