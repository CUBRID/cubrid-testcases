-- and
select 29 & 15 into :expected;

prepare s from 'select ? & ? into :result'
execute s using 29, 15
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as case1;

-- or
select 29 | 15 into :expected;

prepare s from 'select ? | ? into :result'
execute s using 29, 15
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as case2;

-- not

select 5 & ~1 into :expected;

prepare s from 'select ? & ~? into :result'
execute s using 5, 1
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as case3;

-- xor
select 1 ^ 1 into :expected;

prepare s from 'select ? ^ ? into :result'
execute s using 1, 1
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as case4;


-- between 
create table tbla1 (a int);
insert into tbla1 values(1);


select count(*) into :expected from tbla1 where a between 0 and 20;

prepare s from 'select count(*) into :result from tbla1 where a between ?+? and ?+?;'
execute s using 0, 0, 10, 10
deallocate prepare s;

select case when (:expected = :result) then 'YES' else 'NO' end as case5;

drop table tbla1;
