package live.bloc360.backend.model;

import lombok.*;

import java.time.Month;
import java.time.Year;


@Getter
@Setter
@AllArgsConstructor

public class Invoice {

    private String apartmentNumber;
    private String price;

}