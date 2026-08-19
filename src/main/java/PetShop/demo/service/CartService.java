package PetShop.demo.service;

import PetShop.demo.model.dto.CartItemDTO;
import PetShop.demo.model.enity.Product;
import PetShop.demo.repository.ProductRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CartService {
    private static final String CART_SESSION_KEY = "cart";
    @Autowired private ProductRepository productRepository;

    @SuppressWarnings("unchecked")
    public List<CartItemDTO> getCart(HttpSession session) {
        List<CartItemDTO> cart = (List<CartItemDTO>) session.getAttribute(CART_SESSION_KEY);
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute(CART_SESSION_KEY, cart);
        }
        return cart;
    }

    public void addToCart(Integer maSP, HttpSession session) {
        List<CartItemDTO> cart = getCart(session);
        Optional<CartItemDTO> existing = cart.stream().filter(item -> item.getMaSP().equals(maSP)).findFirst();
        if (existing.isPresent()) {
            existing.get().setSoLuong(existing.get().getSoLuong() + 1);
        } else {
            Optional<Product> pOpt = productRepository.findById(maSP);
            if (pOpt.isPresent()) {
                Product p = pOpt.get();
                cart.add(new CartItemDTO(p.getMaSP(), p.getTenSP(), p.getAnhDaiDien(), p.getGiaBan(), 1));
            }
        }
        session.setAttribute("cart", cart);
    }

    public void removeFromCart(Integer maSP, HttpSession session) {
        List<CartItemDTO> cart = getCart(session);
        cart.removeIf(i -> i.getMaSP().equals(maSP));
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public void updateQuantity(Integer maSP, int delta, HttpSession session) {
        List<CartItemDTO> cart = getCart(session);
        for (CartItemDTO item : cart) {
            if (item.getMaSP().equals(maSP)) {
                int newQty = item.getSoLuong() + delta;
                if (newQty > 0) item.setSoLuong(newQty);
                else cart.remove(item);
                break;
            }
        }
        session.setAttribute(CART_SESSION_KEY, cart);
    }

    public int getTotalQuantity(HttpSession session) {
        return getCart(session).stream().mapToInt(CartItemDTO::getSoLuong).sum();
    }

    public BigDecimal getTotalPrice(HttpSession session) {
        return getCart(session).stream().map(CartItemDTO::getThanhTien).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public void clearCart(HttpSession session) {
        session.removeAttribute(CART_SESSION_KEY);
    }
}