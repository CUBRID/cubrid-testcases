--Test superseteq on null, set, multiset, {}

create class t1(c1 set int, c2 multiset varchar(10));

insert into t1 values({101,102},{'aaa','bbb','c','aa'});
insert into t1 values({101,202},{'ddd','bbb','c','bbb'});
insert into t1 values({101,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402},{'eee','bbb','c','eee'});

select * from t1 where c1 superseteq {} order by 1,2;

select * from t1 where c1 superseteq null;

select * from t1 where c2 superseteq {} order by 1,2;

select * from t1 where c2 superseteq null;

drop class t1;