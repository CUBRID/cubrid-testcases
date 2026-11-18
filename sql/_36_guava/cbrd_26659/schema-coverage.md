# JIRA4774943 schema coverage

The June 29, 2026 standalone/server-client value comparisons remain historical logical results. They did not prove that literal `ADD ... DEFAULT` rewrote records or demoted a column. The automated cases below distinguish readable defaults, an ALTER-generated write, and a later user UPDATE.

## Source and testcase identity

Engine: `1ef86a7efa34002e971b1b30bcf5d451e9db441b`, Debug GCC, 16 KiB I/O pages / 16344-byte database pages. Starting public TC: `d7bec2fdeb6a19573300e1a624e03e0b87eb9e96`; starting private TC: `a2054f965a20241b87dc9577585ccc8a8cb6ab97`. Engine CCI submodule dirt was preserved. The exact build/install identity was verified before execution.

At that engine revision, `do_update_new_notnull_cols_without_default` in `src/query/execute_schema.c` skips explicit DEFAULT clauses and, with `add_column_update_hard_default=yes`, selects NOT NULL columns without a DEFAULT. `do_run_update_query_for_new_notnull_fields` builds `UPDATE ALL ... SET hard_col=0`. The expression-default worker separately skips `DB_DEFAULT_NONE`. A literal default such as 77 or a folded VARBIT literal does not establish either materialization path.

`cbrd_26659_oos_schema.sql` retains the existing exact-value/rejected-type checks and adds ADD/DROP/default catalog assertions plus an explicit later UPDATE. `cbrd_26659_oos_schema_materialize.sql` adds actual hard-default ALTER materialization and its parameter-off rejection control. Public SQL runs through native JDBC, with `ha_mode=yes`, `test_mode=yes`, serial execution and the project's default JDBC configuration. This does not qualify HA transport.

Private `shell/_40_guava/cbrd_26659_schema_sa` and `cbrd_26659_schema_cs` run the same shared `oos_common/oos_schema.sh` fixture through `csql -S` and `csql -C`. They reuse the existing lifecycle, named-field, SHOW and diagdb helpers; the public JDBC run receives no physical-placement credit from these separate invocations.

## Concern → testcase → assertion → result

| Concern | Testcase / phase | Assertion | Local result |
|---|---|---|---|
| Column reordering | public schema; SA/CS `reorder` | Both complete distinct VARBIT values and all scalar values survive; exact five `def_order` entries | SA/CS and JDBC pass |
| Metadata-only ADD/DROP | public schema; SA/CS `meta-add`, `meta-drop` | New NULL value; name/order/type/precision/nullability; removed attribute absent; surviving values exact | SA/CS and JDBC pass |
| Data-bearing ADD, row rewrite, DROP | public schema; SA/CS `data-add`, `update-rewrite`, `data-drop` | Exact 1200-byte added value, note change, other complete values; added/removed catalog entries | SA/CS and JDBC pass |
| Precision/nullability | public schema; SA/CS `precision`, `nullability` | VARBIT(50000) and NOT NULL; note STRING(40); complete values survive | SA/CS and JDBC pass |
| Explicit literal DEFAULT | both public cases; SA/CS `literal`, `alter-grow-literal` | 77 and full 2500-byte default readable; catalog default=77; grow fixture still has no OOS file | SA/CS and JDBC pass |
| Actual ALTER materialization with existing OOS | public materialize; SA/CS `alter-hard` | ADD hard_col INT NOT NULL without DEFAULT yields 0; both existing OOS values exact; positive named physical file state | SA/CS and JDBC pass |
| ALTER-generated demotion | public materialize; SA/CS `alter-grow-hard` | Literal-only inline fixture becomes exactly one chunk / 3032 slot bytes after ALTER alone; both original/default values and hard 0 exact | SA/CS and JDBC pass |
| OOS-column DROP | public schema; SA/CS `oos-drop` | Dropped attribute absent, every surviving value exact, surviving metadata intact, named OOS file still positive | SA/CS and JDBC pass |
| Later UPDATE-generated demotion | public schema; SA/CS `update-grow-write` | Separate literal-only fixture has no file; subsequent UPDATE creates exactly one chunk / 3032 slot bytes with exact values | SA/CS and JDBC pass |
| Independent controls | public materialize; SA/CS `wrong-value`, `hard-off`; retained mutation runs | Substituted/tail-corrupt values do not match; parameter-off ADD rejected, catalog/data/placement preserved; false value/catalog/chunk expectations must produce NOK | Domain and mutation controls pass |
| Owner and cleanup | SA/CS `owned`, `cleanup` | SHOW class/HFID/VFID matches stopped-server diagdb descriptor; all fixture schemas removed, owned DB/registration/directory gone, config restored | SA/CS pass |

## Oracles and limits

For VARBIT payload sizes 5000 and 4600, each serialized value is payload+8 and its chunk header is 24: `(5000+8+24)+(4600+8+24)=9664` slot bytes. For 3000 bytes, a single selected chain is `3000+8+24=3032`. Unequal 3000/2500 candidates and the fresh one-row fixtures identify the expected larger candidate by its unique slot size. Exact equality covers the complete bit strings; independent Python hashlib checks the lowercase hexadecimal string used by CUBRID MD5. Row counts and DISK_SIZE alone receive no placement credit.

SHOW counts include retained MVCC versions. The existing-OOS fixture therefore asserts positive physical state and exact surviving values, without assuming live-chain counts, chain identity/reuse, or immediate DROP reclamation. Diagdb establishes owning file association; it does not independently map every surviving column to a stub. No crash/recovery, concurrency, vacuum/reclamation, SA loaddb, HA transport or JDBC physical-placement claim is made.

The accepted four-record target is 4060 bytes; this source retains the known raw-quarter-page 4086-byte gate. These fixtures stay well away from that boundary and do not close the separately recorded target conformance gap.

## Retained verification

Records and drivers: `/home/vimkim/tmp/sc338`. Every native invocation retains source/TC identities and file hashes, installation/JDBC/testkit identity, effective config, manifest, command, timing, combined log, summary/XML/per-case verdict artifacts and owned cleanup receipts. Shell logs retain raw SHOW and diagdb output. The initial source/install mismatch was corrected by an exact-head rebuild. An initial SQL preparation attempt lacked a prebuilt locale library; it dispatched no cases and receives no pass credit.

The first shell run `/home/vimkim/tmp/s338-sh01` correctly rejected the mistakenly authored catalog type VARCHAR; historical catalog output and the catalog source identify STRING. The corrected `/home/vimkim/tmp/s338-sh02` native run executed both identities: 2/2 pass, 94 assertions, zero failures/skips, artifact verifier pass and cleanup pass. The native JDBC run `/home/vimkim/tmp/s338-sql02` passed both exact identities (2/2, zero failures, complete XML/results and verifier pass); cleanup passed. It retained 16 KiB pages, HA/test mode enabled and the default JDBC profile. The earlier `/home/vimkim/tmp/s338-sql01` preparation failed before dispatch because the selected install lacked a prebuilt locale library; `/home/vimkim/tmp/s338-sql02` built it normally.

| Independent negative attempt | Deliberately false oracle | Artifact result | Cleanup |
|---|---|---|---|
| `/home/vimkim/tmp/s338-nvalue` | Full-value predicate adds an altered last byte | One NOK at initial exact value assertion; native verifier rejects | Pass |
| `/home/vimkim/tmp/s338-ncatalog02` | Expected literal catalog default 78 instead of 77 | One NOK at literal catalog assertion; native verifier rejects | Pass |
| `/home/vimkim/tmp/s338-nplacement` | ALTER expects two chunks instead of one with unchanged slot bytes | One NOK at ALTER physical model; native verifier rejects | Pass |
| `/home/vimkim/tmp/s338-ngolden` | First independently computed JDBC MD5 replaced by zero digest | One golden mismatch and no other output differences; native verifier rejects | Pass |

`/home/vimkim/tmp/s338-ncatalog` failed during negative-copy preparation before execution (two matching source strings); it receives no negative-test credit. The corrected attempt changes only the first matching oracle. Original testcase files remained unchanged by all negative runs. The negative runners returned process status 0 despite testcase failure; verdict-bearing artifacts and the verifier correctly rejected them.

Final native shell `/home/vimkim/tmp/s338-sh03` passed both identities, 98 assertions, zero failures/skips, complete verifier artifacts and owned cleanup. It adds checks of all surviving metadata after OOS-column DROP and the hard-default attribute catalog in the discriminating ALTER fixture. Bash syntax and ShellCheck passed. Answer-file trailing spaces follow the existing JDBC golden format.

Two-axis review against the recorded starts found no Standards findings and one public Spec gap: the final OOS-column DROP check omitted id and surviving metadata. It was repaired with an id predicate and an independently expected 5/5 catalog assertion. `/home/vimkim/tmp/s338-sql03` reran both JDBC identities: 2/2 pass, zero failures, complete native artifacts/verifier and cleanup pass. The final SQL inputs/answers are bound by SHA-256 to the published commit; the public materialization negative golden was unaffected by this repair.
