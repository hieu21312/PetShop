package PetShop.demo.service;

import PetShop.demo.model.enity.Product;
import PetShop.demo.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ProductService {
    @Autowired private ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public Optional<Product> getProductById(Integer id) {
        return productRepository.findById(id);
    }

    public List<Product> getProductsByType(String loai) {
        if (loai == null || loai.isEmpty()) return getAllProducts();
        return productRepository.findByLoaiSanPham(loai);
    }

    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.isEmpty()) return getAllProducts();
        return productRepository.findByTenSPContainingIgnoreCaseOrMoTaContainingIgnoreCase(keyword, keyword);
    }

    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    public void deleteProduct(Integer id) {
        productRepository.deleteById(id);
    }
}