package live.bloc360.backend.controller;

import live.bloc360.backend.model.Expense;
import live.bloc360.backend.service.ExpenseModuleService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
@CrossOrigin
public class ExpenseController {

    private final ExpenseModuleService expenseModuleService;

    @PostMapping("/createExpense")
    public ResponseEntity<Expense> createExpenseModule(@RequestBody Expense expense) {
        Expense createdExpenseModule = expenseModuleService.createExpense(expense);
        return ResponseEntity.ok(expense);
    }


}