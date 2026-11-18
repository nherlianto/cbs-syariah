# Explicit SQL (jOOQ / Spring Data JDBC) instead of JPA for persistence

Spring teams default to JPA/Hibernate. We don't: ledger correctness depends on knowing exactly which statements run, in what order, under which locks. JPA's dirty checking, flush ordering and lazy loading hide that. jOOQ (or Spring Data JDBC for simple aggregates) keeps every write visible and lets us use row locks and PostgreSQL features directly.
