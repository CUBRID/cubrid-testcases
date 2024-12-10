--+ server-message on
-- Verified for CBRD-24901

-- error, char type limit is '1073741823'
create or replace procedure varchar_limit(t_query varchar) as
	varchar_1 varchar(1073741824);
begin
	execute immediate t_query into varchar_1;
	
	dbms_output.put_line('varchar: ' || varchar_1);
end;

--error, size range is 1 ~ 1073741823
create or replace procedure varchar_zero(t_query varchar) as
	varchar_1 varchar(0);
begin
	execute immediate t_query into varchar_1;
	
	dbms_output.put_line('varchar: ' || varchar_1);
end;

--error, size range is 1 ~ 1073741823
create or replace procedure varchar_minus(t_query varchar) as
	varchar_1 varchar(-1);
begin
	execute immediate t_query into varchar_1;
	
	dbms_output.put_line('varchar: ' || varchar_1);
end;


create or replace procedure varchar_limit2(t_query varchar) as
	vch_1 varchar(1073741823);
	vch_length varchar(10);
begin
	execute immediate t_query into vch_1;
	select length(vch_1) into vch_length from dual;

	dbms_output.put_line('varchar size 1073741823');
	dbms_output.put_line('length:  ' || vch_length);
end;

call varchar_limit2('select ''a'' from dual');
call varchar_limit2('select ''a'' || space(1048575) from dual');
call varchar_limit2('select repeat(''a'', 1048576) from dual');

-- hangul is 1 letter = 3 size
call varchar_limit2('select ''한글'' from dual');
call varchar_limit2('select repeat(''한'', 349525) from dual');

create or replace procedure varchar_limit3(vch_param varchar) as
	vch_1 varchar(1) := vch_param;
	vch_length varchar(1);
begin
	select length(vch_1) into vch_length from dual;
	
	dbms_output.put_line('varchar size 1');
	dbms_output.put_line('length:  ' || vch_length);
end;

call varchar_limit3('a');
-- hangul is broken, because the DB character set is iso-88591 (UTF-8 was fine)
call varchar_limit3('한');
-- error, size over
call varchar_limit3('abcd');
call varchar_limit3('한글');


drop procedure varchar_limit2;
drop procedure varchar_limit3;

--+ server-message off
