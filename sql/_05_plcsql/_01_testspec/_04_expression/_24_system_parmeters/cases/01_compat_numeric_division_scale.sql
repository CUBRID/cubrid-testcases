--+ server-message on
-- verified the CBRD-25733
-- Check if the system parameter 'compat_numeric_division_scale' changes dynamically in sp.
-- compat_numeric_division_scale=yes : The number of decimal places in the quotient is determined by the number of decimal places in the operand.
-- compat_numeric_division_scale=no(default) : The number of decimal places in the quotient is 9.

create or replace procedure division_type_test()
as
	a double := 1;
	b double := 128;
	c varchar;
	n double := 1/2;
begin
	select typeof(a/b) into c from dual;
	dbms_output.put_line('double div typeof:'||c);
	select a/b into c from dual;
	dbms_output.put_line('double div:'||c);

	dbms_output.put_line('double(1/2):'||n);
end;

create or replace procedure number_division_behavior_test 
as
	procedure inner1 
	as
		a float := 1;
		b float := 2;
		c double := 1;
		d double := 2;
		e numeric(10, 4) := 1.234;
		f numeric(10, 4) := 2.234;
	begin
		dbms_output.put_line('float div:' || a/b);
		dbms_output.put_line('double div:' || c/d);
		dbms_output.put_line('numeric(10, 4) div:' || e/f);
	end;

	procedure inner2 
	as
		a short := 1;
		b short := 2;
		l int := 1;
		m int := 2;
		s bigint := 1;
		t bigint := 2;
	begin
		dbms_output.put_line('short div:' || a/b);
		dbms_output.put_line('int div:' || l/m);
		dbms_output.put_line('bigint div:' || s/t);
	end;
begin
	inner1();
	inner2();
end;

create or replace procedure compat_numeric_division_scale_test 
as
	a numeric(4, 3) := 1;
	b numeric(4, 3) := 8;
begin
	dbms_output.put_line('numeric div:' || a/b);
end;

evaluate 'compat_numeric_division_scale=no(default)';
evaluate 'division_type_test';
call division_type_test();
evaluate 'number_division_behavior_test';
call number_division_behavior_test();
evaluate 'compat_numeric_division_scale_test';
call compat_numeric_division_scale_test();

set system parameters 'compat_numeric_division_scale=yes';
evaluate 'compat_numeric_division_scale=yes';
evaluate 'division_type_test';
call division_type_test();
evaluate 'number_division_behavior_test';
call number_division_behavior_test();
evaluate 'compat_numeric_division_scale_test';
call compat_numeric_division_scale_test();

set system parameters 'compat_numeric_division_scale=no';
evaluate 'compat_numeric_division_scale=no';
evaluate 'division_type_test';
call division_type_test();
evaluate 'number_division_behavior_test';
call number_division_behavior_test();
evaluate 'compat_numeric_division_scale_test';
call compat_numeric_division_scale_test();

drop procedure division_type_test;
drop procedure number_division_behavior_test;
drop procedure compat_numeric_division_scale_test;

--+ server-message off
