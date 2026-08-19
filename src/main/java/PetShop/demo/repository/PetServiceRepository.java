package PetShop.demo.repository;

import PetShop.demo.model.enity.PetService;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PetServiceRepository extends JpaRepository<PetService, Integer> {
}