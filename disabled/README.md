# Disabled OOS testcases for PR #8128

## Current selection, 2026-10-30

All 28 OOS SQL cases are enabled. The current [manifest](oos-pr8128.tsv)
has no disabled entries. The three previously disabled SQL inputs were restored
unchanged after their paired answers were updated at four error-number records.
The current Engine `e3589ae42d42b04eb020e1ae43e165b01d31b12a` defines
`ER_HEAP_OOS_OVERPASS_MAXOBJ_SIZE` as `-1388`; the old answers expected `-1384`.
All other expected output is unchanged. Native JDBC runs of the three cases
passed with zero failures or skips, followed by owned-process cleanup checks.
The other 25 pairs are unchanged and were not rerun in this focused validation.
This does not certify the whole SQL corpus or complete Work456.

The original failure inventory is retained in
[TC revision 45e21ad](https://github.com/CUBRID/cubrid-testcases/blob/45e21ad799d82ebadc04a93c7d2f69517d53bf39/disabled/oos-pr8128.tsv).
Its recorded FAIL results remain historical evidence. The sections below record
the original disabling decision and do not describe the current selection.

## Historical disabling decision, 2026-10-26

Owner decision: 2026-10-26. Scope: OOS tests in Engine PR #8128 only.
Disable failing cases and separate cases whose measured individual runtime is
strictly greater than **60 seconds**. This is an execution-selection change;
it does not repair defects or turn the recorded FAIL results into passing coverage.

### Historical selection

| Disposition | Cases |
| --- | ---: |
| Failed in the recorded run | 3 |
| Over 60 seconds | 0 |
| Both failed and over 60 seconds | 0 |
| Distinct disabled cases | 3 |

The [historical manifest](https://github.com/CUBRID/cubrid-testcases/blob/45e21ad799d82ebadc04a93c7d2f69517d53bf39/disabled/oos-pr8128.tsv) records every original path, disabled path,
observed verdict, runtime in seconds, reason, and original entry-file SHA-256.
Entries with both reasons are stored under `long_running/`; `failing/` holds
the remaining failing entries. Cases at or below 60 seconds are not slow.

Only disabled entry files and paired SQL answers move here. Shell companion
fixtures and shared helpers remain at their original paths for retained cases.
Entry files retain their contents and have a `.disabled` suffix. SQL answers
retain their contents. No expected answer, assertion, or engine source was changed.

### Historical CI evidence

- Run: [40311481032](https://github.com/CUBRID/cubrid/actions/runs/40311481032), attempt 1.
- Engine: `c4c4f5c5ed55fb0130c72bb261061ec441662554`.
- Public TC: `58c6656b857ff9d69c48847ebf6de8372ba93aa3`.
- Private TC: `10a8fc82d34cd2c54c2caa403886e3528852d6fe`.
- CTP: `7dc9f4192bb96988d1bab78df3e45df88628b814`.
- The timings are individual testcase durations, excluding the runner queue.

All 28 OOS SQL cases ran in shard 09. That shard's 465 identities,
verdicts, and timings reconcile between `summary_info` and JUnit; its three
failed names also match `collect/failed.list`. The build and TC receipts
identify the revisions above. The three failed OOS cases are disabled;
the other 25 remain enabled. No OOS SQL case exceeded 60 seconds; the
maximum recorded duration was 0.797 seconds, so no SQL entry is moved
to `long_running/`.

The **full SQL collection remains unvalidated**. In shard 01, `summary_info`
contains 3,533 records while JUnit contains 3,531. The two additional names
are the non-OOS CBRD-27556 `33_static_sql_group_by_having_alias.sql` and
`33_static_sql_group_by_having_alias_error.sql` cases. This document uses
the independently reconciled OOS shard only; it does not override that
collector error, establish a full-suite verdict inventory, or assign a cause.

## Discovery and restoration

Regular CI discovers shell entries below `shell/` and SQL entries below `sql/`.
This directory is outside both roots. The additional `.disabled` suffix also
prevents an entry from matching `*/cases/*.sh` or `*/cases/*.sql`.
No runtime skip, alternate passing answer, or new helper is used.

To re-enable a case, review its recorded failure or runtime first. Move the
manifest's `disabled_path` back to `original_path`, thereby removing the suffix.
For SQL, also move the paired answer from `disabled/failing/sql/.../answers/`
back to its original `sql/.../answers/` path. Restore the entry before a focused
native run: its relative fixture and helper paths intentionally retain the
original layout. Check the intended oracle and owned cleanup, then update this
manifest and the counts. Re-enabling a long-running case also needs an explicit
decision about its regular or separately scheduled execution.

Disabled failures retain their recorded FAIL status and receive no passing
coverage credit. Work456 remains incomplete. Performance comparison and HA #463
remain deferred. TC PR merge, closure, and branch deletion remain human actions.
