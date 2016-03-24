--Test seteq with multiset 
create class t1(c1 multiset int, c2 set varchar(10));

insert into t1 values({101,102,101},{'aaa','bbb','c'});
insert into t1 values({201,202,201},{'ddd','bbb','c'});
insert into t1 values({301,302,202},{'ccc','bbb','c'});
insert into t1 values({401,402,401},{'eee','bbb','c'});

select * from t1 where c1 seteq multiset{101,102,101};


drop class t1;