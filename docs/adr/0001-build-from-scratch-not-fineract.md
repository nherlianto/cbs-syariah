# Build the core from scratch rather than adapting Apache Fineract

Fineract is the obvious open-source Java core, but its loan engine is built around interest schedules. Murabahah (cost plus fixed margin, recognised per PSAK 102 and switched to cash basis when non-performing) and mudharabah revenue sharing on funding would mean fighting its core model rather than configuring it. We build our own ledger and product engine on Spring Boot, scoped narrowly to the BPRS MVP products.
