--[er]Test superset with constant list on list 
create class t1(c1 list int, c2 list varchar(10));

insert into t1 values({101,102,101},{'aaa','bbb','c','aa'});
insert into t1 values({101,202,202},{'ddd','bbb','c','bbb'});
insert into t1 values({101,302,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402,101},{'eee','bbb','c','eee'});
insert into t1 values({101,102,101},{'aaa','bbb','c','aa'});
insert into t1 values({102,101,202},{'ddd','bbb','c','bbb'});
insert into t1 values({101,302,302},{'ccc','bbb','c','ddd'});
insert into t1 values({401,402,101},{'eee','bbb','c','eee'});

select * from t1 where c1 superset {101,102};
select * from t1 where c1 superset {101,102};

drop class t1;