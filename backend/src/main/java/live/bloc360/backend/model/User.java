package live.bloc360.backend.model;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;

import java.util.List;
import java.util.Date;
import java.util.UUID;
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID uuid;

    @CreatedDate
    private Date dateCreated;

    private boolean isValid;
    private boolean isActive;
    private boolean isVerified;
    private boolean isDeleted;

    private String firstName;
    private String lastName;
    private String middleName;
    private String phone;

    @UpdateTimestamp
    private Date lastUpdate;


}



