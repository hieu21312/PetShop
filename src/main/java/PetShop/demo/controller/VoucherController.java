package PetShop.demo.controller;

import PetShop.demo.model.enity.Voucher;
import PetShop.demo.service.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/QLMaGiamGia")
public class VoucherController {

    @Autowired
    private VoucherService voucherService;

    @GetMapping("/Index")
    public String listVouchers(Model model) {
        model.addAttribute("vouchers", voucherService.getAllVouchers());
        return "voucher-list";
    }

    @GetMapping("/Create")
    public String createForm(Model model) {
        model.addAttribute("voucher", new Voucher());
        return "voucher-create";
    }

    @PostMapping("/Create")
    public String createVoucher(Voucher voucher) {
        if (voucherService.getVoucherByCode(voucher.getMaGiamGia()).isPresent()) {
            return "redirect:/QLMaGiamGia/Create?error=exists";
        }
        voucherService.saveVoucher(voucher);
        return "redirect:/QLMaGiamGia/Index";
    }

    @PostMapping("/Delete")
    public String deleteVoucher(@RequestParam String id) {
        voucherService.deleteVoucher(id);
        return "redirect:/QLMaGiamGia/Index";
    }
}