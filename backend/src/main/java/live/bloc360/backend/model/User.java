package live.bloc360.backend.model;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.util.UUID;
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "users")
public class User {

    @Id
    private UUID uuid;

    @CreatedDate
    private Date dateCreated;

    private boolean isValid;
    private boolean isActive;
    private boolean isVerified;
    private boolean isDeleted;

    private String userName;
    private String firstName;
    private String lastName;
    private String middleName;
    private String phone;

    @UpdateTimestamp
    private Date lastUpdate;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<HouseHold> houseHolds = new ArrayList<>();
}
