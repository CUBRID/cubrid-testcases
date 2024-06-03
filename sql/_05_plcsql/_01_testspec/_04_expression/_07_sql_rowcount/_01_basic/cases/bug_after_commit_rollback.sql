--+ server-message on
-- Vefified for CBRD-24962
-- SQL%ROWCOUNT must be zero after COMMIT AND ROLLBACK
set system parameters 'pl_transaction_control=yes';

drop table if exists test;
create table test ( col1 int );
insert into test values(1),(2),(3),(4),(5);

create or replace procedure t1 as
	i int;
begin
	insert into test values(1),(2),(3),(4),(5);
	dbms_output.put_line('after insert: ' || sql%rowcount);
	commit;
	dbms_output.put_line('after commit: ' || sql%rowcount);

	update test set col1 = col1 +1 ;
	dbms_output.put_line('after update: ' || sql%rowcount);
	commit;
	dbms_output.put_line('after commit: ' || sql%rowcount);

	delete from test where col1 < 5;
	dbms_output.put_line('after delete: ' || sql%rowcount);
	commit;
	dbms_output.put_line('after commit: ' || sql%rowcount);
end;

call t1();

-- initialize
drop table test;
create table test ( col1 int );
insert into test values(1),(2),(3),(4),(5);

create or replace procedure t2 as
	i int;
begin
	insert into test values(1),(2),(3),(4),(5);
	dbms_output.put_line('after insert: ' || sql%rowcount);
	rollback;
	dbms_output.put_line('after rollback: ' || sql%rowcount);

	update test set col1 = col1 +1;
	dbms_output.put_line('after update: ' || sql%rowcount);
	rollback;
	dbms_output.put_line('after rollback: ' || sql%rowcount);
	
	delete from test where col1 < 5;
	dbms_output.put_line('after delete: ' || sql%rowcount);
	rollback;
	dbms_output.put_line('after rollback: ' || sql%rowcount);
end;

call t2();

drop procedure t1;
drop procedure t2;
drop table test;

--+ server-message on
