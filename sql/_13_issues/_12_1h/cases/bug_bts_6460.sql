prepare stmt from 'SELECT -9223372036854775808 DIV -1';

SELECT -9223372036854775808 DIV -1;
SELECT cast (-2147483648 as int) DIV cast (-1 as short);
SELECT cast (-32768 as short) DIV cast (-1 as short); 

create table t1 (x bigint, y int, z short);
insert into t1 values (-9223372036854775808, -2147483648, -32768);

select x div -1 from t1;
select y div cast(-1 as int) from t1;
select z div cast(-1 as short) from t1;

deallocate prepare stmt;

drop t1;
