--Test seteq with subquery with set
create class t1(c1 set int, c2 set varchar(10));
create class t2(c1 int, c2 int);

insert into t2 values(101,102);
insert into t2 values(201,202);
insert into t2 values(301,302);

insert into t1 values({101,102},{'aaa','bbb','c'});
insert into t1 values({201,202},{'ddd','bbb','c'});
insert into t1 values({301,302},{'ccc','bbb','c'});
insert into t1 values({401,402},{'eee','bbb','c'});

select * from t1 where c1 seteq set(select * from t2
                                     where c1=101);


drop class t1;
drop class t2;