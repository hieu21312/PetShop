package PetShop.demo;

import PetShop.demo.model.enity.Customer;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.service.AuthService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@DisplayName("Kiểm thử phân hệ Xác thực, Mã hóa & Đổi mật khẩu (AuthService)")
public class AuthServiceTest {

    @InjectMocks
    private AuthService authService;

    @Mock
    private CustomerRepository customerRepository;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    @DisplayName("Mã hóa SHA-256 một chiều và đồng nhất")
    void testHashPassword() {
        String raw = "123456";
        String hash1 = authService.hashPassword(raw);
        String hash2 = authService.hashPassword(raw);

        assertNotNull(hash1);
        assertEquals(hash1, hash2);
        assertNotEquals(raw, hash1);
        assertEquals(64, hash1.length()); // Độ dài chuỗi SHA-256 là 64 hex chars
    }

    @Test
    @DisplayName("Đổi mật khẩu thành công khi nhập đúng mật khẩu hiện tại")
    void testChangePasswordSuccess() {
        Customer c = new Customer();
        c.setMaKH(1);
        c.setMatKhau(authService.hashPassword("oldPass123"));

        when(customerRepository.findById(1)).thenReturn(Optional.of(c));
        when(customerRepository.save(any(Customer.class))).thenReturn(c);

        boolean result = authService.changeCustomerPassword(1, "oldPass123", "newPass456");

        assertTrue(result);
        assertEquals(authService.hashPassword("newPass456"), c.getMatKhau());
        verify(customerRepository, times(1)).save(c);
    }

    @Test
    @DisplayName("Đổi mật khẩu thất bại khi nhập sai mật khẩu hiện tại")
    void testChangePasswordFailWrongCurrentPassword() {
        Customer c = new Customer();
        c.setMaKH(1);
        c.setMatKhau(authService.hashPassword("correctPassword"));

        when(customerRepository.findById(1)).thenReturn(Optional.of(c));

        boolean result = authService.changeCustomerPassword(1, "wrongPassword", "newPass456");

        assertFalse(result);
        verify(customerRepository, never()).save(any());
    }
}
