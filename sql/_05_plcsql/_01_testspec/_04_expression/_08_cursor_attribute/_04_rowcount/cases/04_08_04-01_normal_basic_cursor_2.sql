--+ server-message on

-- normal: using %notfound on a cursor with for cursor loop


create or replace procedure t(i int) as
    cursor c is select coll_id, coll_name from db_collation limit 10;
begin
    for r in c loop
        dbms_output.put_line('in loop body: ' || c%rowcount);
    end loop;

    dbms_output.put_line('after loop: ' || c%rowcount);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

-- verified the CBRD-25548
-- cursor%rowcount becomes zero when cursor%notfound holds
create or replace procedure poo as
    cursor c is select class_name from db_class where is_system_class='YES' order by class_name limit 5;
    var_class_name varchar(300);
begin
    open c;

    dbms_output.put_line(c%rowcount);

    loop
        fetch c into var_class_name;
        exit when c%notfound;
        dbms_output.put_line(c%rowcount);
    end loop;

    dbms_output.put_line(c%rowcount);

    close c;
end;

call poo();
drop PROCEDURE poo;



--+ server-message off
