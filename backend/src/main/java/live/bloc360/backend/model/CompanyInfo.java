package live.bloc360.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name="companyInfo")
public class CompanyInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;

    private String date;

    private String address;

    private String juridicForm;

    private int CUI;

    private String registrationFiscalNumber;

    private String CAEN;

    private String fiscalCompany;


}
