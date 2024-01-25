--+ server-message on

-- Korean characters are used in procedure names.

create procedure "프로시져"(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

select * from db_stored_procedure where sp_name = '프로시져';
select * from db_stored_procedure_args where sp_name = '프로시져';

call "프로시져"(7);
call [프로시져](6);
call `프로시져`(5);

drop procedure "프로시져";


create procedure "프로시져_파라미터"(파라미터_1 int) as 
 변수_1 varchar := '123';
  상수_1 constant  int := 789;
begin
    dbms_output.put_line('파라미터_1=' || 파라미터_1);
    dbms_output.put_line('변수_1=' || 변수_1);
    dbms_output.put_line('상수_1=' || 상수_1);
end;

select * from db_stored_procedure where sp_name = '프로시져_파라미터';
select * from db_stored_procedure_args where sp_name = '프로시져_파라미터';

call "프로시져_파라미터"(7);
call [프로시져_파라미터](6);
call `프로시져_파라미터`(5);

drop procedure "프로시져_파라미터";


--+ server-message off

