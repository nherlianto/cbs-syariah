package id.cbs.syariah.shared;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Objects;

/**
 * An IDR amount at posting precision (2 decimal places).
 *
 * <p>Calculations run on {@link BigDecimal} at full precision and become Money exactly once,
 * through {@link #roundHalfUp(BigDecimal)}. Constructing Money from a value with more than two
 * decimal places fails, so rounding is always explicit.
 */
public record Money(BigDecimal amount) implements Comparable<Money> {

    public static final int SCALE = 2;
    public static final Money ZERO = new Money(BigDecimal.ZERO);

    public Money {
        Objects.requireNonNull(amount, "amount");
        if (amount.stripTrailingZeros().scale() > SCALE) {
            throw new IllegalArgumentException(
                    "Money has at most " + SCALE + " decimal places; round explicitly: " + amount);
        }
        amount = amount.setScale(SCALE, RoundingMode.UNNECESSARY);
    }

    public static Money of(String amount) {
        return new Money(new BigDecimal(amount));
    }

    public static Money of(long rupiah) {
        return new Money(BigDecimal.valueOf(rupiah));
    }

    /** The single rounding step from a full-precision calculation to a postable amount. */
    public static Money roundHalfUp(BigDecimal unrounded) {
        return new Money(unrounded.setScale(SCALE, RoundingMode.HALF_UP));
    }

    public Money plus(Money other) {
        return new Money(amount.add(other.amount));
    }

    public Money minus(Money other) {
        return new Money(amount.subtract(other.amount));
    }

    public Money negate() {
        return new Money(amount.negate());
    }

    public boolean isZero() {
        return amount.signum() == 0;
    }

    public boolean isNegative() {
        return amount.signum() < 0;
    }

    @Override
    public int compareTo(Money other) {
        return amount.compareTo(other.amount);
    }

    @Override
    public String toString() {
        return "IDR " + amount.toPlainString();
    }
}
