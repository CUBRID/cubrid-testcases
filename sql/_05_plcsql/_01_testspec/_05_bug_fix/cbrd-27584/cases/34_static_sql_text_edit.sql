-- verified the CBRD-27584
evaluate 'the rewritten query of a static SQL is the original text with PL/CSQL variables replaced with "?:N",';
evaluate 'the INTO clause removed and the column lists implied by "*" and INSERT without a column list written.';
evaluate 'the tree is printed instead when the text can not be used.';

--+ server-message on

drop table if exists t1, s1, s2, sp, sr;
create table t1 (id int, name varchar(20));
insert into t1 values (1, 'one'), (2, 'two');
create table s1 (id int, name varchar(20));
insert into s1 values (1, 'one'), (2, 'two'), (3, 'into');
create table s2 (id int, name varchar(20));
create table sp (id int, name varchar(20)) partition by range (id) (partition p0 values less than (10), partition p1 values less than maxvalue);
create table sr (a int, b int);
insert into sr values (1, 2);

evaluate 'SELECT * INTO a %ROWTYPE record';
create or replace function g1 (k int) return varchar as
    r s1%rowtype;
begin
    select * into r from s1 where id = k;
    return r.id || ':' || r.name;
end;

evaluate 'alias.* and a record field as a host variable';
create or replace function g2 (k int) return varchar as
    r s1%rowtype;
    q s1%rowtype;
begin
    r.id := k;
    select x.* into q from s1 x where x.id = r.id;
    return q.id || ':' || q.name;
end;

evaluate 'INSERT without a column list, INSERT ... PARTITION and MERGE ... INSERT without a column list';
create or replace function g3 (k int) return varchar as
    n1 int;
    n2 int;
begin
    insert into s2 values (k, 'ins');
    insert into sp partition (p0) values (k, 'part');
    merge into s2 t using (select k + 100 as id from db_root) s on (t.id = s.id)
        when not matched then insert values (s.id, 'merge');
    select count (*) into n1 from s2;
    select count (*) into n2 from sp partition (p0);
    return n1 || '/' || n2;
end;

evaluate '"into" in a comment and a string literal, the same variable twice, and a literal';
create or replace function g4 (k int) return varchar as
    r varchar;
begin
    select /* into x */ name into r from s1 where (id = k or id = k + 10) and name <> 'into' and id < 3;
    return r;
end;

evaluate 'variables in a UNION ALL derived table, and an owner written with a comment';
create or replace function g5 (k int) return int as
    n int;
begin
    select count (*) into n from (select id from dba./* c */s1 where id = k union all select id from s1 where id = k + 1) u;
    return n;
end;

select g1 (2), g2 (1), g3 (5), g4 (1), g5 (1);

evaluate 'INSERT ... PARTITION with ON DUPLICATE KEY UPDATE';
create or replace procedure p6 (k int) as
begin
    insert into sp partition (p0) values (k, 'odku') on duplicate key update name = 'dup';
end;
call p6 (6);
select * from sp order by 1, 2;

evaluate 'a PL/CSQL variable removed from the compiled statement: the tree is printed (ORDER BY of an IN subquery)';
create or replace function fh (w int, v int) return int as
    n int;
begin
    select count (*) into n from t1 where id >= w and id in (select id from t1 order by id + v);
    return n;
end;

evaluate 'a PL/CSQL variable removed from the compiled statement: the tree is printed (unused column of a merged derived table)';
create or replace function fj (v int) return int as
    n int;
begin
    select count (*) into n from (select id, v as c from t1) x;
    return n;
end;

select fh (1, 7), fj (7);

evaluate 'the columns of "*" and INSERT without a column list are fixed at compile time';
create or replace procedure p7 as
    x int;
    y int;
begin
    select * into x, y from sr where a = 1;
    dbms_output.put_line ('a=' || x || ' b=' || y);
    insert into sr values (10, 20);
end;
call p7 ();
alter table sr modify b int first;
call p7 ();
select a, b from sr order by a;

drop function g1;
drop function g2;
drop function g3;
drop function g4;
drop function g5;
drop procedure p6;
drop function fh;
drop function fj;
drop procedure p7;
drop table t1, s1, s2, sp, sr;

--+ server-message off
