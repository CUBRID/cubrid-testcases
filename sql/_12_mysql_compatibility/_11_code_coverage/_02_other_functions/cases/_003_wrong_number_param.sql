-- row_count , rand , unix_timestamp , atan, field, locate , strcmp, reverse , 
-- bit_count

create table t1 ( i1 integer , i2 integer );
insert into t1 values (1,1),(1,2),(2,3),(2,2),(2,5),(3,5);
select * from t1 order by i1 , i2;

-- should fail
select row_count(i1) from t1 order by 1,2;

-- should fail
select rand(2,1) ;

-- should fail
select unix_timestamp(2,1);

-- should fail
select atan();

-- should return NULL
select atan(i1) from t1 order by 1;

-- should fail
select field('1');

-- should return 1
select field('1','1');

-- should fail
select locate('1');

-- should fail
select strcmp('1');

-- should fail
select reverse('2','1');


-- should fail
select bit_count(2,2);

-- should fail
select list_dbs(2);

drop table t1;

