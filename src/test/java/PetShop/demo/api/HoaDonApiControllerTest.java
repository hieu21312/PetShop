package PetShop.demo.api;

import PetShop.demo.model.dto.HoaDonRequestDTO;
import PetShop.demo.model.dto.ThanhToanRequestDTO;
import PetShop.demo.model.enity.Customer;
import PetShop.demo.model.enity.Employee;
import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.repository.ChiTietHoaDonDichVuRepository;
import PetShop.demo.repository.CustomerRepository;
import PetShop.demo.repository.EmployeeRepository;
import PetShop.demo.service.HoaDonDichVuService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class HoaDonApiControllerTest {

    private MockMvc mockMvc;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Mock
    private HoaDonDichVuService hoaDonDichVuService;

    @Mock
    private CustomerRepository customerRepository;

    @Mock
    private EmployeeRepository employeeRepository;

    @Mock
    private ChiTietHoaDonDichVuRepository chiTietHoaDonDichVuRepository;

    @InjectMocks
    private HoaDonApiController hoaDonApiController;

    private HoaDonDichVu mockHoaDon;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(hoaDonApiController).build();

        mockHoaDon = new HoaDonDichVu();
        mockHoaDon.setMaHDDV(101);
        mockHoaDon.setMaKH(1);
        mockHoaDon.setMaNV(2);
        mockHoaDon.setTongTien(new BigDecimal("150000"));
        mockHoaDon.setGhiChu("Spa thú cưng");
        mockHoaDon.setPhuongThucThanhToan("TienMat");
        mockHoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_CHUA_THANH_TOAN);
        mockHoaDon.setNgaySuDung(LocalDateTime.now());
    }

    @Test
    void testCreateHoaDon_Success() throws Exception {
        HoaDonRequestDTO request = new HoaDonRequestDTO(1, 2, new BigDecimal("150000"), "Spa thú cưng", "TienMat");

        when(hoaDonDichVuService.createHoaDon(eq(1), eq(2), any(BigDecimal.class), eq("TienMat"), eq("Spa thú cưng")))
                .thenReturn(mockHoaDon);

        mockMvc.perform(post("/api/hoa-don")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.maHDDV").value(101))
                .andExpect(jsonPath("$.maHoaDon").value(101))
                .andExpect(jsonPath("$.trangThai").value("ChuaThanhToan"));
    }

    @Test
    void testGetHoaDonDetail_Found() throws Exception {
        Customer mockCustomer = new Customer();
        mockCustomer.setMaKH(1);
        mockCustomer.setTenKH("Nguyễn Văn A");

        Employee mockEmployee = new Employee();
        mockEmployee.setMaNV(2);
        mockEmployee.setTenNV("Trần Thu Ngân");

        when(hoaDonDichVuService.getHoaDonById(101)).thenReturn(Optional.of(mockHoaDon));
        when(customerRepository.findById(1)).thenReturn(Optional.of(mockCustomer));
        when(employeeRepository.findById(2)).thenReturn(Optional.of(mockEmployee));
        when(chiTietHoaDonDichVuRepository.findById_MaHDDV(101)).thenReturn(Collections.emptyList());

        mockMvc.perform(get("/api/hoa-don/101"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.maHDDV").value(101))
                .andExpect(jsonPath("$.tenKH").value("Nguyễn Văn A"))
                .andExpect(jsonPath("$.tenNV").value("Trần Thu Ngân"))
                .andExpect(jsonPath("$.trangThai").value("ChuaThanhToan"));
    }

    @Test
    void testGetHoaDonDetail_NotFound() throws Exception {
        when(hoaDonDichVuService.getHoaDonById(999)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/hoa-don/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    void testXacNhanThanhToan_Success_VNPay() throws Exception {
        mockHoaDon.setTrangThai(HoaDonDichVu.TRANG_THAI_DA_THANH_TOAN);
        mockHoaDon.setPhuongThucThanhToan("VNPay");

        when(hoaDonDichVuService.getHoaDonById(101)).thenReturn(Optional.of(mockHoaDon));
        when(hoaDonDichVuService.xacNhanThanhToan(101, "VNPay")).thenReturn(mockHoaDon);

        ThanhToanRequestDTO body = new ThanhToanRequestDTO("VNPay");

        mockMvc.perform(post("/api/hoa-don/101/thanh-toan")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.maHDDV").value(101))
                .andExpect(jsonPath("$.trangThai").value("DaThanhToan"))
                .andExpect(jsonPath("$.phuongThucThanhToan").value("VNPay"));
    }
}
