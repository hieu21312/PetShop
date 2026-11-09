package PetShop.demo;

import PetShop.demo.model.enity.PetService;
import PetShop.demo.repository.PetServiceRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SpringBootApplication
public class DemoApplication {
	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
		System.out.println("PetShop Java application started on port 8080");
	}

	@Bean
	public CommandLineRunner initServiceImages(PetServiceRepository petServiceRepository) {
		return args -> {
			Map<String, String> serviceImages = new HashMap<>();
			serviceImages.put("Tắm gội", "tam-goi.jpg");
			serviceImages.put("Cắt tỉa lông", "cat-tia-long.jpg");
			serviceImages.put("Khám tổng quát", "kham-tong-quat.jpg");
			serviceImages.put("Tiêm phòng", "tiem-phong.jpg");
			serviceImages.put("Chăm sóc sau phẫu thuật", "cham-soc-sau-phau-thuat.jpg");
			serviceImages.put("Khách sạn thú cưng", "khach-san-thu-cung.jpg");
			serviceImages.put("Ve sinh tai & răng", "ve-sinh-tai-rang.jpg");
			serviceImages.put("Vệ sinh tai & răng", "ve-sinh-tai-rang.jpg");
			serviceImages.put("Cạo lông mùa hè", "cao-long.jpg");
			serviceImages.put("Tư vấn dinh dưỡng", "tu-van-dinh-duong.jpg");
			serviceImages.put("Khám da liễu", "kham-da-lieu.jpg");
			serviceImages.put("Massage thư giãn", "massage.jpg");
			serviceImages.put("Gỡ rối lông", "go-roi-long.jpg");
			serviceImages.put("Chăm sóc móng", "cham-soc-mong.jpg");
			serviceImages.put("Xịt khử mùi", "xit-khu-mui.jpg");
			serviceImages.put("Chụp ảnh thú cưng", "chup-anh.jpg");
			serviceImages.put("Đào tạo cơ bản", "dao-tao.jpg");
			serviceImages.put("Gửi thú cưng theo giờ", "gui-thu-cung.jpg");
			serviceImages.put("Chăm sóc thú cưng cao tuổi", "cham-soc-cao-tuoi.jpg");
			serviceImages.put("Xét nghiệm máu", "xet-nghiem-mau.jpg");
			serviceImages.put("Vệ sinh tuyến hôi", "ve-sinh-tuyen-hoi.jpg");

			List<PetService> services = petServiceRepository.findAll();
			boolean hasChanges = false;
			for (PetService service : services) {
				String currentImg = service.getHinhAnh();
				if (currentImg == null || currentImg.trim().isEmpty() || "default-service.jpg".equalsIgnoreCase(currentImg.trim())) {
					String matchedImg = serviceImages.get(service.getTenDV());
					if (matchedImg == null && service.getTenDV() != null) {
						for (Map.Entry<String, String> entry : serviceImages.entrySet()) {
							if (service.getTenDV().toLowerCase().contains(entry.getKey().toLowerCase())
									|| entry.getKey().toLowerCase().contains(service.getTenDV().toLowerCase())) {
								matchedImg = entry.getValue();
								break;
							}
						}
					}
					if (matchedImg != null) {
						service.setHinhAnh(matchedImg);
						hasChanges = true;
					}
				}
			}
			if (hasChanges) {
				petServiceRepository.saveAll(services);
				System.out.println("Đã cập nhật hình ảnh riêng biệt cho từng dịch vụ chăm sóc thú cưng thành công!");
			}
		};
	}
}
