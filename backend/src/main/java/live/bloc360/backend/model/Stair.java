package live.bloc360.backend.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Table(name = "stair")
public class Stair {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String name;

    @ManyToOne
    @JoinColumn(name = "block_id")
    @JsonBackReference
    private Block block;

    @OneToMany(mappedBy = "stair", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<HouseHold> households;
}