package live.bloc360.backend.controller;

import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.ExpenseDistributionType;
import live.bloc360.backend.model.HouseHold;

import live.bloc360.backend.service.ExpenseCalcTestService_TBD;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/calculator")
public class ExpenseCalculatorController {

    private final ExpenseCalcTestService_TBD expenseCalcTestService;

    public ExpenseCalculatorController(ExpenseCalcTestService_TBD expenseCalcTestService) {
        this.expenseCalcTestService = expenseCalcTestService;
    }


    @GetMapping("distribute")
    public void distribute() {
        expenseCalcTestService.test();
    }
}
