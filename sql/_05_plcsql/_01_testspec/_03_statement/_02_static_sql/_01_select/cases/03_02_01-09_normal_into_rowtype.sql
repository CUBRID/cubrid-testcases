--+ server-message on
-- Verified for CBRD-2558
-- Check whether an error occurs when there is a field expression (<record>.<field>) in the 'INTO' clause of a 'Static SQL Select' statement.

drop table if exists tbl;

create table tbl(id int, val int);
insert into tbl values(1, 100);

create or replace procedure poo() as 
	r tbl%rowtype;
	v tbl.val%type; 
begin
	select val into r.val from tbl limit 1;
	dbms_output.put_line(r.val);

	select r.val into r.val from tbl r limit 1;
	dbms_output.put_line(r.val);

	select val into v from tbl limit 1;
	dbms_output.put_line(v);

	execute immediate 'select val from tbl limit 1' into r.val;
	dbms_output.put_line(r.val);

	execute immediate 'select r.val from tbl r limit 1' into r.val;
	dbms_output.put_line(r.val);

	execute immediate 'select val from tbl limit 1' into v;
	dbms_output.put_line(v);
end;

call poo();

drop procedure poo;
drop table tbl;
--+ server-message off
