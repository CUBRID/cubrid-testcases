# medium writing rules

These *writing rules* say how to write the files of a TC under `medium/`. What a TC checks is in the [*test perspectives*](test-perspectives.md).

## New TC

**Write a TC for a new issue under `sql/`, not `medium/`, unless its scenario needs the inheritance, collection, or vclass data that `mdb` holds.** Since the medium TCs were imported into this repo in 2016, one commit has added TCs of a new issue under `medium/`, the five files of CBRD-26632 in 2026-07, and the other work there changes the imported TCs and their *answer files*. Example: the TC of a wrong result of `LEFT JOIN` goes to `sql/_13_issues/_26_2h/cases/cbrd_xxxxx.sql`, where the [sql writing rules](../../sql/rules/writing-rules.md#place-and-files) place it.

The rest of this section holds for every TC under `medium/`, and [Changing an existing TC](#changing-an-existing-tc) adds the rules for a change. These rules of the [sql writing rules](../../sql/rules/writing-rules.md#new-tc) hold for medium TCs as well:

- the *header block* that starts a new TC file with the issue key, what the TC checks, and its cases under `Coverage:` ([sql](../../sql/rules/writing-rules.md#header-and-labels)),
- the *evaluate label* `evaluate 'Case N: …';` of each case ([sql](../../sql/rules/writing-rules.md#header-and-labels)),
- the output of a bug that the TC does not test, and the mark of a *known wrong result* ([sql](../../sql/rules/writing-rules.md#answer-files)),
- one file for one issue, and when and how to split it ([sql](../../sql/rules/writing-rules.md#place-and-files)),
- keeping each TC atomic, so that it affects no TC before or after it and restores the state it started from as soon as it ends ([sql](../../sql/rules/writing-rules.md#cleanup)),
- restoring at the end of the file each session setting that the TC changed ([sql](../../sql/rules/writing-rules.md#cleanup)),
- making the answer file from a run and never editing it by hand ([sql](../../sql/rules/writing-rules.md#answer-files)),
- one answer file in `answers/` for each `.sql` file in `cases/`, and no empty answer file ([sql](../../sql/rules/writing-rules.md#place-and-files)),
- only TC files in `cases/` and `answers/` ([sql](../../sql/rules/writing-rules.md#place-and-files)),
- a `;` at the end of every statement, and in a block comment no line that ends with `;` and no `'` or `?` ([sql](../../sql/rules/writing-rules.md#statements-and-comments)),
- the exact form of the CTP control lines such as `autocommit off;` and `--+ holdcas on;` ([sql](../../sql/rules/writing-rules.md#statements-and-comments)),
- UTF-8 without a BOM and LF line ends ([sql](../../sql/rules/writing-rules.md#place-and-files)).

### Place and names

**Write a new TC that relies on no state that another file leaves, in any directory, and add no new file to `_07_mc_dep/` or `_08_mc_ind/`.** The files already in these two directories read data that earlier files there committed, and they stay in that structure, as [Changing an existing TC](#changing-an-existing-tc) says. Example: a new TC that needs rows like those of `x_base_c0` creates and fills its own class after `autocommit off;` and does not read the rows that `_08_mc_ind/cases/I014_dub1.sql` committed.

**Name a new TC file with lowercase letters, digits, and underscores only.** Example: `outer_inner.sql`, not `server-concurrent-sortmerge.sql` or `test_add_months_QA.sql`; a TC of an issue is `cbrd_xxxxx.sql`, or `cbrd_xxxxx_<keyword>.sql` for a split file, as the [sql writing rules](../../sql/rules/writing-rules.md#place-and-files) say.

**Make no subdirectory under `cases/` or `answers/`.** CTP also runs a `.sql` file in a subdirectory of `cases/`, but it looks for the answer file in `answers/` without the subdirectory, so `cases/old/setjn1.sql` and `cases/setjn1.sql` read the same answer file. Example: `_02_xtests/cases/setjn1.sql` and `_02_xtests/answers/setjn1.answer`, not `_02_xtests/cases/old/setjn1.sql`.

### Start and end of the file

**Start a medium TC with `autocommit off;` and end it with `rollback;`, except a file already in `_08_mc_ind/` that commits data for the later files and a TC whose scenario needs a `commit`.** A TC whose scenario needs a `commit` ends as the next rule says. CTP commits on every connection of a file when the file ends, so a change that the TC does not roll back stays in `mdb` for the rest of the run, and the TCs that run after it read the changed data ([test perspectives](test-perspectives.md#what-a-medium-tc-cannot-check)); how a TC checks the rollback itself is in [What a medium TC checks](test-perspectives.md#what-a-medium-tc-checks). Example: `_02_xtests/cases/between.sql` creates and fills the table `barbar` after `autocommit off;` on line 1 and ends with `rollback;` on line 45.

**When the scenario needs a `commit`, end the file with `call login('dba', '') on class db_user;`, `rollback;`, a `drop` of each object and user that the TC created, and `commit;`, in that order.** An object that a commit left behind stays in `mdb`, so a later TC that creates the same name fails, or a catalog query in it prints one more row. Example: `_01_fixed/cases/fview1_1.sql` commits a vclass of `joe` for `public` and ends with lines 17 to 21:
```sql
call login('dba', '') on class db_user;
rollback;
drop vclass joe.xxx_v;
drop class joe.xxx;
commit;
```

**When a TC logs in as another user with `call login`, log in as `dba` again with `call login('dba', '') on class db_user;` before the file ends.** CTP keeps the connection of a file for the files after it and does not log it in again, so the next file runs as the user that the file left. Example: `_01_fixed/cases/fview1_1.sql` logs in as `public` on line 9 and as `dba` again on line 17, while `_04_full/cases/sesnsch.sql` ends logged in as `PUBLIC`.

**In a file that stores a value in a host variable or a session variable, such as `select … into :u` or `SELECT … TO :maxvalue`, make `--+ holdcas on;` the first line and `--+ holdcas off;` the last line.** Without `holdcas` the broker can run the next statement on another CAS, where the variable does not exist. Example: `_05_err_x/cases/label1.sql` has `--+ holdcas on;` on line 1, `select _db_user into :u …` on line 3, and `--+ holdcas off;` on line 6, its last line.

### Answer files

**Make an answer file from a CTP run of the whole directory of the TC, or of all of `medium/` when you can, not from a run of the TC alone.** Each run loads `mdb` fresh and runs its TCs on it one after another, and a TC sees what the TCs before it left ([test perspectives](test-perspectives.md#what-a-medium-tc-cannot-check)), so its output when it runs alone can differ from its output in a run of the directory. Example: set `scenario` in the `[sql]` section of `medium_dev.conf` ([Operational facts](../AGENTS.md#operational-facts)) to `${HOME}/cubrid-testcases/medium/_02_xtests`, run `ctp.sh medium -c <conf>`, and make `answers/between.answer` from the `between.result` of that run.

## Changing an existing TC

A change of an existing TC follows the [New TC](#new-tc) section and these rules of the [sql writing rules](../../sql/rules/writing-rules.md#changing-an-existing-tc):

- bringing a TC that you change in line with the *rulebook*, and leaving as it is a TC that you have no other reason to change ([sql](../../sql/rules/writing-rules.md#changing-an-existing-tc)),
- keeping the scenario that the TC was written to reproduce ([sql](../../sql/rules/writing-rules.md#changing-an-existing-tc)),
- leaving a `.answer_win` file as it is, because Windows tests have stopped ([sql](../../sql/rules/writing-rules.md#changing-an-existing-tc)),
- updating an answer file that keeps a known wrong result once its issue is closed ([sql](../../sql/rules/writing-rules.md#answer-files)).

A PR that changes an answer file follows [The PR](../../sql/AGENTS.md#the-pr) in `sql/AGENTS.md`.

**When you change a file of `_07_mc_dep/` or `_08_mc_ind/`, keep its name and so its place in the order, and leave as it is what it reads from the earlier files.** CTP runs the files of a directory in the sort order of their names, so a file that sorts in between, or a changed number, changes what the files after it read. Example: `_08_mc_ind/cases/I018_qset0.sql` counts rows of `x_base_c0` that `I014_dub1.sql` inserted and committed before it, so renaming `I014_dub1.sql` to `I020_dub1.sql` runs it after `I018_qset0.sql` and changes that count.

**When you change an answer file that a patch file of the JDBC compatibility test names, check that each such patch file still applies, and change it in the same PR when it does not.** The compatibility test applies the patch file with `patch -p0 -f` before it compares, and a patch that fails leaves the answer file unpatched, so that test compares the output of the older version with the wrong answer file. Example: in `medium/`, `grep -l '^Index: _02_xtests/answers/str_ops.answer' config/daily_regression_test_exclude_list_compatibility/patch_files/*` lists the patch files that name `str_ops.answer`, and `patch --dry-run -p0 < <patch file>` shows whether each still applies.

**Name a patch file `jdbc_medium_<x.y.z>_<D|S64>_patch` under `medium/config/daily_regression_test_exclude_list_compatibility/patch_files/`, and write it as a unified diff whose paths start below `medium/`.** The test picks the patch file by the version in its name and applies it in `medium/` with `patch -p0`, so another name, or a path that starts with `medium/`, leaves the answer files unpatched. Example: the header of `jdbc_medium_10.0.0_D_patch`, not `--- medium/_02_xtests/answers/str_ops.answer` or a file named `jdbc_medium_10.0.0.patch`:
```
Index: _02_xtests/answers/str_ops.answer
--- _02_xtests/answers/str_ops.answer
+++ _02_xtests/answers/str_ops.answer
```
