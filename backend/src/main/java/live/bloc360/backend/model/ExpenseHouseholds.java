package live.bloc360.backend.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "expense_household")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExpenseHouseholds {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private BigDecimal percentage;


    @ManyToOne
    @JoinColumn(name = "expense_id")
    @JsonBackReference
    private Expense expense;


    @ManyToOne
    @JoinColumn(name = "household_id")
    private HouseHold houseHold;
}
