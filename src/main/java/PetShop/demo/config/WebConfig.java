package PetShop.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Cấu hình phục vụ ảnh từ cả thư mục file bên ngoài lẫn bên trong JAR classpath
        registry.addResourceHandler(
                "/Content/HinhAnh/**", 
                "/content/hinhanh/**", 
                "/content/HinhAnh/**", 
                "/Content/hinhanh/**",
                "/images/**"
        ).addResourceLocations(
                "file:src/main/webapp/Content/HinhAnh/",
                "file:./src/main/webapp/Content/HinhAnh/",
                "classpath:/static/Content/HinhAnh/",
                "classpath:/static/images/"
        );

        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*");
    }
}
