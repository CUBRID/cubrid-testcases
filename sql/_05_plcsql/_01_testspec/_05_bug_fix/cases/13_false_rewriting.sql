--+ server-message on
-- verified for CBRD-25249

create table t1(id int, col1 char(3));
insert into t1 values(30,'cub'),(null,'rid');

CREATE OR REPLACE PROCEDURE poo(k OUT VARCHAR) AS
BEGIN
    NULL;
END;
select 'x' into :a ;
call poo(:a);
select :a from dual;


CREATE OR REPLACE function foo(a int) return char(3) AS
    i char(3);
BEGIN
    if a is not null
    then
        select col1 into i from t1 where id = a;
    else
        select col1 into i from t1 where id is null;
    end if;
    return i;
END;

select foo(30);

drop function foo;
drop procedure poo;
drop table t1;

--+ server-message off
