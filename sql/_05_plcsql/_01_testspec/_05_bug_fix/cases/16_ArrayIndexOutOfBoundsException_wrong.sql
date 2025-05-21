--+ server-message on
-- verified the CBRD-25507
-- ArrayIndexOutOfBoundsException occurs when processing Cursor query
-- It is not fixed yet and an error is occurring.
-- After the issue is resolved, the person in charge should change the answer sheet.
-- bug

create table tbl(i int);
insert into tbl select rownum from db_class a, db_class b, db_class c limit 2000;


create or replace procedure test_record_in_fetch as
    cursor c is select i from tbl;
    code int;
    cnt int := 0;
begin
    open c;     
    loop
        fetch c into code;
        exit when c%notfound;
        cnt := cnt + 1;
    end loop;
    close c;
    dbms_output.put_line('cnt=' || cnt);
end;

call test_record_in_fetch();

drop procedure test_record_in_fetch;
drop table tbl;

--+ server-message off
