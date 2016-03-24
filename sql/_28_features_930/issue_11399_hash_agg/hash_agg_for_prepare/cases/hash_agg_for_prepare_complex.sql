drop table if exists t2;

create table t2(i bigint, b float, c monetary, d numeric);

insert into t2 values(111999,98.1, $12.3, 16223);
insert into t2 values(122999,298.1, 22.3, 17223);
insert into t2 values(133999,398.1, 12.3, 18223);
insert into t2 values(144999,498.1, $3312.3, 19223);
insert into t2 values(155999,98.1, $12.3, 10223);
insert into t2 values(166999,398.1f, $12.3, 12223);
insert into t2 values(177999,498.1, $1555.3, 12223);
insert into t2 values(188999,598.1, $133.3, 12223);
insert into t2 values(199999,698.1, $122.3, 12223);
insert into t2 values(110999,798.1, $14.3, 12223);

prepare x1 from 'select max(i), sum(b), avg(c) from t2 group by d';
execute x1;
deallocate prepare x1;

prepare x2 from 'select max(i), sum(b), avg(c) from t2 group by d having avg(c)>?';
execute x2 using 15;
execute x2 using $100;
execute x2 using '99.99f'
deallocate prepare x2;

drop table t2;

drop table if exists t3;
create table t3(id bigint, b date, c varchar, d enum('yes','no'));
insert into t3 values(11222, '2013-9-9', 'prepare', 1);
insert into t3 values(12222, '2003-9-9', 'hash data', 2);
insert into t3 values(13222, '2013-9-9', 'welcome to bj', 1);
insert into t3 values(1122200, '2012-9-9', 'cubrid test', 2);
insert into t3 values(1122200, '2010-9-9', 'cubrid test', 2);
insert into t3 values(1999222, '2011-1-19', 'hash aggregation', 1);
insert into t3 values(1999222, '2009-1-19', 'hash aggregation', 1);
insert into t3 values(1999222, '2013-9-9', 'prepare', 1);
insert into t3 values(1222, '2013-4-9', 'prepar statement', 1);
insert into t3 values(11222, '2013-9-9', 'prepare', 1);

prepare b1 from 'select id, max(b) from t3 group by d';
execute b1;

prepare b2 from 'select id, max(b)-min(b) from t3 group by c, d having min(d)>?';
execute b2 using 1;
execute b2 using 'yes';
execute b2 using 'no';

prepare b3 from 'select id, avg(id), max(b) from (select id, b, c, d from t3 where b>?) group by d';
execute b3 using '2010-2-1';
execute b3 using '0001-1-1';

deallocate prepare b1;
deallocate prepare b2;
deallocate prepare b3;

drop table t3;


drop table if exists t4;
create table t4(id bigint, a set(char(100)), b MULTISET(char(10)), c list(string), d SEQUENCE(float));
insert into t4 values(112,{'ab','dfffffffffffffffff', '211'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'1'});
insert into t4 values(999912,{'ac','dfffffffffffffffff', '211'}, {'11999','2012-1-1','fff'}, {'fb','cd'}, {NULL});
insert into t4 values(1212,{'af','dfffffffffffffffff', '231'}, {'11999','2010-1-1','fff'}, {'fb','cd'}, {'2'});
insert into t4 values(881,{'abd','dfffffffffffffffff', '241'}, {'11999','2009-1-1','fff'}, {'fb','cd'}, {'4'});
insert into t4 values(10086,{'a6b','dfffffffffffffffff', '261'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'6'});
insert into t4 values(10110,{'abf','dfffffffffffffffff', '291'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'7'});
insert into t4 values(10110,{'ab','dfffffffffffffffff', '2112'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'a'});

prepare s4 from 'select id, max(id) from t4 group by a ASC;';
execute s4;
execute s4 using 1;

prepare s5 from 'select id, max(?) from t4 group by b;';
execute s5 using 1;


prepare s6 from 'select id, sum(a) from t4 where (select sum(a) from t4) is not null group by b having count(b)>?';
execute s6 using 1;

prepare s6 from 'select id, sum(a) from t4 where (select sum(a) from t4) is not null group by c having count(b)>?';
execute s6 using 1;

prepare s6 from 'select id, sum(a) from t4 where (select sum(a) from t4) is not null group by d having count(b)>?';
execute s6 using 1;

deallocate prepare s4;
deallocate prepare s5;
deallocate prepare s6;

drop table t4;

















