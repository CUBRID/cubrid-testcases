--+ server-message on
-- verified for CBRD-24782

drop if exists temp_table;

create table temp_table(col int);
insert into temp_table values (0), (1), (2), (4);

select * from temp_table;

create or replace procedure trunc_test as
begin
	truncate temp_table;
end;

call trunc_test();

select * from temp_table;

drop procedure trunc_test;

drop temp_table;

--+ server-message off
