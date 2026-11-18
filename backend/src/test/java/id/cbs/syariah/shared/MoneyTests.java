package id.cbs.syariah.shared;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;

class MoneyTests {

    @Test
    void rejectsImplicitRounding() {
        assertThatThrownBy(() -> Money.of("1.005")).isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void roundsHalfUpOnce() {
        assertThat(Money.roundHalfUp(new BigDecimal("1.005"))).isEqualTo(Money.of("1.01"));
        assertThat(Money.roundHalfUp(new BigDecimal("-1.005"))).isEqualTo(Money.of("-1.01"));
    }

    @Test
    void equalityIgnoresTrailingZeros() {
        assertThat(Money.of("100")).isEqualTo(Money.of("100.00"));
    }
}
