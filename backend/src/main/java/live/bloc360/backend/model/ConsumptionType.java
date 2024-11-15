package live.bloc360.backend.model;

import lombok.Getter;

@Getter
public enum ConsumptionType {
    ELECTRICITY("Energie electrica", "KWh" ),
    COLD_WATER("Apa rece", "m3"),
    HOT_WATER("Apa calda", "m3"),
    HEATING("Incalzire", "-"),
    ;

    private final String name;
    private final String unitOfMeasure;

    ConsumptionType(String name, String unitOfMeasure) {
        this.name = name;
        this.unitOfMeasure = unitOfMeasure;
    }
}
