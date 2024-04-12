--+ server-message on
-- Vefified for CBRD-24962
-- SQL%ROWCOUNT must be zero after COMMIT AND ROLLBACK

create or replace procedure t as
	i int;
begin

	select charset_id into i from db_charset where charset_name='utf8';
	dbms_output.put_line(sql%rowcount);
	rollback;
	dbms_output.put_line(sql%rowcount);
end;

call t();

create or replace procedure t as
	i int;
begin

	select charset_id into i from db_charset where charset_name='utf8';
	dbms_output.put_line(sql%rowcount);
	commit;
	dbms_output.put_line(sql%rowcount);
end;

call t();

drop procedure t;

--+ server-message on
