# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A core banking system for a single Indonesian **BPRS** (sharia rural bank), built as a pilot with production-grade foundations. It operates under OJK regulation, DSN-MUI fatwas, and PSAK 101–112 / PAPSI accounting. MVP products: tabungan wadiah, tabungan mudharabah, deposito mudharabah, and murabahah financing.

- `GLOSSARY.md` is the domain vocabulary. Read it before naming anything, and use its terms in code, comments, and conversation.
- `docs/adr/` records the architectural decisions. Read the relevant ADR before changing ledger, persistence, module boundaries, EOD, profit sharing, or deployment.

## Commands

```bash
docker compose -f infra/docker-compose.yml up -d   # Postgres :5432, Keycloak :8180 (realm "cbs", dev users teller1/spv1)
./gradlew build                                    # compile + all backend tests (needs JDK 21 and Docker for Testcontainers)
./gradlew :backend:test --tests 'id.cbs.syariah.shared.MoneyTests'   # one test class
./gradlew :backend:bootRun
cd frontend && npm run dev | npm run build | npm run lint
```

## Stack and layout

Java 21, Spring Boot 4.1, Gradle (Kotlin DSL), Spring Modulith, PostgreSQL, Flyway, jOOQ / Spring Data JDBC (JPA is excluded; see ADR 0004), Spring Batch for EOD, Keycloak (OIDC), and a React + TypeScript (Vite) back office. Tests use JUnit, Testcontainers, and jqwik.

```
backend/   one Spring Boot app; one package per module: ledger, customer, deposit,
           financing, profitsharing, teller, fee, shariagovernance, eod,
           reporting, migration, audit
frontend/  React + TS back office (teller and back-office staff only)
infra/     docker-compose (Postgres, Keycloak), images, deployment
docs/adr/  decisions
```

Modules call each other only through a module's public API or application events, and each module owns its own tables. `ModularityTests` enforces this. `shared` is the only module every other module may depend on, and it holds value types only.

Spring Batch is added together with the `eod` module, as `spring-boot-starter-batch-jdbc`, with its schema managed by Flyway rather than auto-initialised.

## Ledger invariants

Every change that moves money preserves all of these:

- **Atomic posting.** The subledger change and its balanced journal commit in the same DB transaction, through the ledger module's posting API.
- **Append-only.** A posted journal is corrected by a reversal journal.
- **Balanced.** Debits equal credits for every journal.
- **Templated.** GL accounts come from the configured journal template for the transaction type, never from accounts hard-coded in code.
- **Money.** Amounts use the `Money` type (`BigDecimal`, IDR) and are stored as `NUMERIC(19,2)`. Intermediate calculations keep full precision and round once, half-up, at posting time; the remainder goes to the rounding GL account.
- **Business date.** "Today" comes from the business-date service, never the wall clock. EOD steps are idempotent and restartable.

## Sharia rules the code must encode

- Murabahah has **margin**, mudharabah has **nisbah** and **bagi hasil**, wadiah has a **bonus**. The code never models any of them as interest.
- Bagi hasil uses **revenue sharing** (ADR 0005). A deposito keeps the nisbah in force at its placement. Nisbah is versioned, and history is never overwritten.
- Bonus wadiah is set after the period through maker-checker, and 0 is valid. Rates are never shown in advance.
- **Ta'zir** is posted to dana kebajikan, never to income.
- Murabahah margin is recognised on schedule while the financing is performing (kolektibilitas 1–2), and only when cash is received at 3–5.
- Muqasah (early-settlement discount) always goes through maker-checker approval.
- A product, or any sharia-relevant parameter (akad, nisbah ranges, fees on mudharabah, bonus policy), activates only after it carries a **DPS approval** that cites its fatwa.
- Monthly fees apply to wadiah accounts. On mudharabah accounts they stay disabled unless the DPS approves them.

## Compliance constraints

- Customer data and production systems stay in Indonesia (ADR 0007). That includes any third-party logging, monitoring, or AI service.
- Every action, including viewing customer data, is written to the audit log with user, branch, business date, and timestamp.
- Staff see only their own branch's data unless they hold an HQ role.
- Sensitive actions (account opening, financing disbursement, reversals, parameter changes, over-limit cash) require maker-checker approval.

## Testing financial logic

- Each calculation (bagi hasil, bonus wadiah, schedules, margin recognition, PPh, PPAP, rounding) has golden test cases. Their expected values come from hand-worked figures signed off by the sharia/accounting expert. When a golden test fails, the code must be fixed to produce the signed-off figure; the expected value changes only through a new sign-off.
- Ledger invariants have jqwik property tests.
- Behaviour that spans days is covered by EOD scenario tests that run across several business dates.
