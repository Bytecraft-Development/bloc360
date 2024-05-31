package live.bloc360.backend.controller;

import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.ExpenseDistributionType;
import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.service.ExpenseCalcTestService;
import live.bloc360.backend.service.ExpenseCalculatorService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/calculator")
public class ExpenseCalculatorController {

    private final ExpenseCalcTestService expenseCalcTestService;

    public ExpenseCalculatorController(ExpenseCalcTestService expenseCalcTestService) {
        this.expenseCalcTestService = expenseCalcTestService;
    }


    @GetMapping("distribute")
    public void distribute() {
        expenseCalcTestService.test();
    }
}
