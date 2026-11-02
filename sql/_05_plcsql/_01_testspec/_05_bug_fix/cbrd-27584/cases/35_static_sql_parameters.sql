-- verified the CBRD-27584
evaluate 'the rewritten query of a static SQL is lexed again with the parameters of the caller.';
evaluate 'a text that is lexed differently by no_backslash_escapes, ansi_quotes or default_week_format is printed as the tree,';
evaluate 'so that the results are those of the creator as before.';

--+ server-message on

drop table if exists t_aq;
create table t_aq (abc varchar (10));
insert into t_aq values ('COLUMN');

evaluate 'no_backslash_escapes: a backslash escape in a string literal';
set system parameters 'no_backslash_escapes=no';
create or replace function bs1 return int as
    r varchar;
begin
    select 'a\nb' into r from db_root;
    return instr (r, chr (10));
end;
create or replace function bs2 return int as
    r int;
begin
    select length ('a\nb') into r from db_root;
    return r;
end;
select bs1 (), bs2 () from db_root;
set system parameters 'no_backslash_escapes=yes';
select bs1 (), bs2 () from db_root;

evaluate 'ansi_quotes: "abc" is a string literal when the function is created';
set system parameters 'ansi_quotes=no';
create or replace function aq1 return varchar as
    r varchar;
begin
    select "abc" into r from t_aq;
    return r;
end;
select aq1 () from db_root;
set system parameters 'ansi_quotes=yes';
select aq1 () from db_root;

evaluate 'ansi_quotes: "abc" is a column when the function is created';
create or replace function aq2 return varchar as
    r varchar;
begin
    select "abc" into r from t_aq;
    return r;
end;
select aq2 () from db_root;
set system parameters 'ansi_quotes=no';
select aq2 () from db_root;
set system parameters 'ansi_quotes=yes';

evaluate 'default_week_format: the mode of WEEK () not written';
set system parameters 'default_week_format=1';
create or replace function wk1 return int as
    r int;
begin
    select week (date '2026-01-05') into r from db_root;
    return r;
end;
select wk1 () from db_root;
set system parameters 'default_week_format=0';
select wk1 () from db_root;

evaluate 'the INTO clause written as TO';
create or replace function to1 return varchar as
    r varchar;
begin
    select abc to r from t_aq where abc <> 'x';
    return r;
end;
select to1 () from db_root;

drop function bs1;
drop function bs2;
drop function aq1;
drop function aq2;
drop function wk1;
drop function to1;
drop table t_aq;

--+ server-message off
