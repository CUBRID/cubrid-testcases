--+ server-message on

-- extended usage of exit with when clause

create or replace procedure t() as
begin
    for i in 1 .. 5 loop
		dbms_output.put_line('in loop');
        EXIT WHEN NOT TRUE;
		dbms_output.put_line('not true');
        EXIT WHEN FALSE;
		dbms_output.put_line('false');
        EXIT WHEN i = 5;
		dbms_output.put_line('i = 5');
	EXIT WHEN not i <> 5;
		dbms_output.put_line('not i <> 5');
        EXIT WHEN i <=> 5;
		dbms_output.put_line('i <=> 5');
        EXIT WHEN i < 0;
		dbms_output.put_line('i < 5');
        EXIT WHEN i > 5;
		dbms_output.put_line('i > 5');
        EXIT WHEN i <= -1;
		dbms_output.put_line('i = -1');
        EXIT WHEN i >= 5;
		dbms_output.put_line('i >=5 ');
        EXIT WHEN 5 <> 5;
		dbms_output.put_line('i <> 5');
        EXIT WHEN 5 != 5;
		dbms_output.put_line('i != 5');
        EXIT WHEN i is null ;
		dbms_output.put_line('i is null');
        EXIT WHEN 'aaa' like 'aa';
		dbms_output.put_line('aaa like aa');
	EXIT WHEN 'aaa' like 'bb%';
		dbms_output.put_line('aaa like bb%');
        EXIT WHEN i between 2 and 3;
		dbms_output.put_line(i || ' between 2 and 3');
        EXIT WHEN '1' in ('2');
		dbms_output.put_line('in (2)');
        EXIT WHEN not NULL is NULL;
		dbms_output.put_line('not NULL is NULL');
        EXIT WHEN NVL(i,NULL) is NULL;
		dbms_output.put_line('NVL(' ||i ||',NULL) is NULL');
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
