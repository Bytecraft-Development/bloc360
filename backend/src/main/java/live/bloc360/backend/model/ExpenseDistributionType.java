package live.bloc360.backend.model;

import lombok.Getter;
import org.springframework.context.annotation.Bean;

@Getter
public enum ExpenseDistributionType {
    EQUALLY,
    BY_NUMBER_OF_PEOPLE,
    BY_SURFACE,
    BY_INDEX,
    FIXED_PERCENTAGE,
    ;

}
