--+ server-message on

-- Change the no_backslash_escapes parameter setting to “no”.

SET SYSTEM PARAMETERS 'ansi_quotes=yes; no_backslash_escapes=no' ;

create or replace function t(a varchar, b varchar) return int as 
    str_a varchar := a;
    str_b varchar := b;
    N int ;
begin
    SELECT STRCMP(str_a, str_b) INTO N;
    return N ;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

select t('single quotes test('')', 'single quotes test(\')') ;
select t('single quotes test('')', 'single quotes test('')');


create or replace procedure call_t( )  as
   str_a varchar;
begin
    SELECT t('single quotes test('')', 'single quotes test(\')') INTO str_a;
     dbms_output.put_line('t output=' || str_a);
end;

drop function t;

SET SYSTEM PARAMETERS 'ansi_quotes=yes; no_backslash_escapes=yes' ;
--+ server-message off
