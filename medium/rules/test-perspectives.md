# medium test perspectives

These *test perspectives* say what a TC under `medium/` checks. How to write the files of the TC is in the [*writing rules*](writing-rules.md).

## What a medium TC checks

These rules of the [sql test perspectives](../../sql/rules/test-perspectives.md) hold for medium TCs as well:

- the `ORDER BY` that gives the rows of a multi-row SELECT a fixed order ([sql](../../sql/rules/test-perspectives.md#what-sql-tcs-cannot-check)),
- the exact error code of a statement that must fail, and a SELECT of the state after it ([sql](../../sql/rules/test-perspectives.md#evidence-in-the-answer-file)),
- when a query gets a recompile hint or a join hint ([sql](../../sql/rules/test-perspectives.md#plans-hints-and-data-size)),
- how far past a *threshold* the data of a TC goes ([sql](../../sql/rules/test-perspectives.md#plans-hints-and-data-size)).

**When an engine change only reorders the rows of a SELECT that has no `ORDER BY`, give that SELECT an `ORDER BY` that fixes the order.** An *answer file* that only takes the new order holds the row order of one build, and the next change of a scan or of the space management fails the TC again. How to make the answer file again after you add the `ORDER BY` is in the [writing rules](writing-rules.md#answer-files). Example: `_05_err_x/cases/strlen.sql` turned `select * from cs;` on line 190 into `select * from cs order by s desc;`.

**After a TC changes a class that `mdb` holds and rolls the change back, select from that class and check that its rows and attributes are as they were before the change.** In medium the rollback is itself under test: a rollback that misses part of a change still passes in its own TC and breaks a TC that runs later, where the cause is hard to find. Example: after `update joe.product_c set price = price * 2;` and `rollback;`, the TC runs `select price from joe.product_c order by 1;`, and the answer file shows the prices from before the update; other changes worth this check are DDL on a class that a subclass or a vclass such as `joe.employees_v` refers to, and a `drop index`.

**Make the inheritance, the collection types, the path expressions, the `all <class>` and `class <class>` queries, and the vclass updates that a TC uses show in its result values.** These features of `mdb` are what medium covers and sql TCs seldom do, so a TC that hides them misses the regressions of their users. Example: `_02_xtests/cases/setjn1.sql` joins the rows of `xseta` on `a.seq3=b.mset2`, a sequence against a multiset; other values worth a check are an empty set against a `NULL` set and the row count of an inherited class with and without `all`.

**When a TC switches users or changes privileges, as with `call login`, `grant`, `add_member`, or `drop user`, keep in the answer file what each user gets, the error code of each refused statement included.** A check that only `dba` runs misses a user who gets past a privilege and a user who is refused too much, and a change of the login or privilege rules shows only in these results; the PR then says why they changed ([sql/AGENTS.md](../../sql/AGENTS.md#the-pr)). Example: `_01_fixed/cases/fview1_1.sql` grants `joe.xxx_v` to `public`, logs in as `public`, and keeps what `select`, `insert`, `delete`, and `update` on `joe.xxx_v` return to that user; other cases worth this check are adding a member to a group and an object that another user created but did not commit before the login.

**Apply the same predicate to a column with an index and to a column without one, and check that both return the same result.** A bug of an index scan, such as a wrong range or a lost `NULL`, shows only as a different result. Example: `select count(*) from virtual_c0 where attr10_money_idx <> $120.00;` next to the same query on `attr10_money_noidx`, with the same count twice in the answer file; other values worth this check are `NULL`, both ends of a `BETWEEN`, the `money` and `utime` types, and the rows right after a bulk `INSERT`, `UPDATE`, or `DELETE`.

**Select from a system catalog only the columns that the check needs and only the classes of the TC, not `select *`.** A new catalog column or a system class that has nothing to do with the TC then changes its answer file and hides a real regression among the changed lines. Example: `select attr_name, data_type from db_attribute where class_name = 'foo' order by attr_name;`, not `select * from db_attribute;`.

**When the output of a statement differs in the JDBC compatibility test of an older version, keep the output of the build under test in the answer file and the older output in the patch file of that version.** The compatibility test applies the patch file of its version to the answer files before it compares, so a difference left out of the patch fails that test on every run, and one written into the answer file hides a regression of the build. How to change a patch file is in the [writing rules](writing-rules.md#changing-an-existing-tc). Example: `jdbc_medium_10.0.0_D_patch` under `medium/config/` turns the empty result of `select b'' + b''` in `_02_xtests/answers/str_ops.answer` into `null`.

## What a medium TC cannot check

CTP loads `mdb` from `medium/files/mdb.tar.gz` once per run and runs the medium TCs of the run on it, one file after another. The checks below need something that such a run does not give, and each rule says what to do instead.

**Expect no reset of `mdb` between TCs: a TC sees the database that the TCs before it in the run left.** Only the rollbacks of the earlier TCs keep the loaded data as it was. Example: when a TC fails in the run on the rows of a class such as `joe.product_c` but passes alone, look for an earlier TC that left a change there before you touch the answer file.

**Write a medium TC as a `.sql` file, and check no C API or ESQL program as a medium TC.** CTP collects only the `.sql` files of `cases/`, so any other file there never runs. Example: `_02_xtests/cases/coerce.api` and `_02_xtests/cases/e6386.ec` sit in `cases/` and have never run.

**Check a query plan, or an output that only CCI gives, in a sql TC, not in a medium TC.** CTP does not run medium TCs through CCI, and medium has no `.answer_cci` file, no `.queryPlan` file, and no `--@queryplan` line. Example: a TC that checks which join method a query uses goes to `sql/` and puts the plan into its answer file, as [Plans, hints, and data size](../../sql/rules/test-perspectives.md#plans-hints-and-data-size) in the sql test perspectives says.

**Check concurrency in an isolation TC also when the scenario fits `_07_mc_dep/` or `_08_mc_ind/`, and put a scenario that can stop the server or damage the database into a shell TC.** CTP runs the files of those two directories one after another like the files of any other directory, and a server that stops or a database that breaks fails every medium TC after it in the run. Which category takes the other checks that a medium TC cannot run is in the [sql test perspectives](../../sql/rules/test-perspectives.md#what-sql-tcs-cannot-check). Example: a check that a second transaction waits for the lock that a first one holds on `x_base_c0` is an isolation TC, not a file under `_08_mc_ind/`.

This rule of the [sql test perspectives](../../sql/rules/test-perspectives.md) holds for medium TCs as well:

- a row count printed with `count(*)`, because CTP removes CR and LF before it compares output ([sql](../../sql/rules/test-perspectives.md#what-sql-tcs-cannot-check)).

## Model TCs

**Copy what a model TC does well, and write each point listed under "Differs" the way this *rulebook* says.** The listed points break a rule, and a copy would carry the break into another TC. Example: copy the cleanup at the end of `fview1_1.sql`, and give a SELECT like the one on its line 12 an `ORDER BY`.

- `medium/_02_xtests/cases/between.sql`: it starts with `autocommit off;`, creates and fills its own table, ends with `rollback;`, and gives each of its three multi-row SELECTs an `ORDER BY`.
  Differs: it has no *header block* and no *evaluate label*, which the [writing rules](writing-rules.md#new-tc) ask of a new TC.
- `medium/_01_fixed/cases/fview1_1.sql`: its scenario needs a `commit`, so it ends with `call login('dba', '')`, `rollback;`, the drops, and `commit;` (lines 17 to 21), and its answer file keeps what `public` gets on a vclass of `joe`.
  Differs: line 12 selects the two rows of `joe.xxx_v` without `ORDER BY`; it has no header block and no evaluate label.
- `medium/_05_err_x/cases/6583.sql`: it causes the unique violation `Error:-670` and then checks the rows of `tokuisaki` with a SELECT that has an `ORDER BY` (line 23).
  Differs: it has no header block and no evaluate label.

## Bad TCs

Each TC below shows the defect named next to it.

- `medium/_04_full/cases/merges.sql`: none of its statements ends with `;` (the only `;` are on lines 1 and 2, `--+ holdcas on;` and a comment), so CTP runs none of them, and its answer file is empty, so the TC passes on every build.
- `medium/_04_full/cases/sesnsch.sql`: the six `select` lines after line 2 have no `;` and never run, and the TC ends logged in as `PUBLIC` (line 2), not as `dba`.
- `medium/_03_full_mdb/cases/allindex.sql`: only 2 of its 96 SELECTs have an `ORDER BY` (lines 76 and 189), and it stores host variables such as `:b1` without `holdcas`.
- `medium/_07_mc_dep/cases/D023_qset17.sql`: it turns `holdcas` on in line 1 and never off, has neither `autocommit off;` nor `rollback;`, and its `HAVING` query in lines 6 to 8 has no `ORDER BY`.
- `medium/_05_err_x/cases/constr25.sql`: it stores the host variable `:foo1` in line 5 without `holdcas`.
