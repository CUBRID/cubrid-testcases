--+ server-message on
-- Verified for CBRD-24901

-- error, char type limit is '1073741823'
create or replace procedure varchar_limit(t_query varchar) as
	varchar_1 varchar(1073741824);
begin
	execute immediate t_query into varchar_1;
	
	dbms_output.put_line('varchar: ' || varchar_1);
end;

--+ server-message off