# CBS Syariah

Core banking system for an Indonesian sharia rural bank (BPRS): customer records, sharia savings and time deposits, murabahah financing, and the general ledger they post to, under OJK supervision and DSN-MUI fatwas.

## Language

### Institutions and governance

**BPRS** (Bank Pembiayaan Rakyat Syariah):
An OJK-licensed sharia rural bank; may take savings and time deposits and extend financing, but offers no current accounts (giro) and no foreign exchange.
_Avoid_: rural bank, BPR

**OJK** (Otoritas Jasa Keuangan):
The Indonesian financial services authority that licenses and supervises the bank and receives its regulatory reports.
_Avoid_: regulator, central bank

**DSN-MUI** (Dewan Syariah Nasional – Majelis Ulama Indonesia):
The national sharia council whose fatwas define what each sharia contract permits.

**Fatwa**:
A DSN-MUI ruling, cited by number, that a product or rule relies on for its sharia validity.

**DPS** (Dewan Pengawas Syariah):
The bank's own sharia supervisory board, which must approve each product and each sharia-relevant parameter change before it takes effect.
_Avoid_: sharia board, compliance

**Dana Kebajikan**:
A fund held apart from the bank's income that receives non-halal or charitable inflows (such as ta'zir) and is disbursed for social purposes.
_Avoid_: charity account, penalty income

### Contracts

**Akad**:
The sharia contract underlying a product or transaction; every account is bound to exactly one akad type.
_Avoid_: agreement, product type

**Wadiah**:
A safekeeping akad: the customer entrusts funds that the bank guarantees and may use, with any return given only as an unpromised bonus.
_Avoid_: current account, demand deposit

**Mudharabah**:
A profit-sharing akad in which the customer supplies capital, the bank manages it, and returns are split by nisbah; the customer bears capital loss not caused by bank negligence.
_Avoid_: interest-bearing deposit

**Murabahah**:
A sale akad in which the bank buys an asset and sells it to the customer at cost plus a margin disclosed upfront, payable in instalments.
_Avoid_: loan, credit

**Wakalah**:
An agency akad by which the bank authorises the customer to buy the murabahah asset on the bank's behalf before the murabahah itself is concluded.

**Urbun**:
A down payment by the customer toward a murabahah, recorded before the murabahah contract.
_Avoid_: deposit, DP

**Muqasah**:
A discretionary discount on the remaining margin, granted by the bank when a murabahah is settled early.
_Avoid_: early-repayment rebate, interest refund

**Ta'zir**:
A late-payment charge imposed on a capable but delinquent customer to instil discipline; it always goes to dana kebajikan, never to income.
_Avoid_: penalty interest, late fee income

**Ta'widh**:
Compensation for an actual, provable loss caused by late payment; out of scope for the MVP.

### Funding

**Funding** (Penghimpunan Dana):
Third-party funds placed with the bank: tabungan wadiah, tabungan mudharabah, and deposito mudharabah.
_Avoid_: deposits (ambiguous with deposito), liabilities

**Tabungan**:
A savings account withdrawable at any time, under either wadiah or mudharabah.
_Avoid_: savings account, current account

**Deposito**:
A mudharabah time deposit with a fixed tenor (1, 3, 6 or 12 months), optionally rolled over at maturity.
_Avoid_: time deposit, fixed deposit, term deposit

**Nisbah**:
The agreed ratio by which a mudharabah's revenue is split between customer and bank (e.g. 40:60); a deposito keeps the nisbah in force at its placement.
_Avoid_: rate, interest rate, yield

**Bagi Hasil**:
The customer's share of revenue credited to a mudharabah account, computed from the pool's revenue, the account's average daily balance, and its nisbah.
_Avoid_: interest, return, profit (alone)

**Revenue Sharing**:
The bagi hasil basis this bank uses: the split is applied to gross financing revenue, before operating costs.
_Avoid_: profit sharing, profit-and-loss sharing (a different basis)

**Bonus Wadiah**:
A discretionary gift credited to wadiah accounts, decided by management after the period ends and never promised beforehand.
_Avoid_: interest, wadiah rate

**PPh Final** (Pajak Penghasilan Final):
Final income tax withheld from bagi hasil and bonus wadiah on balances above the threshold set by tax regulation.
_Avoid_: withholding tax, WHT

### Financing

**Financing** (Pembiayaan):
Funds the bank provides to a customer under a financing akad; in the MVP, murabahah only.
_Avoid_: loan, credit, lending

**Asset Cost** (Pokok):
The portion of a murabahah receivable that repays what the bank paid for the asset.
_Avoid_: principal, loan amount

**Margin**:
The bank's agreed markup in a murabahah, fixed at contract and recognised as income over the instalments.
_Avoid_: interest, profit rate

**Deferred Margin** (Margin Murabahah Tangguhan):
Margin contracted but not yet recognised as income.
_Avoid_: unearned interest

**Kolektibilitas**:
The OJK asset-quality class of a financing, from 1 Lancar to 5 Macet, driven by days past due.
_Avoid_: NPL status, loan grade, bucket

**Performing**:
A financing at kolektibilitas 1 or 2; its margin is recognised on schedule. At 3 to 5 it is **non-performing** and margin is recognised only when paid.

**PPAP** (Penyisihan Penghapusan Aset Produktif):
The provision the bank must set aside against financing, at OJK rates per kolektibilitas.
_Avoid_: loan loss provision, CKPN, impairment

### Ledger and time

**Journal**:
A balanced set of debit and credit lines recording one business event; once posted it is never changed.
_Avoid_: transaction (overloaded), voucher

**Reversal**:
A new journal that exactly offsets an earlier one; the only way to correct a posted journal.
_Avoid_: void, delete, edit

**Journal Template**:
The configured rule for which GL accounts a given transaction type debits and credits.

**Chart of Accounts** (COA):
The bank's GL account structure, following PAPSI and the OJK BPRS reporting format.

**PAPSI** (Pedoman Akuntansi Perbankan Syariah Indonesia):
The Indonesian sharia banking accounting guideline that the COA and accounting treatments follow.

**Business Date**:
The bank's accounting date, which advances only when EOD completes; distinct from the wall-clock date.
_Avoid_: system date, today

**EOD** (End of Day):
The batch that closes a business date (accruals, kolektibilitas, maturities, distributions) and opens the next.
_Avoid_: closing, night batch

### Customers

**CIF** (Customer Information File):
The single record of a customer, individual or entity, to which all their accounts belong.
_Avoid_: client, user, account holder

**NIK** (Nomor Induk Kependudukan):
The national identity number; unique per individual CIF.

**DTTOT** (Daftar Terduga Teroris dan Organisasi Teroris):
The official list of designated terrorists and terrorist organisations that every CIF is screened against.
_Avoid_: blacklist, sanctions list

### Operations

**Vault** (Khasanah):
A branch's cash store, held as its own GL account.

**Till** (Kas Teller):
The cash a single teller holds during a session, drawn from and returned to the vault.
_Avoid_: drawer, cash box

**RAK** (Rekening Antar Kantor):
The inter-branch account through which funds and cash move between branches.
_Avoid_: inter-office account, IBT

**Maker-Checker**:
The rule that a sensitive action entered by one user takes effect only after a second, authorised user approves it.
_Avoid_: dual control, four-eyes

### Reporting

**SLIK** (Sistem Layanan Informasi Keuangan):
OJK's credit information system, to which the bank reports every financing monthly.
_Avoid_: credit bureau, BI checking
