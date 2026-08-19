package PetShop.demo.utils;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtils {

    private static final String UPLOAD_DIR = "src/main/webapp/Content/HinhAnh/";

    public static String saveFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) return null;

        String originalName = file.getOriginalFilename();
        String extension = originalName.substring(originalName.lastIndexOf("."));
        String newFileName = UUID.randomUUID().toString() + extension;

        Path path = Paths.get(UPLOAD_DIR + newFileName);
        Files.createDirectories(path.getParent());
        Files.write(path, file.getBytes());

        return newFileName;
    }

    public static void deleteFile(String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) return;
        Path path = Paths.get(UPLOAD_DIR + fileName);
        Files.deleteIfExists(path);
    }
}