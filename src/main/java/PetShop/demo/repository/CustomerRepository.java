package PetShop.demo.repository;

import PetShop.demo.model.enity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Integer> {
    Optional<Customer> findByEmail(String email);
    Optional<Customer> findByDienThoai(String dienThoai);
    Optional<Customer> findFirstByDienThoaiOrEmail(String dienThoai, String email);
    Optional<Customer> findByEmailAndMatKhau(String email, String matKhau);
    Optional<Customer> findFirstByEmailAndMatKhau(String email, String matKhau);
}