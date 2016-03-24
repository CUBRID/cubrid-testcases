--Test update class attribute in subclass
create class t1
class attribute(author varchar(20))
(name varchar(20), age integer);
create class sub_t1 as subclass of t1(gender char(1));

insert into t1 values('Jerry', 25);
insert into t1 values('Tom', 26);
insert into t1 values('Kitty', 27);
insert into t1 values('Cat', 23);


insert into sub_t1 values('Sun', 26, 'f');
insert into sub_t1 values('Moon', 27, 'm');
insert into sub_t1 values('Star', 22, 'f');
insert into sub_t1 values('K', 21, 'f');

update class sub_t1 set author = 'NHN';
drop class sub_t1;
drop class t1;
