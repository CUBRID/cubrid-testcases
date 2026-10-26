/**
 *  This test case verifies CBRD-27579: EXECUTE in a PL/CSQL loop runs the statement the name was
 *  prepared with last, and is judged by that statement.
 *
 *  PL/CSQL prepares a fixed string in a loop only once and executes the same statement on the
 *  following iterations. A fixed string 'execute <name>' is left out of that, so a name prepared
 *  again in the loop runs the new statement. The string is found even when a block comment,
 *  a -- comment or a // comment comes before EXECUTE.
 *
 *  Coverage:
 *    Case 1: a name prepared again in a loop runs the new statement
 *    Case 2: the second statement is INCR (), and is refused in a function invoked by SELECT
 *    Case 3: a comment before EXECUTE
 *    Case 4: nothing was written
 */

--+ server-message on

drop table if exists s;
drop table if exists cnt_t;

create table s (a int);
insert into s values (1);
create table cnt_t (id int, cnt int);
insert into cnt_t values (1, 0);

create or replace function f_reprepare return varchar as x int; r varchar := '';
begin
  for i in 1 .. 2 loop
    if i = 1 then
      execute immediate 'prepare s_loop from ''select 100 from db_root''';
    else
      execute immediate 'prepare s_loop from ''select 200 from db_root''';
    end if;
    execute immediate 'execute s_loop' into x;
    r := r || x || ' ';
  end loop;
  return r;
end;
create or replace function f_reprepare_incr return int as
begin
  for i in 1 .. 2 loop
    if i = 1 then
      execute immediate 'prepare s_loop_incr from ''select 1 from db_root''';
    else
      execute immediate 'prepare s_loop_incr from ''select incr (cnt) from cnt_t where id = 1''';
    end if;
    execute immediate 'execute s_loop_incr';
  end loop;
  return 1;
end;
create or replace function f_comment_execute return varchar as x int; r varchar := '';
begin
  for i in 1 .. 2 loop
    if i = 1 then
      execute immediate 'prepare s_cmt from ''select 100 from db_root''';
    else
      execute immediate 'prepare s_cmt from ''select 200 from db_root''';
    end if;
    execute immediate '/* c */ execute s_cmt' into x;
    r := r || x || ' ';
    execute immediate '-- c
execute s_cmt' into x;
    r := r || x || ' ';
    execute immediate '// c
EXECUTE s_cmt' into x;
    r := r || x || ' ';
  end loop;
  return r;
end;
commit;


evaluate 'Case 1: a name prepared again in a loop runs the new statement';
select f_reprepare () from s;


evaluate 'Case 2: the second statement is INCR (), and is refused in a function invoked by SELECT';
select f_reprepare_incr () from s;


evaluate 'Case 3: a comment before EXECUTE';
select f_comment_execute () from s;


evaluate 'Case 4: nothing was written';
select cnt from cnt_t;

--+ server-message off

drop function f_reprepare;
drop function f_reprepare_incr;
drop function f_comment_execute;
drop table s;
drop table cnt_t;
