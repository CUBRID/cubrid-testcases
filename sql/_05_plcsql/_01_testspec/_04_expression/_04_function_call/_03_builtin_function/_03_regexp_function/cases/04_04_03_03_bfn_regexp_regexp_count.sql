--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line('-- NULL param returns without error');
    dbms_output.put_line(REGEXP_COUNT ('abc', NULL));
    dbms_output.put_line(REGEXP_COUNT ('', NULL));
    dbms_output.put_line(REGEXP_COUNT (NULL, NULL));
    dbms_output.put_line(REGEXP_COUNT (NULL,''));

    dbms_output.put_line('-- match returns without error pattern1');
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','', NULL));
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','a.', 1));
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','a.', 4));
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','a.', 8));
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','[b3]', 1));
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','[b3]', 4));
    dbms_output.put_line(REGEXP_COUNT('ab123ab111a','[b3]', 8));

    dbms_output.put_line('-- match returns without error pattern2');
    dbms_output.put_line(REGEXP_COUNT('1,2,3', ',[^,]+,'));
    dbms_output.put_line(REGEXP_COUNT('1,2,3', '^[,]+.'));

    dbms_output.put_line('-- match returns without error pattern3');
    dbms_output.put_line(REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, 'i'));
    dbms_output.put_line(REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, 'c'));
    dbms_output.put_line(REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, ''));
    dbms_output.put_line(REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, NULL));

    dbms_output.put_line('-- match returns without error pattern4');
    dbms_output.put_line(REGEXP_COUNT('Klak Aleksander', '[[:alpha:]]+', 1)); 	-- 2 ko_KR.utf8
    dbms_output.put_line(REGEXP_COUNT('Kłak Aleksander', '[[:alpha:]]+', 1)); 	-- 3 ko_KR.utf8
    dbms_output.put_line(REGEXP_COUNT('Kłak Aleksander', '\p{Hangul}+', 1)); 	-- 0 ko_KR.utf8

    dbms_output.put_line('-- match returns without error pattern5');
    dbms_output.put_line(REGEXP_COUNT('192.168.1.119', '192\.168\.1\.\d{1,3}'));
    dbms_output.put_line(REGEXP_COUNT('02-483-4837', '^\d{2,3}-\d{3,4}-\d{4}$'));
    dbms_output.put_line(REGEXP_COUNT('010-4837-4837', '^010-\d{3,4}-\d{4}$'));
    dbms_output.put_line(REGEXP_COUNT('770108-1034564', '^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
