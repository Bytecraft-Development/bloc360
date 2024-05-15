package live.bloc360.backend.service;


import live.bloc360.backend.model.Expense;
import live.bloc360.backend.repository.ExpenseRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ExpenseImpl implements ExpenseService {
   public final ExpenseRepository expenseRepository;

    public Expense createExpense(Expense expense) {
        return expenseRepository.save(expense);
    }
    public List<Expense> getAllExpenses() {
        return expenseRepository.findAll();
    }

    public void deleteExpense(int id) {
        expenseRepository.deleteById(id);
    }
    public Optional<Expense> getExpenseById(int id) {
        return expenseRepository.findById(id);
    }


}
