package live.bloc360.backend.service;


import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.ExpenseHouseholds;
import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.repository.ExpenseRepository;
import live.bloc360.backend.repository.HouseHoldRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ExpenseImpl implements ExpenseService {
   public final ExpenseRepository expenseRepository;
    @Autowired
    private HouseHoldRepository houseHoldRepository;

    public Expense createExpense(Expense expense) {
        if (expense.getExpenseHouseholds() == null || expense.getExpenseHouseholds().isEmpty()) {
            throw new IllegalArgumentException("Lista expenseHouseholds este goală!");
        }

        List<ExpenseHouseholds> expenseHouseholds = new ArrayList<>();
        for (ExpenseHouseholds eh : expense.getExpenseHouseholds()) {
            Integer householdId = eh.getHouseHold().getId();

            HouseHold household = houseHoldRepository.findById(householdId)
                    .orElseThrow(() -> new IllegalArgumentException("HouseHold cu id " + householdId + " nu există"));

            eh.setHouseHold(household);
            eh.setExpense(expense);
            expenseHouseholds.add(eh);
        }

        expense.setExpenseHouseholds(expenseHouseholds);

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
