set system parameters 'create_table_reuseoid=no';
-- [er]insert clause using decr(n),reports error,decr(n) can be used at top select statement only

create class yoo ( a int, b int);
create class xoo ( a int, b int, c varchar(10), d yoo);
insert into xoo values(100, 1, '1', insert into yoo values(100,1));
insert into xoo values(200, 2, '2', insert into yoo values(200,2));
insert into xoo values(300, 3, '3', insert into yoo values(300,3));
insert into xoo values(400, 4, '4', insert into yoo values(400,4));
insert into xoo values(500, 5, '5', insert into yoo values(500,5));
insert into xoo values(600, 6, '6', insert into yoo values(600,6));
insert into xoo values(700, 7, '7', insert into yoo values(700,7));
insert into xoo values(800, 8, '8', insert into yoo values(800,8));
insert into xoo values(900, 9, '9', insert into yoo values(900,9));
insert into xoo values(1000, 10, '10', insert into yoo values(1000,10));
insert into xoo values(1100, null, null, null);
create index idx1 on xoo(a);

insert into xoo select a,decr(b) , c, d from xoo where a = 500;

drop xoo;
drop yoo;
set system parameters 'create_table_reuseoid=yes';
