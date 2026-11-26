--test: bind-value plan fixing for LIKE / NOT LIKE patterns bound as host variables (CBRD-27143)
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t_lpeek;
create table t_lpeek (s varchar(50), pad varchar(100));
insert into t_lpeek select 'abc' || (rownum % 10), lpad('x',100,'x') from db_class x, db_class y, db_class z limit 7200;
insert into t_lpeek select 'xyz' || rownum, lpad('x',100,'x') from db_class x, db_class y, db_class z limit 800;
create index i_t_lpeek_s on t_lpeek (s);
update statistics on t_lpeek with fullscan;

--test: [1] the PREPARE-time plan is chosen with an unbound pattern (default LIKE selectivity,
--test: INDEX SCAN through the derived like_match_lower/upper_bound range). The first EXECUTE
--test: binds the DOMINANT prefix ('abc%', 90% of the rows): the first-execution peek must
--test: replan and fix the plan under the real pattern -- the trace carries a Query Plan block
--test: (a replan happened) and the access path is TABLE SCAN. Without the peek the marker
--test: INDEX SCAN would look up 7200 rows through the index.
set trace on;
prepare p from 'select count(pad) from t_lpeek where s like ?';
execute p using 'abc%';
show trace;
--test: [2] parameter off: the plan fixed under the first pattern stays for a later, rare
--test: pattern -- no Query Plan block in the trace, still TABLE SCAN.
--test: (the plan_cache_bind_sensitivity band replan lives on the kept tree, which is scoped to the
--test: input buffer until CBRD-27231 -- one statement per buffer here, so it is not observable in
--test: this harness; verified manually with the EXECUTEs on one csql line)
execute p using 'xyz%';
show trace;
deallocate prepare p;

--test: [3] candidate boundary: a pattern wrapped in ESCAPE and the reversed spelling (? LIKE col)
--test: are not priced by the planner with the bound value, so they are not peeked either --
--test: no Query Plan block, the PREPARE-time plan runs
prepare e from 'select count(pad) from t_lpeek where s like ? escape ''\''';
execute e using 'abc%';
show trace;
deallocate prepare e;
prepare r from 'select count(pad) from t_lpeek where ? like s';
execute r using 'abc1';
show trace;
deallocate prepare r;

--test: [3-1] value boundaries: a NULL pattern matches no row and is priced as zero rows, as a
--test: comparison with NULL is -- the first execution peeks (Query Plan block), 0 rows; a
--test: non-string pattern is cast to the column's string domain first ('123'), so it IS priced
--test: like any pattern -- the peek replans (Query Plan block), matches nothing, 0 rows, no error
prepare z from 'select count(pad) from t_lpeek where s like ? and pad is not null';
execute z using NULL;
show trace;
deallocate prepare z;
prepare z from 'select count(pad) from t_lpeek where s like ? and pad <> ''''';
execute z using 123;
show trace;
deallocate prepare z;

--test: [4] NOT LIKE ? is priced as 1 - LIKE: peeked like LIKE
prepare n from 'select count(pad) from t_lpeek where s not like ?';
execute n using 'xyz%';
show trace;
deallocate prepare n;
set trace off;

--test: [5] UPDATE / DELETE with a LIKE pattern host variable take the same path: the first
--test: execution of each replans under the bound pattern (Query Plan block in the trace)
set trace on;
prepare u from 'update t_lpeek set pad = pad where s like ?';
execute u using 'xyz%';
show trace;
deallocate prepare u;
prepare d from 'delete from t_lpeek where s like ?';
execute d using 'nomatch%';
show trace;
deallocate prepare d;
--test: [5-1] the UPDATE prices the pattern like the SELECT does: its range derived from the pattern is
--test: counted once (the statement is rewritten again as the SELECT it builds), so the dominant prefix
--test: replans to a TABLE SCAN, as `s like 'abc%'` does
prepare u2 from 'update t_lpeek set pad = pad where s like ? and pad is not null';
execute u2 using 'abc%';
show trace;
deallocate prepare u2;
set trace off;
select count(*) from t_lpeek;

--test: [6] a column without a histogram cannot be priced: no replan (no Query Plan block)
drop table if exists t_nostat;
create table t_nostat (s varchar(50), pad varchar(100));
insert into t_nostat select s, pad from t_lpeek;
create index i_t_nostat_s on t_nostat (s);
set trace on;
prepare q from 'select count(pad) from t_nostat where s like ?';
execute q using 'abc%';
show trace;
deallocate prepare q;

--test: [7] the LIKE and its derived range are counted once whichever side of the AND they sit:
--test: both spellings pick the same access path under the same values
prepare o1 from 'select count(pad) from t_lpeek where s like ? and pad = ?';
prepare o2 from 'select count(pad) from t_lpeek where pad = ? and s like ?';
execute o1 using 'xyz%', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
show trace;
execute o2 using 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'xyz%';
show trace;
deallocate prepare o1;
deallocate prepare o2;
set trace off;

--test: [8] a join with a LIKE pattern host variable on a column with most-common values is a
--test: plan-variant target (plan_cache_bind_variants, default 5): the dominant prefix and a rare
--test: one compile a plan each (Query Plan block), and coming back to either value runs its
--test: variant without a compile (no Query Plan block)
drop table if exists t_lvar;
drop table if exists t_ldim;
create table t_lvar (s varchar(50), g int, pad varchar(100));
insert into t_lvar select 'abc' || (rownum % 10), rownum % 50, lpad('x',100,'x') from db_class x, db_class y, db_class z limit 7200;
insert into t_lvar select 'xyz' || rownum, rownum % 50, lpad('x',100,'x') from db_class x, db_class y, db_class z limit 800;
create index i_t_lvar_s on t_lvar (s);
create table t_ldim (g int, name varchar(20));
insert into t_ldim select rownum - 1, 'n' || rownum from db_class x, db_class y limit 50;
create index i_t_ldim_g on t_ldim (g);
update statistics on t_lvar, t_ldim with fullscan;
set trace on;
prepare v from 'select count(t.pad) from t_lvar t, t_ldim d where t.g = d.g and t.s like ?';
execute v using 'abc%';
show trace;
execute v using 'xyz1%';
show trace;
execute v using 'abc%';
show trace;
execute v using 'xyz2%';
show trace;
deallocate prepare v;
set trace off;
drop table t_ldim;
drop table t_lvar;

drop table t_nostat;
drop table t_lpeek;
set system parameters 'dont_reuse_heap_file=no';
commit;
