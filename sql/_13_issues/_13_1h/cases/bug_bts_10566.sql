set names utf8;

drop if exists t1; 

create table t1(fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'));
insert into t1 values ('orange');

--note: good result
select * from t1 where  fruit > 'apple';

prepare st from 'select * from t1 where  fruit > ?';
--test: in fact, result is incorrect and return nothing. we expect this is successful like above .
execute st using 'apple';

--note: good result
execute st using _iso88591'apple';
deallocate prepare st;

prepare st from 'select * from t1 where  fruit > ?';
--test: in fact, result is incorrect and return nothing. we expect this is successful like above .
execute st using 'apple';

--note: good result
execute st using _iso88591'apple';
deallocate prepare st;

select * from t1 where  fruit > 'apple' and fruit  <= 'strawberry';
select * from t1 where  fruit > '' and fruit  <= '';

prepare st from 'select * from t1 where  fruit > ? and fruit  <= ?;';
execute st using 'apple','strawberry' ;
execute st using '','' ;
execute st using 'null','NULL' ;
deallocate prepare st;

drop table t1;

set names iso88591;


