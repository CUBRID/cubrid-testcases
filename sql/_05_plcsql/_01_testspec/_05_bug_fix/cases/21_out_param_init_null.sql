--+ server-message on
-- Verified for CBRD-24947

create or replace procedure test_out_param(i OUT int) as
    procedure print_null_or_not(k int) as
    begin
        dbms_output.put_line(case when k is null then 'null' else 'non-null' end);
    end;
    procedure inner(j OUT int) as
    begin
        print_null_or_not(j);
        i := 777;
    end;
begin
    print_null_or_not(i);
    i := 77;
    inner(i);
end;


select 7 into :a;
call test_out_param(:a);

drop procedure test_out_param;

select a from dual;

--+ server-message off
