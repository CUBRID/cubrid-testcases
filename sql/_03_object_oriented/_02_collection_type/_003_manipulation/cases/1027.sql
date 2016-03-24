--Test seteq on set and list
create class t1(c1 list int, c2 set varchar(10));

insert into t1 values({101,102},{'aaa','bbb','c'});
insert into t1 values({201,202},{'ddd','bbb','c'});
insert into t1 values({301,302},{'ccc','bbb','c'});
insert into t1 values({401,402},{'eee','bbb','c'});

select * from t1 where c1 seteq {101,102};
select * from t1 where c1 seteq {102,101};

drop class t1;