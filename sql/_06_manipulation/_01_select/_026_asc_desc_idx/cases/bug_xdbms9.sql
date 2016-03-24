--Test select on class with asc/desc index
create class xoo ( a int, b char(5), c varchar(5));
create index idx1 on xoo(a desc, b asc, c desc);

insert into xoo values(1, '9','8');
insert into xoo values(4, '8','8');
insert into xoo values(3, '7','8');
insert into xoo values(1, '2','8');
insert into xoo values(1, '4','7');
insert into xoo values(1, '4','3');
insert into xoo values(1, '4','1');
insert into xoo values(1, '4','7');
insert into xoo values(9, '2','8');
insert into xoo values(7, '2','9');
insert into xoo values(2, '3','8');
insert into xoo values(5, '5','0');
insert into xoo values(6, '8','8');
insert into xoo values(8, '9','3');
insert into xoo values(8, '9','2');

select x.a, y.a from xoo y, xoo x where y.a > 4 and x.a > 4 and x.a = y.a order by 1;

drop class xoo;
