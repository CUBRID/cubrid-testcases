# sql writing rules

These *writing rules* say how to write the files of a TC under `sql/`. What a TC checks is in the [*test perspectives*](test-perspectives.md).

## New TC

### Place and files

**Put the TC of an issue whose Jira type is Correct Error under `sql/_13_issues/_<yy>_<1|2>h/` for the half-year in which you write the TC.** The day you write the TC picks the directory, not a date on the issue, for developers and QA alike. What the directories hold is in [Operational facts](../AGENTS.md#operational-facts). Example: a Correct Error issue created on 2026-08-03 gets `sql/_13_issues/_27_1h/cases/cbrd_xxxxx.sql` when you write its TC on 2027-02-10.

**Put the TC of any other issue under the code-name directory `_<no>_<codename>/` of the Jira version that the issue is planned for or fixed in.** A TC of a Correct Error issue stays under `_13_issues/` even when the issue names a version. Example: an Improve issue with the fix version `guava` gets `sql/_36_guava/cbrd_xxxxx/cases/cbrd_xxxxx.sql`, and a TC that extends an existing feature directory goes into it, such as `sql/_35_fig_cake/grant_revoke_redefine/cases/`.

**Put the scenarios of one issue in one file, and split them into files `cbrd_xxxxx_<keyword>.sql` only when the scenarios need different *setup* or when one file would run long or hold the large data that the [test perspectives](test-perspectives.md#plans-hints-and-data-size) tell you to avoid.** One file creates the shared tables and data once, and its *evaluate labels* show in the *answer file* which case failed. Many queries alone are no reason to split. The keyword says why the file is split, by its setup or its scenario. Example: `cbrd_xxxxx_partition.sql` and `cbrd_xxxxx_heap.sql`, because one scenario needs a partitioned table and the other a large heap, not `cbrd_xxxxx_1.sql` and `cbrd_xxxxx_2.sql`.

**Name the `.sql` file `<TC directory>/cases/<name>.sql` and its answer file `<TC directory>/answers/<name>.answer`, with the same `<name>`, and commit both, with an answer file that is not empty.** CTP skips a `.sql` file that has no answer file, and an answer file without its `.sql` file or without content checks nothing. Example: `sql/_13_issues/_26_2h/cases/cbrd_xxxxx.sql` and `sql/_13_issues/_26_2h/answers/cbrd_xxxxx.answer`.

**Keep in `cases/` and `answers/` only the files that CTP reads: `.sql`, `.queryPlan`, `.answer`, and `.answer_<run mode>` files such as `.answer_cci`.** CTP takes only the `.sql` files of `cases/` as SQL cases, so a log, a backup, or a temporary file there runs nothing and stays as noise. The outputs that CTP writes on a run are in [The PR](../AGENTS.md#the-pr). The `.master.slave1.diff_1` files of the HA replication test are the exception. Example: `cases/cbrd_xxxxx.sql` and `answers/cbrd_xxxxx.answer`, without `cases/ConsoleBO.log`, `cases/cbrd_xxxxx.sql.bk`, or `answers/cbrd_xxxxx.answer.back`.

**Save `.sql` files and answer files as UTF-8 without a BOM and with LF line ends, and write a control character inside a string with an escape or a function such as `chr(13)`.** The JDBC run of CTP reads a CR as a line end, but the CCI run, the `sql_by_cci` test of CTP, splits the statements at other places, so a CR in a file can pass one run and write a wrong `.answer_cci`. A copy through Windows or a save in an editor can change the line ends, the encoding, and the spaces at line ends. Example: `insert into t values ('a' || chr(13) || 'b');`, not a literal that holds a raw CR, and the answer file copied on the Linux host where CTP ran.

### Header and labels

**Start a new TC file with one *header block* that names the issue key, says what the TC checks, and lists its cases under `Coverage:`, with no `--` inside it.** The header block is one `/** … */` comment. The reviewer and the next person who changes the TC read from the block which issue the TC reproduces and what each case checks. CTP drops each line that starts with `--`, inside the block as well, so the block that reaches the server is not the block you wrote. The block follows the rule for block comments in [Statements and comments](#statements-and-comments) as well. Example:
```sql
/**
 *  This test case verifies CBRD-XXXXX: <title of the issue>
 *
 *  <what the fix changed, and how the cases check it>
 *
 *  Coverage:
 *    Case 1:  <expected behavior of case 1>
 *    Case 2:  <expected behavior of case 2>
 */
```

**Start each case with `evaluate 'Case N: <expected behavior>';`, number N from 1 in order, and give each label the case and the expected behavior of its line in `Coverage:`.** CTP prints the *evaluate label* into the answer file, where it shows which case a changed line belongs to. A comment banner never reaches the answer file, and a `select '…'` label also gets a plan when the file asks for plans. The words of a label and its Coverage line can differ, and a label can end with the expected result after `; result =`. Example: `evaluate 'Case 2: a range bounded by a subquery stays serial; result = parallel(0)';` for the Coverage line `Case 2:  a range bounded by a subquery stays serial`, not `evaluate 'Case B';`, `select 'case 2' from db_root;`, or `-- ===== case 2 =====`.

**Write `evaluate` labels, and the string literals that a TC only prints, in ASCII.** A non-ASCII character can print differently in another environment and in the CCI run. Example: `evaluate 'Case 3: open and closed ranges - both ends';` with a hyphen, not with an em dash.

**Make every label, comment, and line of the header block say what its query and its answer file actually show.** The reviewer and the next person read the labels and the header as the claims of the TC, and a label that its query does not meet hides a case that checks nothing. Example: when the data keeps the scan of `Case 3: the index scan runs in parallel` serial, change the data until the plan shows a parallel scan, or change the label.

**Write in a comment each premise that the statements do not show, such as a hint that every query shares, a CTP setting that a result depends on, or a state that one case leaves for the next, and why a case differs from the cases beside it.** A person who changes one case cannot see these premises in its statement and breaks the cases that depend on them. Example: `-- Case 5 reads the rows that Case 4 inserted` and `-- unlike Case 2, no index hint: this case checks the plan that the optimizer picks`.

### Statements and comments

**End each statement with `;` at the end of a line, write no comment after the `;` on that line, and end the last statement of the file with `;` too.** CTP ends a statement only at a line that ends with `;`, so `select …; -- note` runs together with the next statement and fails with `Error:-493`, and a last statement without `;` never runs. Example: `-- expect 3 rows` on its own line and then `select a from t order by a;`, not `select count(*) from t; -- expect 3`.

**Write no `;` and no `'` inside a `/* */` block comment, the header block included.** CTP drops a line that starts with `--` but sends the lines of a block comment with the statement after it: a comment line that ends with `;` ends the statement there, and a `'` in a block comment has failed the first statement of a file with `Error:-493`. List items on new lines or after `-`. Example: `/* Case 2 - rename must fail */`, not `/* do not drop t1; t2 stays */`, `/* don't drop t1 */`, or `/* masks digits to '?' */`.

**Write none of `autocommit on`, `autocommit off`, `holdcas on`, `holdcas off`, `server-message on`, and `server-message off` inside a statement, a block comment, or a string literal.** CTP searches the whole text of each statement, its comments and literals included, for these words, and runs a statement that has them as a control line, with no output. Example: `keeps the CAS with the holdcas control line` in the header block, not `--+ holdcas on / off to keep the same CAS`; and not `select 'autocommit off' from db_root;`.

**Write each CTP control line alone on its line in its fixed form, and turn off by the end of the file each control that the file turned on.** The forms are `autocommit off;` and `autocommit on;`, `--+ holdcas on;` and `--+ holdcas off;`, and `--+ server-message on` and `--+ server-message off`. A control line in another form, such as `-- holdcas on`, is a plain comment that CTP drops. Example:
```sql
--+ holdcas on;
call login('dba', '') on class db_user;
--+ holdcas off;
```

**Put the bind values of a statement on the line right before it as `$<type>, $<value>` pairs, and start no other line with `$`.** CTP reads a line that starts with `$` as the bind values of the statement it is reading and leaves that line out of the statement, and a type without its value stops the file with `parameters is invalid in sqlFile`. Example: `$varchar, $2002-03-03` and then `select dayofweek(?) from db_root;`, and `$OUT:INTEGER, $` for an OUT parameter; not `$int, $1, $int`.

**When the data of a TC must pass a *threshold*, write its row count, its page count, the threshold, and the reason in `--` lines of their own above the statement that creates the data.** CTP drops a line that starts with `--`, while a comment on a line of a statement goes into the statement that CTP reads, with the effects that the `;` rule of [Statements and comments](#statements-and-comments) names. How far above the threshold the data goes is in the [test perspectives](test-perspectives.md#plans-hints-and-data-size). Example:
```sql
-- 100,000 rows of 168 bytes: 1,177 heap pages, past the parallel heap scan threshold of 32 pages under CTP, so that a scan of t_heap runs in parallel
create table t_heap (id int, pad varchar(128));
insert into t_heap select rownum, sha2(rownum, 512) from db_class a, db_class b, db_class c, db_class d limit 100000;
```

### Plans and traces

**In a new TC, ask for a plan with a `--@queryplan` line right before each statement whose plan a case checks, and add no `.queryPlan` file.** A `.queryPlan` file asks for the plans of the whole file, and the JDBC run of CTP puts them only on statements that start with `SELECT` while the CCI run puts them on every result set, so `.answer` and `.answer_cci` drift apart. Example: `--@queryplan` and then `select a from t_heap where id < 10 order by a;`, with no `cbrd_xxxxx.queryPlan` beside the `.sql` file.

**Write a plan directive as a line that holds exactly `--@queryplan`, `--@fullplan`, or `--@joingraph`, in lowercase and with nothing after it.** CTP compares the whole line with these three strings, and a line in another form is a plain comment that CTP drops, so the answer file gets no plan. Example: `--@queryplan`, not `-- @queryplan`, `--@queryPlan`, `--@queryplan;`, or `--@queryplan check index`.

**Check the plan of a statement with bound values through SQL-level `PREPARE` and `EXECUTE … USING`, with `show trace` after the `EXECUTE` or with `--@queryplan` before the `PREPARE` and the `EXECUTE`, not through a `$` line and a statement with `?`.** CTP takes the plan of a statement with `?` from its own run, and that plan can be missing: a later run of the same `SELECT` with other values printed no plan, and a statement with `?` that starts with `WITH` or `(` runs through a call that returns no plan. A SQL-level `EXECUTE` is a plain statement, and CTP asks for its plan after the run. Example:
```sql
--@queryplan
prepare q1 from 'select n, min(n2) from foo where n2 between ? and ? group by n';
--@queryplan
execute q1 using 0, 1;
deallocate prepare q1;
```

**In a TC whose answer file holds a plan or a trace, name tables, indexes, and columns so that they differ in letters, not only in digits.** CTP replaces the numbers of a plan and a trace with `?` ([test perspectives](test-perspectives.md#what-sql-tcs-cannot-check)), so `idx1` and `idx2` both print as `idx?`, and a change from one index to the other goes unseen. Example: `i_heap_rem` and `i_heap_id`, or `t_drv` and `t_inner`, not `idx1` and `idx2`, or `t1` and `t2` in a check of the join order.

### Cleanup

**Keep each TC atomic, so that it affects neither the TC before it nor the TC after it, and restore the state it started from as soon as it ends.** The rules of this section and the rule on control lines in [Statements and comments](#statements-and-comments) are how a TC does it. Example: a TC that creates a table, sets a system parameter, and runs `set trace on;` ends with `drop table`, `set system parameters '<name>=default';`, and `set trace off;`, so the next TC starts from the same state as this one did.

**Drop each object with `DROP … IF EXISTS` before you create it, except an object whose `DROP` has no `IF EXISTS`, such as a user, and drop at the end of the file every object that the file created.** CTP runs the files of a run one after another in one database ([Before the PR](../AGENTS.md#before-the-pr)), so an object that one file leaves behind breaks a file after it, and the first drop clears an object of the same name that an earlier file or run left. `DROP USER`, `DROP TRIGGER`, `DROP PROCEDURE`, and `DROP FUNCTION` take no `IF EXISTS`, so a first drop of such an object prints an error or succeeds depending on what an earlier file left, and the answer file differs between the two. A dropped table takes its indexes with it. Example: `drop table if exists t_heap, t_small;` before `create table t_heap …` and `drop table t_heap, t_small;` at the end; `create user u_reader;` with no `drop user u_reader;` before it, and `drop user u_reader;` at the end.

**At the end of the file, set back every system parameter and session setting that the file changed: parameters with `set system parameters '<name>=default'`, and also `set trace`, the isolation level, `set names`, and the optimization level.** Before each file CTP resets only the parameters on a fixed list, so any other change stays for the files after it, and an optimization level left changed has hung CI. Example: a file that runs `set system parameters 'pl_transaction_control=yes';` and `set trace on;` ends with `set system parameters 'pl_transaction_control=default';` and `set trace off;`.

**Release each name that the file prepares with `deallocate prepare <name>` or `drop prepare <name>` in the same file.** Example: `prepare q1 from 'select * from t where a = ?';` and, after its last `execute q1`, `deallocate prepare q1;`.

### Answer files

**Make the answer file by running the `.sql` file in CTP and copying its whole result file, never by editing the answer file by hand, and change a `.sql` file and its answer file in the same PR.** CTP compares the whole result with the answer file as one string after it removes only CR and LF ([test perspectives](test-perspectives.md#what-sql-tcs-cannot-check)), so one space of column padding fails the run, and an editor that removes the spaces at line ends breaks the answer file the same way. Which build makes the answer file is in [Before the PR](../AGENTS.md#before-the-pr). Example: run `run cbrd_xxxxx.sql` in the interactive mode of CTP and then `cp cases/cbrd_xxxxx.result answers/cbrd_xxxxx.answer`; after a fix of a label in the `.sql` file, run it again instead of fixing the label in the answer file.

**After you make or change a `.answer` file, run the `.sql` file again with `run_cci` in the interactive mode of CTP, and when the output differs, add a `.answer_cci` file, or change the existing one together with the `.answer` file.** The CCI run runs the same `.sql` files through the CCI driver and compares each with its `.answer_cci` file when one exists and with its `.answer` file otherwise. Example: `run_cci cbrd_xxxxx.sql` prints a plan that `run cbrd_xxxxx.sql` did not, so `answers/cbrd_xxxxx.answer_cci` goes into the same PR as `answers/cbrd_xxxxx.answer`.

**Leave an `Error:` line in the answer file only for an error that a case means to cause, and say in its label or a comment that the error is expected.** An error from a mistake in the file, such as a typo in the setup, puts the mistake into the answer file. Example: `evaluate 'Case 4: a negative length fails with an error';` right before the statement whose answer is `Error:-NNN`; a setup statement that prints `Error:-494` because its table already exists gets fixed.

**Keep the output of any bug other than the one the TC tests out of the answer file: first change the scenario so that it avoids that bug, or leave the scenario out until that bug is fixed.** An answer file that holds a bug's output passes only while the bug stays, and the fix of that bug turns the TC into a failure. Example: a scenario whose query returns wrong rows because of another open issue waits for the fix of that issue, and you file the issue when nobody has.

**Only when the scenario can neither avoid a bug other than the one the TC tests nor be left out, file an issue for that bug, add the line `Case N: known wrong result, CBRD-NNNNN (open)` to the header block, keep the output in the answer file as a *known wrong result*, and update the answer file when that issue is closed.** The line in the header block tells the reviewer why the answer file holds a wrong value and tells the next person when to update it. Write no `-- BUG` comment before the statement, and write the correct result neither in a comment nor in the line of the header block. The answer file holds what the build prints now. Example: the TC whose Case 3 prints a plan that an open optimizer issue changes has ` *  Case 3: known wrong result, CBRD-YYYYY (open)` in its header block and no `-- BUG` line before Case 3.

## Changing an existing TC

**Bring a TC you change in line with the [New TC](#new-tc) section and the rules below, and leave a TC that you have no other reason to change as it is.** Changes made only for the *rulebook* touch many passing TCs at once, while a TC under change gets a review that can check these rules too. Example: a PR that fixes the `ORDER BY` of `cbrd_xxxxx.sql` also starts each of its cases with `evaluate 'Case N: …';`, and no PR changes the labels of fifty TCs that need nothing else.

[Operational facts](../AGENTS.md#operational-facts) says which Jira issue an old TC named `bug_bts_<NNNN>.sql` belongs to. A change of an answer file also follows [The PR](../AGENTS.md#the-pr) in `sql/AGENTS.md` and the known wrong result rule of [Answer files](#answer-files).

**When you fix an unstable or broken existing TC, keep the tables and queries of its scenario and change only the output that is not deterministic, and when the scenario itself must change, ask the developer of its issue to review the change.** The scenario is what reproduces the issue, and a new scenario can miss the *bug path*. A new form of the scenario can go into a file of its own beside the old one, named as in [Place and files](#place-and-files). A scenario that a change of the engine specification made invalid can change without that review. Example: a TC whose plans now change with the page count keeps its tables and queries and checks only the results of those queries; its PR asks the developer of CBRD-XXXXX before it replaces a system table in a query.

**Leave a `.answer_win` file as it is when you change the `.answer` file beside it.** Windows tests have stopped, and no run compares with a `.answer_win` file ([Operational facts](../AGENTS.md#operational-facts)). Example: a PR that updates `answers/cbrd_xxxxx.answer` leaves `answers/cbrd_xxxxx.answer_win` unchanged.

**In an existing TC with a `.queryPlan` file, put `--@queryplan` before each statement whose plan a case checks and whose text does not start with `SELECT`, such as one that starts with `WITH`, `(`, `UPDATE`, or `DELETE`, or one right after a block comment line.** With a `.queryPlan` file, CTP prints a plan only for a statement whose text starts with `SELECT`, and a block comment line right before a statement is part of its text. Example: `--@queryplan` and then `with c as (select a from t) select * from c;`, and also before a `select` right after a `/* Case 3 */` line.
