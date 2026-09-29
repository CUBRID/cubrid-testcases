--+ holdcas on;
-- workspace#368 (map #312, dpin-18b, review 2 R2-07): TO_NUMBER leaves its node's domain as compiled - a cached one the
-- plan shares - where develop wrote each value's precision and scale into it; the value carries them. Every answer is
-- develop's: a constant format, a format per row, a bind format, TO_NUMBER under ORDER BY, SUM and MAX, and casts to
-- NUMERIC prepared before a TO_NUMBER and executed after it.
drop table if exists tn_t;
create table tn_t (s varchar(20), f varchar(20), n numeric, v varchar(20));
insert into tn_t values ('12.34', '99.99', 1.555, '1.555');
insert into tn_t values ('123.456', '999.999', 2.25, '2.25');
insert into tn_t values ('7', '9', 3, '3');

-- a constant format
select to_number ('12.34', '99.99') from db_root;
select to_number ('1.5', '9.9'), to_number ('123.456', '999.999') from db_root;
select to_number (s, '999.999') from tn_t order by 1;

-- a format per row
select to_number (s, f) from tn_t order by 1;
select s, to_number (s, f) from tn_t order by 1;
select sum (to_number (s, f)), max (to_number (s, f)), min (to_number (s, f)) from tn_t;

-- a bind format
prepare tn_q from 'select to_number (s, ?) from tn_t order by 1';
execute tn_q using '999.999';
execute tn_q using '9999.999';
deallocate prepare tn_q;

-- casts to NUMERIC prepared before a TO_NUMBER, executed after it
prepare tn_c from 'select cast (v as numeric), cast (? as numeric), n + 0 from tn_t order by 3';
execute tn_c using '2.345';
select to_number ('12.34', '99.99') from db_root;
execute tn_c using '2.345';
select to_number ('123456.7', '999999.9') from db_root;
execute tn_c using '2.345';
deallocate prepare tn_c;
select cast (v as numeric), cast ('2.345' as numeric), n from tn_t order by 3;

drop table tn_t;
--+ holdcas off;
