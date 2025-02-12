package live.bloc360.backend.service;


import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.HouseHold;

import java.util.List;
import java.util.Optional;

public interface ExpenseService {
    Expense createExpense(Expense expense);

    public List<Expense> getAllExpenses();

    public void deleteExpense(int id) ;

    public Optional<Expense> getExpenseById(int id);

}
