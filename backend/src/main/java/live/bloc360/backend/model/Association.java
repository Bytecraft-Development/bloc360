package live.bloc360.backend.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import live.bloc360.backend.dto.AssociationDTO;
import live.bloc360.backend.dto.HouseHoldDTO;
import live.bloc360.backend.dto.StairAssociationDTO;
import lombok.*;


import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

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
 private boolean hasBlocks;
 private boolean hasHouses;
 private String adminUsername;

 //Citire index

 private boolean coldWater;
 private boolean hotWater;
 private boolean gas;
 private boolean heating;

 //Zi emitere Facturi
 @Temporal(TemporalType.DATE)
 @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
 private Date indexDate;

 @OneToMany(mappedBy = "association", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
 private List<Block> blocks;

 @OneToMany(mappedBy = "association", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
 private List<House> houses;
}
