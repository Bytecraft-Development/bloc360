package live.bloc360.backend.model;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@Builder
@Data
public class UserDashboardDTO {

    private BigDecimal totalPaymentAmount;
    private List<PaymentHistoryDTO> paymentHistory;
    private int numberOfPeopleInHousehold;

    @Getter
    @Setter
    @Data
    public static class PaymentHistoryDTO {
        private Integer paymentId;
        private BigDecimal value;
        private String dueDate;
        private boolean paid;

    }
}