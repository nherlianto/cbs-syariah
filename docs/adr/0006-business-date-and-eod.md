# Business date advanced only by EOD

All accounting runs on a business date held by the system, not the wall clock; it advances only when the EOD pipeline (Spring Batch) completes. EOD performs accruals, kolektibilitas and PPAP, deposito maturity and rollover, and month-end distributions, and must be idempotent and restartable without skipping or double-processing a date. Customer transactions are held while EOD runs, and teller sessions must be closed before it starts. Code reads "today" from the business-date service, never from `LocalDate.now()`.
