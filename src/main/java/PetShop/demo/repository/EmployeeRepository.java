package PetShop.demo.repository;

import PetShop.demo.model.enity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {
    Optional<Employee> findByMaNVAndMatKhau(Integer maNV, String matKhau);
}