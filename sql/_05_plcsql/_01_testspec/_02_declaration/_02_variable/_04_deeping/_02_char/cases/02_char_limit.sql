--+ server-message on
-- Verified for CBRD-24901

-- error, char type limit is '268435455'
create or replace procedure char_limit1(t_query varchar) as
	ch_1 character(268435456);
begin
	execute immediate t_query into ch_1;
	
	dbms_output.put_line('char: ' || ch_1);
end;

--error, size range is 1 ~ 268435455
create or replace procedure char_zero(t_query varchar) as
	ch_1 character(0);
begin
	execute immediate t_query into ch_1;
	
	dbms_output.put_line('char: ' || ch_1);
end;

--error, size range is 1 ~ 268435455
create or replace procedure char_minus(t_query varchar) as
	ch_1 character(-1);
begin
	execute immediate t_query into ch_1;
	
	dbms_output.put_line('char: ' || ch_1);
end;


create or replace procedure char_limit2(p_varchar char(1)) as
	ch_1 character(268435455) := p_varchar;
	ch_length varchar(10);
begin
	select length(ch_1) into ch_length from dual;
	
	dbms_output.put_line('char_length: ' || ch_length);
end;

call char_limit2('a');

drop procedure char_limit2;

--+ server-message off