package live.bloc360.backend.controller;

import live.bloc360.backend.model.Expense;
import live.bloc360.backend.service.ExpenseService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@AllArgsConstructor
@CrossOrigin
public class ExpenseController {

    private final ExpenseService expenseService;

    @PostMapping("/createExpense")
    public ResponseEntity<Expense> createExpenseModule(@RequestBody Expense expense) {
        Expense createdExpenseModule = expenseService.createExpense(expense);
        return ResponseEntity.ok(expense);
    }

    @GetMapping("/expenses")
    public ResponseEntity<List<Expense>> getAllExpenses() {
        List<Expense> expenses = expenseService.getAllExpenses();
        return ResponseEntity.ok(expenses);
    }

//    @PutMapping("/expenses/{id}")
//    public ResponseEntity<Expense> updateExpense(@PathVariable int id, @RequestBody Expense updatedExpense) {
//        Optional<Expense> expenseOptional = expenseService.getExpenseById(id);
//        if (expenseOptional.isPresent()) {
//            Expense expense = expenseOptional.get();
//            expense.setType(updatedExpense.getType());
//            expense.setConsumable(updatedExpense.isConsumable());
//            expense.setRepeatable(updatedExpense.isRepeatable());
//            expense.setDistribute(updatedExpense.isDistribute());
//            expense.setSerialNumber(updatedExpense.getSerialNumber());
//            expense.setDocumentDate(updatedExpense.getDocumentDate());
//            expense.setDueDate(updatedExpense.getDueDate());
//            expense.setAmount(updatedExpense.getAmount());
//            expense.setDescription(updatedExpense.getDescription());
//            expense.setReference(updatedExpense.getReference());
//            Expense updatedExpenseEntity = expenseService.createExpense(expense);
//            return ResponseEntity.ok(updatedExpenseEntity);
//        } else {
//            return ResponseEntity.notFound().build();
//        }
//    }

    @DeleteMapping("/expenses/{id}")
    public ResponseEntity<Void> deleteExpense(@PathVariable int id) {
        Optional<Expense> expenseOptional = expenseService.getExpenseById(id);
        if (expenseOptional.isPresent()) {
            expenseService.deleteExpense(id);
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }


}