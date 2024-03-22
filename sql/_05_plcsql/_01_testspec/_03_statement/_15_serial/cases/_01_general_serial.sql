--+ server-message on
/*
Verification for CBRD-24481, CBRD-24869
In the plcsql, call serial, and insert serial result on the table.

FYI, serial.NEXTVAL's first call is returns the start value.
it is CUBRID spec.
ex: 'create serial demo_serial start with 0 increment by 5;'
1. call serial.NEXTVAL = 0
2. call serial.NEXTVAL = 5
3. call serial.NEXTVAL = 10
*/
drop serial if exists demo_serial;
create serial demo_serial start with 0 increment by 5;

create or replace function func_demo_serial() return numeric as
	a numeric := 0;
	i numeric := 0;
begin
	a := demo_serial.CURRVAL;
	dbms_output.put_line('CURRVAL: ' || a);
	
	i := demo_serial.NEXTVAL;
    dbms_output.put_line('NEXTVAL: ' || i);
	return i;
end;

drop table if exists t1;
create table t1(col int);

select func_demo_serial() as "call serial 1" from dual;
insert into t1 values(func_demo_serial()); -- call serial 2
select * from t1;
select func_demo_serial() as "call serial 3" from dual;

drop table t1;
drop function func_demo_serial;
drop serial demo_serial;

--+ server-message off