package PetShop.demo.model.enity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "tblVaiTro")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "IDVaiTro")
    private Integer idVaiTro;

    @Column(name = "TenVaiTro")
    private String tenVaiTro;

    @Column(name = "MoTa")
    private String moTa;

    @OneToMany(mappedBy = "role")
    private List<Employee> employees;

    // Constructors
    public Role() {}

    // Getters and Setters
    public Integer getIdVaiTro() { return idVaiTro; }
    public void setIdVaiTro(Integer idVaiTro) { this.idVaiTro = idVaiTro; }

    public String getTenVaiTro() { return tenVaiTro; }
    public void setTenVaiTro(String tenVaiTro) { this.tenVaiTro = tenVaiTro; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public List<Employee> getEmployees() { return employees; }
    public void setEmployees(List<Employee> employees) { this.employees = employees; }
}