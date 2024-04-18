package live.block360.backend.model;

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

    private String address;

    private String juridicForm;

    private String registrationFiscalNumber;

    private String contactDetails;

    private String activityObject;

    private String socialCapital;

    private String ownersDetails;

    private String companyOwners;

    private String otherInformation;

}
