--+ holdcas on;
-- 1
prepare s from 'select ACOS (?) into :result';
execute s using 1;
deallocate prepare s;

evaluate ACOS(1) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select cast(ASIN (?) as float) into :result';
execute s using 0.2;
deallocate prepare s;

evaluate cast(ASIN(0.2) as float) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select ATAN (?) into :result';
execute s using 2;
deallocate prepare s;

evaluate ATAN(2) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select ATAN (?, ?) into :result';
execute s using -2, 2;
deallocate prepare s;

evaluate ATAN(-2, 2) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case4;

-- 5
prepare s from 'select ATAN2 (?, ?) into :result';
execute s using 3.14159265358979323846264338, 0;
deallocate prepare s;

evaluate ATAN2(3.14159265358979323846264338, 0) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case5;

-- 6
--/*
--prepare s from 'select CEIL (?) into :result' -- FAIL
--execute s using 1.23;
--deallocate prepare s;
--
--evaluate CEIL(1.23) into :expected;
--select case when (:expected = :result) then 'YES' else 'NO' end as case6;
--*/
--
---- 7
--/*
--prepare s from 'select CEILING (?) into :result' -- FAIL
--execute s using -1.23;
--deallocate prepare s;
--
--evaluate CEILING(-1.23) into :expected;
--select case when (:expected = :result) then 'YES' else 'NO' end as case7;
--*/

-- 8
prepare s from 'select COS (?) into :result';
execute s using 3.14159265358979323846264338;
deallocate prepare s;

evaluate COS(3.14159265358979323846264338) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case8;

-- 9
prepare s from 'select DEGREES (?) into :result';
execute s using 3.14159265358979323846264338;
deallocate prepare s;

evaluate DEGREES(3.14159265358979323846264338) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case9;

-- 10
prepare s from 'select FORMAT (?, ?) into :result';
execute s using 12332.123456, 4;
deallocate prepare s;

evaluate FORMAT(12332.123456, 4) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case10;

-- 11
prepare s from 'select LN (?) into :result';
execute s using 2;
deallocate prepare s;

evaluate LN(2) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case11;

-- 12
prepare s from 'select LOG2 (?) into :result';
execute s using 65536;
deallocate prepare s;

evaluate LOG2(65536) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case12;

-- 13
prepare s from 'select LOG10 (?) into :result';
execute s using 2;
deallocate prepare s;

evaluate LOG10(2) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case13;

-- 14
--/*
--prepare s from 'select POW (?, ?) into :result'  -- FAIL (same as POWER)
--execute s using 2, 2;
--deallocate prepare s;
--
--evaluate POW(2, 2) into :expected;
--select case when (:expected = :result) then 'YES' else 'NO' end as case14;
--*/

-- 15
prepare s from 'select RADIANS (?) into :result';
execute s using 90;
deallocate prepare s;

evaluate RADIANS(90) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case15;

-- 16
prepare s from 'select RAND (?) into :result';
execute s using 3;
deallocate prepare s;

evaluate RAND (3) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case16;

-- 17
prepare s from 'select substr(to_char(DRAND (?)), 0, 10) into :result';
execute s using 3;
deallocate prepare s;

evaluate substr(to_char(DRAND(3)), 0, 10) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case17;

-- 18
prepare s from 'select RANDOM (?) into :result';
execute s using 3;
deallocate prepare s;

evaluate RANDOM(3) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case18;

-- 19
prepare s from 'select substr(to_char(DRANDOM (?)), 0, 10) into :result';
execute s using 3;
deallocate prepare s;

evaluate substr(to_char(DRANDOM(3)), 0, 10) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case19;

-- 20
--prepare s from 'select SIN (?) into :result'
--execute s using 3.14159265358979323846264338
--deallocate prepare s;

--evaluate SIN(3.14159265358979323846264338) into :expected;
--select case when (:expected = :result) then 'YES' else 'NO' end as case20;

-- 21
prepare s from 'select SQRT (?) into :result';
execute s using 4;
deallocate prepare s;

evaluate SQRT(4) into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case21;

-- 22
--prepare s from 'select TAN (?) into :result'
--execute s using 3.14159265358979323846264338
--deallocate prepare s;

--evaluate TAN(3.14159265358979323846264338) into :expected;
--select case when (:expected = :result) then 'YES' else 'NO' end as case22;

-- 23
--/*
--prepare s from 'select TRUNCATE (?, ?) into :result' -- FAIL
--execute s using 1.223, 1;
--deallocate prepare s;
--
--evaluate TRUNCATE(1.223, 1) into :expected;
--select case when (:expected = :result) then 'YES' else 'NO' end as case23;
--*/

--+ holdcas off;
