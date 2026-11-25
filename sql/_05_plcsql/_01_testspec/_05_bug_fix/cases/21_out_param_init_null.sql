/**
 *  This test case verifies CBRD-24947: an OUT parameter of a PL/CSQL procedure starts as NULL
 *
 *  The procedure prints whether its OUT parameter is NULL on entry, sets it, and passes
 *  it to a local procedure with an OUT parameter, which prints the same.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  an OUT parameter is NULL on entry, in the procedure and in its local procedure, though the caller passes 7; result = null, null
 */

--+ server-message on

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


evaluate 'Case 1: an OUT parameter is NULL on entry, in the procedure and in its local procedure, though the caller passes 7; result = null, null';
select 7 into :a;
call test_out_param(:a);

drop procedure test_out_param;

select a from dual;

--+ server-message off
