package id.cbs.syariah.shared;

import static org.assertj.core.api.Assertions.assertThat;

import net.jqwik.api.ForAll;
import net.jqwik.api.Property;
import net.jqwik.api.constraints.LongRange;

class MoneyProperties {

    @Property
    void plusThenMinusIsIdentity(
            @ForAll @LongRange(min = -1_000_000_000_000L, max = 1_000_000_000_000L) long aSen,
            @ForAll @LongRange(min = -1_000_000_000_000L, max = 1_000_000_000_000L) long bSen) {
        Money a = new Money(java.math.BigDecimal.valueOf(aSen, 2));
        Money b = new Money(java.math.BigDecimal.valueOf(bSen, 2));
        assertThat(a.plus(b).minus(b)).isEqualTo(a);
    }

    @Property
    void negationSumsToZero(@ForAll @LongRange(min = -1_000_000_000_000L, max = 1_000_000_000_000L) long sen) {
        Money a = new Money(java.math.BigDecimal.valueOf(sen, 2));
        assertThat(a.plus(a.negate()).isZero()).isTrue();
    }
}
