drop table if exists t1;
create table t1(a int, b date, c nchar, d enum('red','yellow','blue','green'));
insert into t1 values(1,'2013-1-2',n'h',1);
insert into t1 values(1,'2013-1-2',n'hello',1);
insert into t1 values(2,'2013-12-2',n'Welcome',2);
insert into t1 values(2,'2013-10-12',n'welcome',2); 
insert into t1 values(2,'2013-10-12',n'welcome',3);

select a, max(b) from t1 group by d order by 1,2;
select a, max(b) - min(b) from t1 group by c, d order by 1,2;
select a, max(b) from t1 group by d having min(b)>'2013-1-4' order by 1,2;
select a, max(b) from (select a, b from t1 where d>1 order by a, b) group by a, b order by 1,2;
select a, max(b) from (select a, b from t1 where d>1 order by a, b) group by b order by 1,2;
select a, count(c) from t1 group by b order by 1,2;



select /*+ no_hash_aggregation */ a, max(b) from t1 group by d order by 1,2;
select /*+ no_hash_aggregation */ a, max(b) - min(b) from t1 group by c, d order by 1,2;
select /*+ no_hash_aggregation */ a, max(b) from t1 group by d having min(b)>'2013-1-4' order by 1,2;
select /*+ no_hash_aggregation */ a, max(b) from (select a, b from t1 where d>1 order by a, b) group by a, b order by 1,2;
select /*+ no_hash_aggregation */ a, max(b) from (select a, b from t1 where d>1 order by a, b) group by b order by 1,2;
select /*+ no_hash_aggregation */ a, count(c) from t1 group by b order by 1,2;


drop table t1;


drop table if exists t4;
create table t4(id bigint, a set(char(100)), b MULTISET(char(10)), c list(string), d SEQUENCE(float));
insert into t4 values(112,{'ab','dfffffffffffffffff', '211'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'1'});
insert into t4 values(999912,{'ac','dfffffffffffffffff', '211'}, {'11999','2012-1-1','fff'}, {'fb','cd'}, {NULL});
insert into t4 values(1212,{'af','dfffffffffffffffff', '231'}, {'11999','2010-1-1','fff'}, {'fb','cd'}, {'2'});
insert into t4 values(881,{'abd','dfffffffffffffffff', '241'}, {'11999','2009-1-1','fff'}, {'fb','cd'}, {'4'});
insert into t4 values(10086,{'a6b','dfffffffffffffffff', '261'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'6'});
insert into t4 values(10110,{'abf','dfffffffffffffffff', '291'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'7'});
insert into t4 values(10110,{'ab','dfffffffffffffffff', '2112'}, {'11999','2013-1-1','fff'}, {'fb','cd'}, {'a'});

select group_concat(id order by id), max(id) from t4 group by a order by 1,2;
select group_concat(id order by id), max(id) from t4 group by b order by 1,2;
select group_concat(id order by id), max(id) from t4 group by c order by 1,2;
select group_concat(id order by id), max(id) from t4 group by d order by 1,2;
select group_concat(id order by id), max(id) from t4 group by a,b,c,d order by 1,2;
select group_concat(id order by id), max(id) from t4 group by b ASC order by 1,2;
select group_concat(id order by id), max(id) from t4 group by b DESC order by 1,2;
select group_concat(id order by id), max(id) from t4 group by b with rollup order by 1,2;
select group_concat(id order by id), sum(id), avg(id), sum(id)/avg(id) from t4 group by a,b,c,d order by 1,2;

select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by a order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by b order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by c order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by d order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by a,b,c,d order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by b ASC order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by b DESC order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), max(id) from t4 group by b with rollup order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id), avg(id), sum(id)/avg(id) from t4 group by a,b,c,d order by 1,2;

drop table t4;


create table t5(id bigint, a char(100), b char(1000), c char(20000), d varchar);

insert into t5 values(199999, 'Welcome to use CUBRID for 9.3', 'For more details please refer to manual', 'Topic Quick Reference Table', 'The contefnts of the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(1, 'Welcome to use CUBRID for 8.4', 'For more details please refer to manuarl', 'Topic Quick Reference Table', 'The contents oaf the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(2999, 'Welcome to use CUBRID for 8.3', 'For more details please refer to manural', 'Topic Quick Reference Table', 'The contentsa of the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(999999, 'Welcome to use CUBRID for 1.2', 'For more details please refer to mranual', 'Topic Quick Reference Table', 'The contentas of the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(39999, 'Welcome to use CUBRID for 10.0', 'For more details please refer to rmanual', 'Topic Quick Reference Table', 'The contentsa of the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(198899, 'Welcome to use CUBRID for 9.2', 'For more details please refer tor manual', 'Topic Quick Reference Table', 'The contents fof the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(989999, 'Welcome to use CUBRID for 3.2', 'For more details please refer two manual', 'Topic Quick Reference Table', 'The contents obf the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(2, 'Welcome to use CUBRID', 'For more details please refer to manual', 'wTopic Quick Reference Table', 'The contents of the CUBRID Dhatabase Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(100, 'Welcome to use CUBRID for abc', 'For more details please refer tow manual', 'Topic Quick Reference Table', 'The contents of thef CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(19122, 'Welcome to use CUBRID for 123', 'For more details please referr to manual', 'Topic Quick Reference Table', 'The contents of thte CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(0, 'Welcome to use CUBRID for ppd', 'For more details please refer tof manual', 'Topic Quick Reference Table', 'The contents of the CUBfRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(-19999, 'Welcome to use CUBRID for disucussion', 'For more details palease refer to manual', 'Topic Quick Reference Table', 'The contentqs of the CUBRID Database Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(-133333, 'Welcome to use CUBRID', 'For more details please refer tof manual', 'Topic Quick Reference Table', 'The contents of the CUBRID rDatabase Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 values(799, 'Welcome to use CUBRIDff', 'For more details please refer to fmanual', 'Topic Quick Reference Table', 'The contents of the CUBRID Datiabase Management System (CUBRID DBMS) product manual are as follows:');
insert into t5 select * from t5;

select group_concat(id order by id), sum(id) from t5 where id <> 0 group by a order by 1,2;
select group_concat(id order by id), sum(id) from t5 where id <> 0 group by b order by 1,2;
select group_concat(id order by id), sum(id) from t5 where id <> 0 group by c order by 1,2;
select group_concat(id order by id), sum(id) from t5 where id <> 0 group by d order by 1,2;
select group_concat(id order by id), sum(id) from t5 where id <> 0 group by a, b order by 1,2;
select group_concat(id order by id), sum(id) from t5 where id <> 0 group by a, c order by 1,2;
select group_concat(id order by id), sum(id) from t5 where id <> 0 group by a, d order by 1,2;

select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by a order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by b order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by c order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by d order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by a, b order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by a, c order by 1,2;
select /*+ no_hash_aggregation */ group_concat(id order by id), sum(id) from t5 where id <> 0 group by a, d order by 1,2;

drop table t5;










