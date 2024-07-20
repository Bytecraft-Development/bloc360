package live.bloc360.backend.controller;

import jakarta.servlet.http.HttpServletRequest;
import live.bloc360.backend.service.UserDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.UUID;
@RestController
public class UserDashboardController {

    @Autowired
    private UserDashboardService userDashboardService;

    @GetMapping("/total-payment")
    public ResponseEntity<BigDecimal> getTotalPaymentAmount() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = getUserIdFromJwt(authentication);
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        BigDecimal totalPaymentAmount = userDashboardService.getTotalPaymentAmount(userId);
        return ResponseEntity.ok(totalPaymentAmount);
    }

    @GetMapping("/number-of-households")
    public ResponseEntity<Integer> getNumberOfHouseholds() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        UUID userId = getUserIdFromJwt(authentication);
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        int numberOfHouseholds = userDashboardService.getNumberOfPeopleInHouseHold(userId);
        return ResponseEntity.ok(numberOfHouseholds);
    }

    private UUID getUserIdFromJwt(Authentication authentication) {
        if (authentication != null && authentication.getCredentials() instanceof Jwt) {
            Jwt token = (Jwt) authentication.getCredentials();
            String sub = token.getClaim("sub");
            if (sub != null) {
                try {
                    return UUID.fromString(sub);
                } catch (IllegalArgumentException e) {
                    throw new RuntimeException("Invalid UUID format in JWT", e);
                }
            }
        }
        return null;
    }
}