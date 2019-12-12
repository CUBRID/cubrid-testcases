-- misc tests : tests without order by

create table tab1 (name char varying, i1 integer);
insert into tab1 values('three',3);
insert into tab1 values('three',3);
insert into tab1 values('three',3);
insert into tab1 values('four',4);
insert into tab1 values('four',4);
insert into tab1 values('four',4);
insert into tab1 values('four',4);
insert into tab1 values('two',2);
insert into tab1 values('two',2);
insert into tab1 values('one',1);
insert into tab1 values('five',5);
insert into tab1 values('five',5);
insert into tab1 values('five',5);
insert into tab1 values('five',5);
insert into tab1 values('five',5);

select group_concat(name) from tab1 group by i1;

select group_concat(name separator '+') from tab1 group by i1;

select group_concat(i1) from tab1 group by name;

select group_concat(i1 separator '+') from tab1 group by name;


drop table tab1;

