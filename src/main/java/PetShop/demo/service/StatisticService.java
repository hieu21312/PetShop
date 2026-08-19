package PetShop.demo.service;

import PetShop.demo.model.enity.Order;
import PetShop.demo.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Service
public class StatisticService {
    @Autowired private OrderRepository orderRepository;

    public BigDecimal getTotalRevenue(LocalDate from, LocalDate to) {
        LocalDateTime fromDateTime = from.atStartOfDay();
        LocalDateTime toDateTime = to.atTime(LocalTime.MAX);
        List<Order> orders = orderRepository.findCompletedOrdersBetween(fromDateTime, toDateTime);
        return orders.stream()
                .map(Order::getTongTien)
                .filter(bb -> bb != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public List<Order> getCompletedOrdersBetween(LocalDate from, LocalDate to) {
        LocalDateTime fromDateTime = from.atStartOfDay();
        LocalDateTime toDateTime = to.atTime(LocalTime.MAX);
        return orderRepository.findCompletedOrdersBetween(fromDateTime, toDateTime);
    }
}