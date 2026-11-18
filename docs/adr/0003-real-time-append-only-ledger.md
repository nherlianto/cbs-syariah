# Real-time, append-only double-entry ledger

Every business event posts a balanced journal to the general ledger inside the same database transaction as the subledger change, rather than accumulating in subledgers for an end-of-day GL batch. Journals are append-only: corrections are reversals, never updates or deletes. This removes subledger-to-GL drift by construction and gives auditors a complete trail; the cost is that every write path must go through the ledger module's posting API.

## Consequences

- Debits must equal credits for every journal, enforced in the database as well as in code.
- Postings use journal templates held as configuration, so accountants can review and change GL mappings without code changes.
