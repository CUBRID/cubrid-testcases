--Test subseteq on collection type
create class t1(c1 set int, c2 set varchar(10));

insert into t1 values({101,102},{'aaa','bbb','c','aa'});
insert into t1 values({101,202},{'ddd','bbb','c'});
insert into t1 values({101,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402},{'eee','bbb','c'});
insert into t1 values({101,102},{'aaa','bbb','c','aa'});
insert into t1 values({102,101},{'ddd','bbb','c'});
insert into t1 values({101,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402},{'eee','bbb','c'});

select * from t1 where c1 subseteq {101,102,103} and 'ddd' in c2 order by 1,2;
select * from t1 where c1 subseteq {401,402} order by 1,2;
select * from t1 where c1 subseteq {401,402,403} order by 1,2;
select * from t1 where c2 subseteq {'aaa','bbb','c','aa'} order by 1,2;
select * from t1 where c2 subseteq {'aaa','bbb','c','xxxx'} order by 1,2;

drop class t1;
