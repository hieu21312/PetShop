package PetShop.demo.service;

import PetShop.demo.model.enity.Review;
import PetShop.demo.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class ReviewService {
    @Autowired private ReviewRepository reviewRepository;

    public List<Review> getReviewsByProduct(Integer maSP) {
        return reviewRepository.findByMaSPOrderByNgayDesc(maSP);
    }

    public Review addReview(Review review) {
        review.setNgay(LocalDateTime.now());
        return reviewRepository.save(review);
    }
}