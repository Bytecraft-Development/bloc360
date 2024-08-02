package live.bloc360.backend.service;
import live.bloc360.backend.model.*;
import live.bloc360.backend.repository.PaymentRepository;
import live.bloc360.backend.repository.HouseHoldRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
@Service
public class ExpenseCalcTestService {
    private final HouseHoldRepository houseHoldRepository;
    private final PaymentRepository paymentRepository;

    public ExpenseCalcTestService(HouseHoldRepository houseHoldRepository, PaymentRepository paymentRepository) {
        this.houseHoldRepository = houseHoldRepository;
        this.paymentRepository = paymentRepository;
    }

    public void test() {


        HouseHold houseHold1 = new HouseHold();
        HouseHold houseHold2 = new HouseHold();
        HouseHold houseHold3 = new HouseHold();

        Expense expense = new Expense();
        expense.setAmount(BigDecimal.valueOf(100));

        List<HouseHold> customHHList = new ArrayList<>();
        customHHList.add(houseHold1);
        customHHList.add(houseHold2);
        customHHList.add(houseHold3);

      /*  houseHold1.setNumberOfHouseHoldMembers(2);
        houseHold1.setSurface(40.5);
        houseHold2.setNumberOfHouseHoldMembers(1);
        houseHold2.setSurface(60.25);
        houseHold3.setNumberOfHouseHoldMembers(4);
        houseHold3.setSurface(90.4);*/


/*

        ExpenseCalculatorService es = new ExpenseCalculatorService();
        es.distributeExpense(expense, customHHList, ExpenseDistributionType.EQUALLY);
*/

        houseHoldRepository.save(houseHold1);
        houseHoldRepository.save(houseHold2);
        houseHoldRepository.save(houseHold3);

    }
}

