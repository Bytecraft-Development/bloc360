package live.bloc360.backend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "association")
public class Association {
 @Id
 @GeneratedValue(strategy = GenerationType.IDENTITY)
 private Integer id;

 private String name;
 private String address;
 private String cui;
 private String registerComert;
 private String bankAccount;
 private String bankName;
 private String adminUsername;

 //Citire index

 private boolean coldWater;
 private boolean hotWater;
 private boolean gas;
 private boolean heating;

 //Zi emitere Facturi
 private String indexDate;

 @OneToMany(mappedBy = "association", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
 @JsonManagedReference
 private List<Block> blocks;

}
