package PetShop.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Cấu hình để phục vụ ảnh từ thư mục ngoài (src/main/webapp/Content/HinhAnh)
        registry.addResourceHandler("/Content/HinhAnh/**")
                .addResourceLocations("file:src/main/webapp/Content/HinhAnh/");

        // Cấu hình cho static resources (CSS, JS, images trong classpath)
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}