--+ server-message on
-- Verified for CBRD-24785

create table t(col varchar);
insert into t values('limit test 1'),(2);

create or replace procedure limit_test1 as
	col varchar;
begin
	select col into col from t order by col desc limit 1;
	dbms_output.put_line('result: ' || col);
end;

call limit_test1();



create or replace procedure limit_test2 as
	col varchar;
begin
	select 'limit test 2' into col from t limit 1;
	dbms_output.put_line('result: ' || col);
end;

call limit_test2();

drop t;
drop procedure limit_test1;
drop procedure limit_test2;

--+ server-message off
