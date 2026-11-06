-- CBRD-27855: pt_cnf () distributed (A and B) or (C and D) into (A or C), (A or D), (B or C), (B or D).
-- The optimizer multiplied those correlated clauses as if they were independent, so a join or a
-- scan under such a condition was estimated far below its real row count, and every literal was
-- evaluated once per clause it landed in.  The factor now stays whole, and the restrictions a scan
-- or an index can use (one spec, one column) are derived from it.

drop table if exists nat, fact, pair;

create table nat (id int primary key, n_name varchar (25));
insert into nat select rownum, case when rownum <= 49 then 'FRANCE' when rownum <= 99 then 'GERMANY' else 'N' || mod (rownum, 23) end from db_class a, db_class b limit 1000;
create index i_nat_name on nat (n_name);

create table fact (id int, k int, pad varchar (100));
insert into fact select rownum, mod (rownum, 2000), 'p' from db_class a, db_class b, db_class c limit 20000;
create index i_fact_k on fact (k);

create table pair (id int primary key, a varchar (10), b varchar (10));
insert into pair select rownum, case mod (rownum, 20) when 0 then 'X' when 1 then 'Y' else 'P' || mod (rownum, 20) end, case mod (rownum / 20, 20) when 0 then 'Y' when 1 then 'X' else 'Q' || mod (rownum / 20, 20) end from db_class a, db_class b, db_class c limit 20000;
create index i_pair_a on pair (a);
create index i_pair_ab on pair (a, b);

update statistics on nat, fact, pair with fullscan;

evaluate 'Case 1: the nation pair joins fact before the other alias -- the pair is 4900 rows, not 87';
--@queryplan
select /*+ recompile */ count (*) from nat sn, nat cn, fact where sn.id = fact.id and ((sn.n_name = 'FRANCE' and cn.n_name = 'GERMANY') or (sn.n_name = 'GERMANY' and cn.n_name = 'FRANCE'));

evaluate 'Case 2: the same rows written as independent conditions keep their plan';
--@queryplan
select /*+ recompile */ count (*) from nat sn, nat cn, fact where sn.id = fact.id and sn.n_name in ('FRANCE', 'GERMANY') and cn.n_name in ('FRANCE', 'GERMANY') and sn.n_name <> cn.n_name;

evaluate 'Case 3: one table keeps its covering index scan: 100 rows';
--@queryplan
select /*+ recompile */ count (*) from pair where (a = 'X' and b = 'Y') or (a = 'Y' and b = 'X');

evaluate 'Case 4: three branches on one table: 150 rows';
select count (*) from pair where (a = 'X' and b = 'Y') or (a = 'Y' and b = 'X') or (a = 'P2' and b = 'Q2');

evaluate 'Case 5: clauses written apart over the same columns: 1000 rows';
select count (*) from pair where (a = 'X' or b = 'Y') and (a = 'X' or b = 'X');

evaluate 'Case 6: an outer join ON condition keeps the null padded rows: 5801 rows';
select count (*) from nat sn left outer join nat cn on ((sn.n_name = 'FRANCE' and cn.n_name = 'GERMANY') or (sn.n_name = 'GERMANY' and cn.n_name = 'FRANCE'));

evaluate 'Case 7: a subquery in one branch is planned once, not once per distributed clause';
--@queryplan
select /*+ recompile */ count (*) from pair where (a = 'X' and b in (select b from pair where id < 100)) or (a = 'Y' and b = 'X');

evaluate 'Case 8: eight branches give a key range on a: 400 rows';
--@queryplan
select /*+ recompile */ count (*) from pair where (a = 'X' and b = 'Y') or (a = 'Y' and b = 'X') or (a = 'P2' and b = 'Q2') or (a = 'P3' and b = 'Q3') or (a = 'P4' and b = 'Q4') or (a = 'P5' and b = 'Q5') or (a = 'P6' and b = 'Q6') or (a = 'P7' and b = 'Q7');

evaluate 'Case 9: a disjunction over a inside a branch still gives the key range: 150 rows';
--@queryplan
select /*+ recompile */ count (*) from pair where ((a = 'X' or a = 'Y') and b = 'Y') or (a = 'P2' and b = 'Q2');

evaluate 'Case 10: restrictions derived from an ON condition, on the inner side and on the preserved side';
select count (*) from nat sn left outer join nat cn on sn.id = cn.id + 1 and ((sn.n_name = 'FRANCE' and cn.n_name = 'FRANCE') or (sn.n_name = 'GERMANY' and cn.n_name = 'GERMANY'));
select count (*) from nat sn left outer join nat cn on sn.id = cn.id and ((sn.n_name = 'FRANCE' and sn.id < 30) or (sn.n_name = 'GERMANY' and sn.id > 60));
select count (*) from nat sn right outer join nat cn on sn.id = cn.id and ((sn.n_name = 'FRANCE' and cn.id < 30) or (sn.n_name = 'GERMANY' and cn.id > 60));
select count (*) from nat sn left outer join nat cn on sn.id = cn.id and ((sn.n_name = 'FRANCE' and sn.id < 30) or (sn.n_name = 'GERMANY' and sn.id > 60)) where cn.id is not null;

drop table nat, fact, pair;
