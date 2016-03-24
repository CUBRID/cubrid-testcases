--Test subquery in update statment
create class t1(name varchar(20), price float(2));

insert into t1 values('English', 21);
insert into t1 values('Chinese', 22);
insert into t1 values('Math', 23);
insert into t1 values('CS', 21);
insert into t1 values('Bio', 22);


update t1 set price = 25.1
where  price = (select price from t1 where name = 'Bio');
select * from t1 order by 1,2;

drop class t1;
