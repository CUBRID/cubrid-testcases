# CBRD-26659 OOS SQL regression scope

Decision recorded on 2026-10-12 for Engine PR8128 and public TC PR3688.
Failure snapshot: [run38245729674, attempt 1](https://github.com/CUBRID/cubrid/actions/runs/38245729674), Engine `a5da823b2a84e95b4b22d48abe4a3f9fd601c176`, public TC `1a556a0752073aaad573bf87d53f3eb75f398138`.

## Agreed repair scope

Review all latest SQL and shell failures and repair every remaining failure after excluding:

1. Same-signature failures already observed in the original testcase corpus on `feature/oos-merge`.
2. Previously documented expected-failing OOS reproducers that retain their correct success expectations.

Applying these rules leaves **14 SQL failures in scope**. The full [partition movement testcase](cases/cbrd_26659_oos_partition.sql) is the previously documented expected-failing SQL reproducer. All five latest shell failures are excluded: one existing CDC27064 failure and four retained OOS reproducers.

The 14 in-scope SQL files are:

- [Partition routing](cases/cbrd_26659_oos_partition_routing.sql)
- [Representation](cases/cbrd_26659_oos_representation.sql)
- [Schema](cases/cbrd_26659_oos_schema.sql)
- [INSERT SELECT](cases/cbrd_26659_oos_sql01_insert_select.sql)
- [DELETE](cases/cbrd_26659_oos_sql04_delete.sql)
- [UPDATE](cases/cbrd_26659_oos_sql04_update.sql)
- [Bigone rejection](cases/cbrd_26659_oos_sql05_bigone.sql)
- [Constraints](cases/cbrd_26659_oos_sql05_constraints.sql)
- [Transactions](cases/cbrd_26659_oos_sql05_transactions.sql)
- [Triggers](cases/cbrd_26659_oos_sql06_triggers.sql)
- [Read paths](cases/cbrd_26659_oos_sql07_read_paths.sql)
- [LOB copy](cases/cbrd_26659_oos_sql09_lob_copy.sql)
- [LOB maximum columns](cases/cbrd_26659_oos_sql09_lob_maxcols.sql)
- [Storage policy](cases/cbrd_26659_oos_storage_policy.sql)

These files failed at initial DDL following the partition assertion in the recorded run. Cascading failure is suspected; the cause and repair remain unverified. The representation testcase above belongs to the intended passing selection and is distinct from the separately retained representation target reproducer.

An exclusion records repair scope. Test execution remains enabled and expected answers remain intact. Expected SQL errors asserted inside a passing testcase remain required checks. Source-tree equality with the baseline does not automatically exclude newly added testcase failures.

Hypothesis patches may be used for diagnosis. A final repair requires correct answers/assertions, evidence explaining the failing path, and meaningful before/after controls.

If the excluded partition defect is demonstrated to cause cascading failures in the 14 in-scope SQL cases, repair of the shared cause needed to restore those cases is allowed. This does not require resolving every retained partition defect or extend the repair scope to other excluded cases.

## Tracking

The complete 20-failure table, reasons, evidence and verification state are maintained in the companion `my-cubrid-docs` checkout at:

`cbrd-26659/ci-repair/README.md`

Update that table after each verified attempt, preserving the run/revision identity and recording unresolved outcomes. Update this summary when the agreed scope changes. The README documents decisions; the runner's execution configuration determines actual selection.
