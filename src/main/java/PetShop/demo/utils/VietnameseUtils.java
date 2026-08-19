package PetShop.demo.utils;

public class VietnameseUtils {

    public static String removeVietnamese(String str) {
        if (str == null) return null;
        str = str.toLowerCase();
        String[] signs = {
                "aáàảạãăắằẳẵặâấầẩẫậ",
                "eéèẻẽẹêếềểễệ",
                "iíìỉĩị",
                "oóòỏõọôốồổỗộơớờởỡợ",
                "uúùủũụưứừửữự",
                "yýỳỷỹỵ",
                "dđ"
        };
        String[] replaces = {"a", "e", "i", "o", "u", "y", "d"};
        for (int i = 0; i < signs.length; i++) {
            for (char c : signs[i].toCharArray()) {
                str = str.replace(c, replaces[i].charAt(0));
            }
        }
        return str;
    }
}