package live.bloc360.backend.service;


import live.bloc360.backend.model.Expense;
import live.bloc360.backend.model.HouseHold;
import live.bloc360.backend.repository.ExpenseRepository;
import live.bloc360.backend.repository.HouseHoldRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class ExpenseImpl implements ExpenseService {
   public final ExpenseRepository expenseRepository;
    @Autowired
    private HouseHoldRepository houseHoldRepository;

    public Expense createExpense(Expense expense) {
        if (expense.getHouseHoldList() == null || expense.getHouseHoldList().isEmpty()) {
            throw new IllegalArgumentException("Lista householdIds este goală!");
        }
        List<Integer> householdIds = expense.getHouseHoldList().stream()
                .map(HouseHold::getId)
                .toList();

        List<HouseHold> households = houseHoldRepository.findAllById(householdIds);

        expense.setHouseHoldList(households);
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
