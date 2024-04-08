--+ server-message on
-- Verified for CBRD-24901

create or replace procedure varchar_test1(t_query varchar) as
	varchar_1 varchar(20);
begin
	execute immediate t_query into varchar_1;
	
	dbms_output.put_line('check size 20 (not default size)');
	dbms_output.put_line('varchar: "' || varchar_1 ||'"');
end;

call varchar_test1('select cast(''abc'' as varchar(3)) from dual;');


create or replace procedure varchar_test2() as
	num_1 varchar(20) := 3;
	num_2 varchar(5) := 8;
begin
	dbms_output.put_line('compared to between two varchar type');
	if num_1 < num_2 then
		dbms_output.put_line('bigger:  "' || num_2 ||'"');
		dbms_output.put_line('smaller: "' || num_1 ||'"');
	else
		dbms_output.put_line('error, num_1: ' || num_1);
		dbms_output.put_line('error, num_2: ' || num_2);
	end if;
end;

call varchar_test2();


create or replace procedure varchar_test3(t_query varchar) as
	varchar_1 varchar;
begin
	execute immediate t_query into varchar_1;
	
	dbms_output.put_line('check to varchar type default size (default is 1073741823)');
	dbms_output.put_line('varchar: "' || varchar_1 ||'"');
end;

call varchar_test3('select cast(''a'' as varchar) from dual;');
call varchar_test3('select cast(''abcdefghijklmnopqrstuvwxyz'' as varchar) from dual;');


drop procedure varchar_test1;
drop procedure varchar_test2;
drop procedure varchar_test3;

--+ server-message off