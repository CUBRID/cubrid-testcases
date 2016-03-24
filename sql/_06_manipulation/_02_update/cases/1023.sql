--Test update super class with all and except
create class t1 (name varchar(20), age integer);
create class sub_t1 as subclass of t1(gender char(1));
create class sub_t2 as subclass of t1(gender char(1));

insert into t1 values('Jerry', 25);
insert into t1 values('Tom', 26);
insert into t1 values('Kitty', 27);
insert into t1 values('Cat', 23);


insert into sub_t1 values('Kitty', 26, 'f');
insert into sub_t1 values('Moon', 27, 'm');
insert into sub_t1 values('Star', 22, 'f');
insert into sub_t1 values('K', 21, 'f');
insert into sub_t2 values('Kitty', 26, 'f');
insert into sub_t2 values('Moon', 27, 'm');
insert into sub_t2 values('Star', 22, 'f');
insert into sub_t2 values('K', 21, 'f');



update all t1 (except sub_t2) set name = 'Jenny' where name = 'Kitty';
select * from t1 order by 2;
select * from sub_t1 order by 2;
select * from sub_t2 order by 2;

drop class t1;
drop class sub_t1;
drop class sub_t2;