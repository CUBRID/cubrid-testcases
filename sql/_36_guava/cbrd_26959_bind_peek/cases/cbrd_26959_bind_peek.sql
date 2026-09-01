--test: first-execution bind peek of prepared statements (CBRD-26959)
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t_peek;
create table t_peek (a int, pad varchar(100));
insert into t_peek select 1, lpad('x',100,'x') from db_class x, db_class y, db_class z limit 7200;
insert into t_peek select 5, lpad('x',100,'x') from db_class x, db_class y, db_class z limit 800;
create index i_t_peek_a on t_peek (a);
update statistics on t_peek with fullscan;

--test: the PREPARE-time plan is chosen with unbound host-variable markers (default
--test: equality selectivity -> INDEX SCAN). The first EXECUTE binds the DOMINANT
--test: value (a=1, 90% of the rows), so the first-execution peek must replan and fix
--test: the plan under the real value: the trace of that execution shows TABLE SCAN.
--test: Without the peek the marker-chosen INDEX SCAN would run -- the access path in
--test: the trace IS the assertion of this case.
set trace on;
prepare p from 'select count(pad) from t_peek where a = ?';
execute p using 1;
show trace;
deallocate prepare p;
set trace off;

--test: BIND_SENSITIVE hint parses and executes on SELECT, UPDATE and DELETE
select /*+ bind_sensitive */ count(pad) from t_peek where a = 5;
update /*+ bind_sensitive */ t_peek set pad = pad where a = 5;
select count(*) from t_peek where a = 5;
delete /*+ bind_sensitive */ from t_peek where a = 99999;

drop table t_peek;
set system parameters 'dont_reuse_heap_file=no';
commit;
