package PetShop.demo.controller;

import PetShop.demo.service.AdminService;
import PetShop.demo.service.AuthService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.ui.ConcurrentModel;
import org.springframework.ui.Model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class AdminControllerTest {

    @Mock
    private AdminService adminService;

    @Mock
    private AuthService authService;

    @InjectMocks
    private AdminController adminController;

    private MockHttpSession session;
    private Model model;

    @BeforeEach
    void setUp() {
        session = new MockHttpSession();
        model = new ConcurrentModel();
    }

    @Test
    void testAdminRoot_NotLoggedIn_RedirectsToDangNhap() {
        when(authService.isLoggedIn(session)).thenReturn(false);
        String view = adminController.adminRoot(session);
        assertEquals("redirect:/DangNhap", view);
    }

    @Test
    void testAdminRoot_Admin_RedirectsToAdminIndex() {
        when(authService.isLoggedIn(session)).thenReturn(true);
        when(authService.isAdmin(session)).thenReturn(true);

        String view = adminController.adminRoot(session);
        assertEquals("redirect:/admin/index", view);
    }

    @Test
    void testAdminRoot_Doctor_RedirectsToDoctorTreatment() {
        when(authService.isLoggedIn(session)).thenReturn(true);
        when(authService.isAdmin(session)).thenReturn(false);
        when(authService.isDoctor(session)).thenReturn(true);

        String view = adminController.adminRoot(session);
        assertEquals("redirect:/admin/doctor/treatment", view);
    }

    @Test
    void testAdminRoot_Cashier_RedirectsToThuNgan() {
        when(authService.isLoggedIn(session)).thenReturn(true);
        when(authService.isAdmin(session)).thenReturn(false);
        when(authService.isDoctor(session)).thenReturn(false);
        when(authService.isCashier(session)).thenReturn(true);

        String view = adminController.adminRoot(session);
        assertEquals("redirect:/admin/thu-ngan", view);
    }

    @Test
    void testIndex_Cashier_RedirectsToThuNgan() {
        when(authService.isLoggedIn(session)).thenReturn(true);
        when(authService.isAdmin(session)).thenReturn(false);
        when(authService.isCashier(session)).thenReturn(true);

        String view = adminController.index(model, session);
        assertEquals("redirect:/admin/thu-ngan", view);
    }
}
