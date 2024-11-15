package live.bloc360.backend.service;
import live.bloc360.backend.model.*;
import live.bloc360.backend.repository.PaymentRepository;
import live.bloc360.backend.repository.HouseHoldRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class ExpenseCalcTestService_TBD {
    private final HouseHoldRepository houseHoldRepository;
    private final PaymentRepository paymentRepository;

    public ExpenseCalcTestService_TBD(HouseHoldRepository houseHoldRepository, PaymentRepository paymentRepository) {
        this.houseHoldRepository = houseHoldRepository;
        this.paymentRepository = paymentRepository;
    }

    public void test() {


        HouseHold houseHold1 = new HouseHold();
        HouseHold houseHold2 = new HouseHold();
        HouseHold houseHold3 = new HouseHold();

        Expense expense1 = new Expense();
        expense1.setAmount(BigDecimal.valueOf(90));
        expense1.setConsumptionType(ConsumptionType.COLD_WATER);

        Expense expense2 = new Expense();
        expense2.setAmount(BigDecimal.valueOf(60));
        expense2.setConsumptionType(ConsumptionType.ELECTRICITY);

        List<HouseHold> customHHList = new ArrayList<>();
        customHHList.add(houseHold1);
        customHHList.add(houseHold2);
        customHHList.add(houseHold3);

        houseHold1.setNumberOfHouseHoldMembers(2);
        houseHold1.setSurface(40.5);
        houseHold1.setApartmentNumber("10");
        houseHold2.setNumberOfHouseHoldMembers(1);
        houseHold2.setSurface(60.25);
        houseHold2.setApartmentNumber("20");
        houseHold3.setNumberOfHouseHoldMembers(4);
        houseHold3.setSurface(90.4);
        houseHold3.setApartmentNumber("30");
        // Water meter test

        /*Meter meter1 = new Meter();

        meter1.setConsumptionType(ConsumptionType.COLD_WATER);

        LocalDate date1 = LocalDate.of(2024, 6, 12);
        meter1.getMeterReadings().add(new MeterReading(date1, 12000L));

        LocalDate date2 = LocalDate.of(2024, 7, 12);
        meter1.getMeterReadings().add(new MeterReading(date2, 12300L));

        LocalDate date22 = LocalDate.of(2024, 7, 20);
        meter1.getMeterReadings().add(new MeterReading(date22, 12360L));

        LocalDate date3 = LocalDate.of(2024, 8, 12);
        meter1.getMeterReadings().add(new MeterReading(date3, 12400L));

        houseHold1.getMeterList().add(meter1);

        Meter meter2 = new Meter();
        meter2.setConsumptionType(ConsumptionType.COLD_WATER);

        LocalDate date4 = LocalDate.of(2024, 6, 12);
        meter2.getMeterReadings().add(new MeterReading(date4, 12400L));

        LocalDate date5 = LocalDate.of(2024, 7, 12);
        meter2.getMeterReadings().add(new MeterReading(date5, 12900L));

        LocalDate date55 = LocalDate.of(2024, 7, 20);
        meter2.getMeterReadings().add(new MeterReading(date55, 12940L));

        LocalDate date6 = LocalDate.of(2024, 8, 12);
        meter2.getMeterReadings().add(new MeterReading(date6, 13000L));

        houseHold2.getMeterList().add(meter2);

        Meter meter3 = new Meter();
        meter3.setConsumptionType(ConsumptionType.COLD_WATER);

        LocalDate date7 = LocalDate.of(2024, 6, 12);
        meter3.getMeterReadings().add(new MeterReading(date7, 12500L));

        LocalDate date8 = LocalDate.of(2024, 7, 12);
        meter3.getMeterReadings().add(new MeterReading(date8, 12600L));

        LocalDate date88 = LocalDate.of(2024, 7, 20);
        meter3.getMeterReadings().add(new MeterReading(date88, 12620L));

        LocalDate date9 = LocalDate.of(2024, 8, 12);
        meter3.getMeterReadings().add(new MeterReading(date9, 12700L));

        houseHold3.getMeterList().add(meter3);

        System.out.println("JULY READING: " + houseHold1.getMeterList().get(0).getMonthlyReading(LocalDate.of(2024, 7, 1)));
        System.out.println("JULY CONSUMPTION" + houseHold1.getMonthlyConsumption(LocalDate.of(2024, 7,1), ConsumptionType.COLD_WATER)); */
        // Water meter test end


        ExpenseCalculatorService es = new ExpenseCalculatorService();
        es.distributeExpense(expense1, customHHList, ExpenseDistributionType.EQUALLY);
        es.distributeExpense(expense2, customHHList, ExpenseDistributionType.EQUALLY);

        houseHoldRepository.save(houseHold1);
        houseHoldRepository.save(houseHold2);
        houseHoldRepository.save(houseHold3);

    }
}

