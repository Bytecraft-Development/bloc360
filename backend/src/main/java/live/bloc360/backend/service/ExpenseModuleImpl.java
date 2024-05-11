package live.bloc360.backend.service;


import live.bloc360.backend.model.Expense;
import live.bloc360.backend.repository.ExpenseRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class ExpenseModuleImpl  implements ExpenseModuleService {
   public final ExpenseRepository expenseRepository;

    public Expense createExpense(Expense expense) {
        return expenseRepository.save(expense);
    }
}
