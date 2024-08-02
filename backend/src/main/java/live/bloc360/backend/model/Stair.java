package live.bloc360.backend.model;

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
    private Block block;

    @OneToMany(mappedBy = "stair", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<HouseHold> households;
}