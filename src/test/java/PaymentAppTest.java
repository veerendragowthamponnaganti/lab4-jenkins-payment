import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class PaymentAppTest {

    @Test
    void paymentShouldBeProcessedSuccessfully() {
        assertEquals(
            "Payment processed successfully",
            PaymentApp.processPayment()
        );
    }
}