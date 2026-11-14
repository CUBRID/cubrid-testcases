-- CBRD-28076: a factor pt_cnf_where () keeps whole, (A and B) or C, can lose a disjunct once an equality
-- term substitutes a constant into it: (o.c <> i.c and o.c < i.c) or (i.c <> i.c) with i.c = 12.  The
-- constant folding after the rewrite left (o.c <> 12 and o.c < 12), a conjunction, as one term of the
-- CNF list, which the optimizer cannot analyze, and a semi join or an outer join whose ON condition held
-- the factor failed with "Outer join query optimization failed.".  The factor was also copied as a
-- transitive join term of the equality, and a LIKE '%' inside the factor was not rewritten to IS NOT NULL.
-- The kept factors are now folded right after the substitution and put back in CNF shape.

drop table if exists o, i, a, b, t;

create table o (c double primary key);
create table i (c bigint unique);
insert into o values (1.0e0), (2.0e0);
insert into i values (1), (3);

create table a (c varchar not null, d varchar);
create table b (c bigint);
insert into a values ('x', 'y'), ('z', null), ('a', 'b');
insert into b values (1), (null);

create table t (a int, b int, s varchar);
insert into t select mod (rownum, 7), mod (rownum, 5), case when mod (rownum, 10) = 0 then null else 's' || rownum end from db_class c1, db_class c2 where rownum <= 20;

update statistics on o, i, a, b, t with fullscan;

evaluate 'Case 1: IN subquery, the inner attribute substituted into the factor: no error, 0 rows, the conjuncts are terms of the ON condition';
--@queryplan
select /*+ recompile */ o.c from o where 12 in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c));

evaluate 'Case 2: EXISTS subquery with the equality inside: 0 rows';
select o.c from o where exists (select 1 from i where i.c = 12 and ((o.c <> i.c and o.c < i.c) or (i.c <> i.c)));

evaluate 'Case 3: LEFT OUTER JOIN ON condition with the WHERE equality substituted: 1 row, the null padded row kept';
--@queryplan
select /*+ recompile */ a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x';

evaluate 'Case 4: controls -- an inner attribute in the conjunction, no conjunction, no subquery, no substitution: unchanged';
select o.c from o where 12 in (select i.c from i where (o.c <> i.c and i.c > 0) or (i.c <> i.c));
select o.c from o where 12 in (select i.c from i where (o.c <> i.c) or (i.c <> i.c));
select o.c from o, i where i.c = 12 and ((o.c <> i.c and o.c < i.c) or (i.c <> i.c));
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c <> 'x';
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or (b.c is null) where a.c = 'x';

evaluate 'Case 5: what the factor folds to -- a smaller disjunction, one predicate, true, a conjunction holding a key range';
select o.c from o where 1 in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c) or (o.c > 100 and i.c > 0));
select o.c from o where 1 in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c) or (o.c > 1 and i.c > 0));
select o.c from o where 1 in (select i.c from i where (o.c <> i.c) or (i.c <> i.c and o.c < i.c));
select o.c from o where 1 in (select i.c from i where (i.c = i.c) or (o.c <> i.c and o.c < i.c));
--@queryplan
select /*+ recompile */ o.c from o where 3 in (select i.c from i where ((o.c = 1 or o.c = 2) and o.c <= i.c) or (i.c <> i.c));
select o.c from o where 3 in (select i.c from i where ((o.c = 1 or o.c = 5) and o.c <= i.c) or (i.c <> i.c and o.c = 2));

evaluate 'Case 6: the join kinds -- right outer, three branches, a WHERE on the inner side, inner join, anti join, not in';
select a.c, b.c from b right outer join a on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x';
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'z';
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) or (b.c = 1 and a.d = 'y') where a.c = 'x' order by 2;
select a.c, b.c from a left outer join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x' and b.c is null;
select a.c, b.c from a inner join b on ((a.c > 'm') is null) or ((b.c is null) and (a.d <= a.d)) where a.c = 'x';
select o.c from o where not exists (select 1 from i where i.c = 12 and ((o.c <> i.c and o.c < i.c) or (i.c <> i.c)));
select o.c from o where 12 not in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c));
select o.c from o where 1 not in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c));

evaluate 'Case 7: the constant comes from a derived table column, a host variable, or reaches an UPDATE or DELETE';
select o.c from (select 1 as k, c from i) d, o where (o.c <> d.k and o.c < d.c) or (d.k <> d.k);
prepare st from 'select o.c from o where ? in (select i.c from i where (o.c <> i.c and o.c < i.c) or (i.c <> i.c))';
execute st using 12;
execute st using 3;
deallocate prepare st;
create table o2 as select * from o;
delete from o2 where 12 in (select i.c from i where (o2.c <> i.c and o2.c < i.c) or (i.c <> i.c));
select * from o2;
update o2 set c = c + 10 where exists (select 1 from i where i.c = 1 and ((o2.c <> i.c and o2.c > i.c) or (i.c <> i.c)));
select * from o2 order by 1;
drop table o2;

evaluate 'Case 8: LIKE ''%'' inside a kept factor is rewritten to IS NOT NULL, as at the top level';
--@queryplan
select /*+ recompile */ a from t where (a <> b and lower (s) like '%') or s > 'zz' order by 1;
--@queryplan
select /*+ recompile */ a from t where (a <> b and s like 's1%') or (a = b and s like 's2') order by 1;

drop table o, i, a, b, t;
