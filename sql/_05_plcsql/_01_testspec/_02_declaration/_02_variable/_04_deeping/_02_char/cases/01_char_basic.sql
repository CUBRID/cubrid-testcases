--+ server-message on
-- Verified for CBRD-24901

create or replace procedure char_test1(t_query varchar) as
	ch_1 character(20);
begin
	execute immediate t_query into ch_1;
	
	dbms_output.put_line('append spaces until filling char size');
	dbms_output.put_line('char: "' || ch_1 ||'"');
end;

call char_test1('select cast(''abc'' as char(3)) from dual;');
-- error, size over
call char_test1('select cast(''abc'' as char(21)) from dual;');


create or replace procedure char_test2() as
	num_1 character(20) := 2;
	num_2 character(5) := 10;
begin
	dbms_output.put_line('rtrim test, when compared to between two char type (10 < 2)');
	if num_2 < num_1 then
		dbms_output.put_line('bigger:  "' || num_2 ||'"');
		dbms_output.put_line('smaller: "' || num_1 ||'"');
	else
		dbms_output.put_line('error, num_1: ' || num_1);
		dbms_output.put_line('error, num_2: ' || num_2);
	end if;

	dbms_output.put_line('rtrim test, when compared to between two char type  (2 < 10)');
	if num_1 < num_2 then
		dbms_output.put_line('bigger:  "' || num_2 ||'"');
		dbms_output.put_line('smaller: "' || num_1 ||'"');
	else
		dbms_output.put_line('error, num_1: ' || num_1);
		dbms_output.put_line('error, num_2: ' || num_2);
	end if;
end;

call char_test2();


create or replace procedure char_test3(t_query varchar) as
	ch_1 character;
	ch_length char(1);
begin
	execute immediate t_query into ch_1;
	select length(ch_1) into ch_length from dual;
	
    dbms_output.put_line('check the default size');
	dbms_output.put_line('char: "' || ch_1 ||'"');
	dbms_output.put_line('length: ' || ch_length);
end;

call char_test3('select cast(''a'' as char(1)) from dual;');
-- error, character type default size is 1
call char_test3('select cast(''abc'' as char(3)) from dual;');


drop procedure char_test1;
drop procedure char_test2;
drop procedure char_test3;

--+ server-message off
