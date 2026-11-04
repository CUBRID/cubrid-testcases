-- verified the CBRD-27927
evaluate 'a PL/CSQL variable in GROUP BY/HAVING of a derived table or a CTE, or of a query on them, in a static SQL.';
evaluate 'A: a derived table or a CTE was typed before its deferred names were made host variables, so FIELD, DECODE,';
evaluate 'BETWEEN, ... were typed with a name of no type. B: a name in GROUP BY/HAVING of a query on a CTE or a derived';
evaluate 'table was not deferred and was reported as not defined.';

drop table if exists t27927;
create table t27927 (i int, s varchar (10));
insert into t27927 values (1, 'a'), (2, 'b'), (2, 'c'), (3, 'd');

evaluate 'A: HAVING of a derived table';
create or replace function f_a_field (v int) return int as
    n int;
begin
    select count (*) into n from (select i from t27927 group by i having field (v, i, 9) = 1) x;
    return n;
end;
create or replace function f_a_decode (v int) return int as
    n int;
begin
    select count (*) into n from (select i from t27927 group by i having decode (v, i, 1, 0) = 1) x;
    return n;
end;
create or replace function f_a_between (v int) return int as
    n int;
begin
    select count (*) into n from (select i from t27927 group by i having i between v and 9) x;
    return n;
end;
select f_a_field (2), f_a_field (5) from db_root;
select f_a_decode (2), f_a_decode (5) from db_root;
select f_a_between (2), f_a_between (5) from db_root;

evaluate 'A: GROUP BY of a derived table, and an alias of its select list in HAVING';
create or replace function f_a_group (v int) return varchar as
    res varchar := '';
begin
    for r in (select f, c from (select field (v, i, 9) f, count (*) c from t27927 group by field (v, i, 9)) x
              order by f) loop
        res := res || r.f || ':' || r.c || ' ';
    end loop;
    return res;
end;
create or replace function f_a_alias (v int) return int as
    n int;
begin
    select count (*) into n from (select i k from t27927 group by k having field (v, k, 9) = 1) x;
    return n;
end;
select f_a_group (2), f_a_group (5) from db_root;
select f_a_alias (2) from db_root;

evaluate 'A: HAVING of a CTE, and of the recursive part of a recursive CTE';
create or replace function f_a_cte (v int) return int as
    n int;
begin
    with c as (select i from t27927 group by i having field (v, i, 9) = 1) select count (*) into n from c;
    return n;
end;
create or replace function f_a_cte_rec (v int) return int as
    n int;
begin
    with recursive c (k) as (select 1 from db_root
                             union all
                             select k + 1 from c where k < 3 group by k having k between v and 9)
    select count (*) into n from c;
    return n;
end;
select f_a_cte (2), f_a_cte (5) from db_root;
select f_a_cte_rec (1), f_a_cte_rec (2) from db_root;

evaluate 'B: GROUP BY/HAVING of a query on a CTE or a derived table';
create or replace function f_b_cte (v int) return int as
    n int;
begin
    with c (k) as (select i from t27927) select max (k) into n from c group by k having k = v;
    return n;
end;
create or replace function f_b_derived (v int) return int as
    n int;
begin
    select max (k) into n from (select i k from t27927) x group by k having k = v;
    return n;
end;
create or replace function f_b_group (v int) return varchar as
    res varchar := '';
begin
    for r in (select field (v, k, 9) f, count (*) c from (select i k from t27927) x group by field (v, k, 9)
              order by 1) loop
        res := res || r.f || ':' || r.c || ' ';
    end loop;
    return res;
end;
select f_b_cte (2), f_b_derived (2), f_b_derived (3) from db_root;
select f_b_group (2) from db_root;

evaluate 'A and B: HAVING of a derived table on a CTE';
create or replace function f_ab (v int) return int as
    n int;
begin
    with c (k) as (select i from t27927)
    select count (*) into n from (select k from c group by k having field (v, k, 9) = 1) x;
    return n;
end;
select f_ab (2), f_ab (5) from db_root;

evaluate 'the same queries in a SQL with host variables';
prepare s from 'select count (*) from (select i from t27927 group by i having field (?, i, 9) = 1) x';
execute s using 2;
prepare s from 'select max (k) from (select i k from t27927) x group by k having k = ?';
execute s using 2;
deallocate prepare s;

evaluate 'an alias of the select list in HAVING is still resolved before a PL/CSQL variable of the same name';
create or replace function f_alias_first (k int) return int as
    n int;
begin
    select count (*) into n from (select i k from t27927 group by i having k > 1) x;
    return n;
end;
select f_alias_first (100) from db_root;

drop function f_a_field;
drop function f_a_decode;
drop function f_a_between;
drop function f_a_group;
drop function f_a_alias;
drop function f_a_cte;
drop function f_a_cte_rec;
drop function f_b_cte;
drop function f_b_derived;
drop function f_b_group;
drop function f_ab;
drop function f_alias_first;
drop table t27927;
