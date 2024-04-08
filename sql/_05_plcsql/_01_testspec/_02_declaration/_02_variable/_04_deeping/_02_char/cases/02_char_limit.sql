--+ server-message on
-- Verified for CBRD-24901

-- error, char type limit is '268435455'
create or replace procedure char_limit1(t_query varchar) as
	ch_1 character(268435456);
begin
	execute immediate t_query into ch_1;
	
	dbms_output.put_line('char: ' || ch_1);
end;

-- error, char_limit1 is not exist
drop procedure char_limit1;

--+ server-message off