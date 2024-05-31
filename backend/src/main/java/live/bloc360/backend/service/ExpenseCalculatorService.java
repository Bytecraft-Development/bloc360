package live.bloc360.backend.service;
import live.bloc360.backend.model.*;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@AllArgsConstructor
@Service
public class ExpenseCalculatorService {

    public void distributeExpense(Expense expense, List<HouseHold> customHouseHoldList, ExpenseDistributionType expenseDistributionType) {
        switch (expenseDistributionType) {
            case EQUALLY:
                BigDecimal expensePerHouseHold;
                Integer numOfHouseHolds = customHouseHoldList.size();
                expensePerHouseHold = expense.getAmount().divide(BigDecimal.valueOf(numOfHouseHolds), 3, RoundingMode.HALF_EVEN);
                for (HouseHold houseHold : customHouseHoldList) {
                    Payment payment = new Payment();
                    payment.setExpense(expense);
                    payment.setHouseHold(houseHold);
                    payment.setValue(expensePerHouseHold);
                    houseHold.getPaymentList().add(payment);
                }
                break;
            case BY_NUMBER_OF_PEOPLE:
                BigDecimal expensePerHouseHoldMember;
                Integer numOfHouseHoldMembers = 0;
                for (HouseHold houseHold : customHouseHoldList) {
                    numOfHouseHoldMembers += houseHold.getNumberOfHouseHoldMembers();
                }
                expensePerHouseHoldMember = expense.getAmount().divide(BigDecimal.valueOf(numOfHouseHoldMembers), 3, RoundingMode.HALF_EVEN);
                for (HouseHold houseHold : customHouseHoldList) {
                    Payment payment = new Payment();
                    payment.setExpense(expense);
                    payment.setHouseHold(houseHold);
                    payment.setValue(expensePerHouseHoldMember.multiply(BigDecimal.valueOf(houseHold.getNumberOfHouseHoldMembers())));
                    houseHold.getPaymentList().add(payment);
                }
                break;
            case BY_SURFACE:
                BigDecimal expensePerSurfaceUnit;
                Double totalSurface = 0.0;
                for (HouseHold houseHold : customHouseHoldList) {
                    totalSurface += houseHold.getSurface();
                }
                expensePerSurfaceUnit = expense.getAmount().divide(BigDecimal.valueOf(totalSurface),3, RoundingMode.HALF_EVEN);
                for (HouseHold houseHold : customHouseHoldList) {
                    Payment payment = new Payment();
                    payment.setExpense(expense);
                    payment.setHouseHold(houseHold);
                    payment.setValue(expensePerSurfaceUnit.multiply(BigDecimal.valueOf(houseHold.getSurface())));
                    houseHold.getPaymentList().add(payment);
                }
                break;
            case BY_INDEX:
                for (HouseHold houseHold : customHouseHoldList) {
                    Payment payment = new Payment();
                    payment.setValue(BigDecimal.valueOf(10));
                    houseHold.getPaymentList().add(payment);
                }
                break;
            case FIXED_PERCENTAGE:
                for (HouseHold houseHold : customHouseHoldList) {
                    Payment payment = new Payment();
                    payment.setValue(BigDecimal.valueOf(100));
                    houseHold.getPaymentList().add(payment);
                }
            /*default:
                throw new RuntimeException("No CalcMethod available"); */
        }
    }
}



