--test subset on collection type:set
create class t1(c1 set int, c2 set varchar(10));

insert into t1 values({101,102},{'aaa','bbb','c','aa'});
insert into t1 values({101,202},{'ddd','bbb','c'});
insert into t1 values({101,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402},{'eee','bbb','c'});
insert into t1 values({101,102},{'aaa','bbb','c','aa'});
insert into t1 values({102,101},{'ddd','bbb','c'});
insert into t1 values({101,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402},{'eee','bbb','c'});

select * from t1 where c1 subset {101,102,103} and 'aa' in c2 order by 1,2;
select * from t1 where c1 subset {401,402};
select * from t1 where c1 subset {401,402,403} order by 1,2;
select * from t1 where c2 subset {'aaa','bbb','c','aa'};
select * from t1 where c2 subset {'aaa','bbb','c','xxxx'};


drop class t1;