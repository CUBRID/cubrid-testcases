--+ server-message on
-- Verified for CBRD-24965
-- Typing fails for expressions of the form <date/time> +/- NULL

create or replace procedure poo as
	a date := date'2023-10-10' + NULL;
	b time := time'11:22:33' + NULL;
	c datetime := datetime'2023-10-10 11:22:33' + NULL;
	d timestamp := timestamp'11:22:33 10/10/2023' + NULL;
	e date := date'2023-10-10' - NULL;
	f time := time'11:22:33' - NULL;
	g datetime := datetime'2023-10-10 11:22:33' - NULL;
	h timestamp := timestamp'11:22:33 10/10/2023' - NULL;
begin
	dbms_output.put_line('date type calculate include NULL');
end;

-- Expect to print the put_line message but the other is Error.
call poo();

drop procedure poo;

--+ server-message off
