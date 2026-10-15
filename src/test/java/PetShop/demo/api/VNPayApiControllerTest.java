package PetShop.demo.api;

import PetShop.demo.model.enity.HoaDonDichVu;
import PetShop.demo.service.HoaDonDichVuService;
import PetShop.demo.service.VNPayService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class VNPayApiControllerTest {

    private MockMvc mockMvc;

    @Mock
    private VNPayService vnPayService;

    @Mock
    private HoaDonDichVuService hoaDonDichVuService;

    @InjectMocks
    private VNPayApiController vnPayApiController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(vnPayApiController).build();
    }

    @Test
    void testCreatePaymentUrl_Success() throws Exception {
        HoaDonDichVu hd = new HoaDonDichVu();
        hd.setMaHDDV(10);
        hd.setTongTien(new BigDecimal("200000"));

        when(hoaDonDichVuService.getHoaDonById(10)).thenReturn(Optional.of(hd));
        when(vnPayService.createPaymentUrl(eq(hd), any())).thenReturn("https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?test=1");
        when(vnPayService.createPaymentQRCodeBase64(any(), eq(300), eq(300))).thenReturn("data:image/png;base64,iVBORw0KGgoAAAANSUhEUg==");

        mockMvc.perform(post("/api/hoa-don/10/vnpay-url"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.maHDDV").value(10))
                .andExpect(jsonPath("$.paymentUrl").isNotEmpty())
                .andExpect(jsonPath("$.qrCodeBase64").isNotEmpty());
    }

    @Test
    void testHandleVNPayIpn_Success() throws Exception {
        Map<String, String> ipnResult = new HashMap<>();
        ipnResult.put("RspCode", "00");
        ipnResult.put("Message", "Confirm Success");

        when(vnPayService.processIpn(any())).thenReturn(ipnResult);

        mockMvc.perform(get("/api/vnpay/ipn")
                        .param("vnp_Amount", "20000000")
                        .param("vnp_TxnRef", "HDDV_10")
                        .param("vnp_ResponseCode", "00"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.RspCode").value("00"))
                .andExpect(jsonPath("$.Message").value("Confirm Success"));
    }
}
