--+ holdcas on;
-- TRUE
prepare s from 'select count(*) into :result from db_root where ?<>0';
execute s using true;
deallocate prepare s;
select count(*) into :expected from db_root where true;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- FALSE
prepare s from 'select count(*) into :result from db_root where ?<>0';
execute s using false;
deallocate prepare s;
select count(*) into :expected from db_root where false;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- AND
prepare s from 'select count(*) into :result from db_root where ?<>0 and ?<>0';
execute s using true, true;
deallocate prepare s;
select count(*) into :expected from db_root where true and true;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select count(*) into :result from db_root where ?<>0 and ?<>0';
execute s using true, false;
deallocate prepare s;
select count(*) into :expected from db_root where true and false;
select case when :expected = :result then 'YES' else 'NO' end as case4;

prepare s from 'select count(*) into :result from db_root where ?<>0 and ?<>0';
execute s using false, true;
deallocate prepare s;
select count(*) into :expected from db_root where false and true;
select case when :expected = :result then 'YES' else 'NO' end as case5;

prepare s from 'select count(*) into :result from db_root where ?<>0 and ?<>0';
execute s using false, false;
deallocate prepare s;
select count(*) into :expected from db_root where false and false;
select case when :expected = :result then 'YES' else 'NO' end as case6;

-- OR
prepare s from 'select count(*) into :result from db_root where ?<>0 or ?<>0';
execute s using true, true;
deallocate prepare s;
select count(*) into :expected from db_root where true or true;
select case when :expected = :result then 'YES' else 'NO' end as case7;

prepare s from 'select count(*) into :result from db_root where ?<>0 or ?<>0';
execute s using true, false;
deallocate prepare s;
select count(*) into :expected from db_root where true or false;
select case when :expected = :result then 'YES' else 'NO' end as case8;

prepare s from 'select count(*) into :result from db_root where ?<>0 or ?<>0';
execute s using false, true;
deallocate prepare s;
select count(*) into :expected from db_root where false or true;
select case when :expected = :result then 'YES' else 'NO' end as case9;

prepare s from 'select count(*) into :result from db_root where ?<>0 or ?<>0';
execute s using false, false;
deallocate prepare s;
select count(*) into :expected from db_root where false or false;
select case when :expected = :result then 'YES' else 'NO' end as case10;

-- XOR
prepare s from 'select count(*) into :result from db_root where ?<>0 xor ?<>0';
execute s using true, true;
deallocate prepare s;
select count(*) into :expected from db_root where true xor true;
select case when :expected = :result then 'YES' else 'NO' end as case11;

prepare s from 'select count(*) into :result from db_root where ?<>0 xor ?<>0';
execute s using true, false;
deallocate prepare s;
select count(*) into :expected from db_root where true xor false;
select case when :expected = :result then 'YES' else 'NO' end as case12;

prepare s from 'select count(*) into :result from db_root where ?<>0 xor ?<>0';
execute s using false, true;
deallocate prepare s;
select count(*) into :expected from db_root where false xor true;
select case when :expected = :result then 'YES' else 'NO' end as case13;

prepare s from 'select count(*) into :result from db_root where ?<>0 xor ?<>0';
execute s using false, false;
deallocate prepare s;
select count(*) into :expected from db_root where false xor false;
select case when :expected = :result then 'YES' else 'NO' end as case14;

-- NOT
prepare s from 'select count(*) into :result from db_root where not ?<>0';
execute s using true;
deallocate prepare s;
select count(*) into :expected from db_root where not true;
select case when :expected = :result then 'YES' else 'NO' end as case15;

prepare s from 'select count(*) into :result from db_root where not ?<>0';
execute s using false;
deallocate prepare s;
select count(*) into :expected from db_root where not false;
select case when :expected = :result then 'YES' else 'NO' end as case16;

prepare s from 'select count(*) into :result from db_root where not ? = ?';
execute s using 0, 0;
deallocate prepare s;
select count(*) into :expected from db_root where not 0 = 0;
select case when :expected = :result then 'YES' else 'NO' end as case17;

prepare s from 'select count(*) into :result from db_root where not ? = ?';
execute s using 0, 1;
deallocate prepare s;
select count(*) into :expected from db_root where not 0 = 1;
select case when :expected = :result then 'YES' else 'NO' end as case18;


prepare s from 'select count(*) into :result from db_root where ? = ? or ? = ?';
execute s using 0, 1, 0, 0;
deallocate prepare s;
select count(*) into :expected from db_root where 0 = 1 or 0 = 0;
select case when :expected = :result then 'YES' else 'NO' end as case19;

--+ holdcas off;
