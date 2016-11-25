--[er]Test insert on subclass without enough values
create class t1 (name varchar(20), age integer);
create class sub_t1 as subclass of t1(gender char(1));

insert into t1 values('Jerry', 25);
insert into t1 values('Tom', 26);
insert into t1 values('Kitty', 27);
insert into t1 values('Cat', 23);


insert into sub_t1 values('Sun', 26);
insert into sub_t1 values('Moon', 27);
insert into sub_t1 values('Star', 22);
insert into sub_t1 values('K', 21);

select * from t1 order by 1,2;

select * from sub_t1 order by 1,2;

drop class t1;
drop class sub_t1;
