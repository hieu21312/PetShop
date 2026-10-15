package PetShop.demo;

import PetShop.demo.service.MembershipService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm thử phân hệ Hạng thành viên & Điểm thưởng tích lũy (MembershipService)")
public class MembershipServiceTest {

    private MembershipService membershipService;

    @BeforeEach
    void setUp() {
        membershipService = new MembershipService();
    }

    @Test
    @DisplayName("Quy đổi doanh số sang điểm thưởng: 100.000 VNĐ = 1 điểm")
    void testCalculatePoints() {
        assertEquals(0, membershipService.calculatePoints(BigDecimal.ZERO));
        assertEquals(0, membershipService.calculatePoints(new BigDecimal("99000")));
        assertEquals(1, membershipService.calculatePoints(new BigDecimal("100000")));
        assertEquals(5, membershipService.calculatePoints(new BigDecimal("500000")));
        assertEquals(15, membershipService.calculatePoints(new BigDecimal("1500000")));
    }

    @Test
    @DisplayName("Xác định Hạng thành viên dựa trên điểm tích lũy")
    void testDetermineTier() {
        assertEquals("Tiêu chuẩn", membershipService.determineTier(0));
        assertEquals("Tiêu chuẩn", membershipService.determineTier(49));
        assertEquals("Thân thiết", membershipService.determineTier(50));
        assertEquals("Thân thiết", membershipService.determineTier(199));
        assertEquals("VIP", membershipService.determineTier(200));
        assertEquals("VIP", membershipService.determineTier(499));
        assertEquals("VVIP", membershipService.determineTier(500));
        assertEquals("VVIP", membershipService.determineTier(1200));
    }

    @Test
    @DisplayName("Kiểm tra tỷ lệ phần trăm chiết khấu theo từng hạng")
    void testGetDiscountPercentage() {
        assertEquals(BigDecimal.ZERO, membershipService.getDiscountPercentage("Tiêu chuẩn"));
        assertEquals(new BigDecimal("5"), membershipService.getDiscountPercentage("Thân thiết"));
        assertEquals(new BigDecimal("10"), membershipService.getDiscountPercentage("VIP"));
        assertEquals(new BigDecimal("15"), membershipService.getDiscountPercentage("VVIP"));
    }

    @Test
    @DisplayName("Tính toán số tiền giảm giá ưu đãi theo Hạng thành viên")
    void testCalculateTierDiscount() {
        BigDecimal bill = new BigDecimal("1000000"); // 1 triệu VNĐ

        // Tiêu chuẩn (0%): Giảm 0đ
        assertEquals(BigDecimal.ZERO, membershipService.calculateTierDiscount(bill, "Tiêu chuẩn"));

        // Thân thiết (5%): Giảm 50.000đ
        assertEquals(new BigDecimal("50000"), membershipService.calculateTierDiscount(bill, "Thân thiết"));

        // VIP (10%): Giảm 100.000đ
        assertEquals(new BigDecimal("100000"), membershipService.calculateTierDiscount(bill, "VIP"));

        // VVIP (15%): Giảm 150.000đ
        assertEquals(new BigDecimal("150000"), membershipService.calculateTierDiscount(bill, "VVIP"));
    }
}
