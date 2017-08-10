drop table if exists test_connect_by;
create table test_connect_by (
parent int,
child  int primary key
);
insert into test_connect_by values ( 5, 2);
insert into test_connect_by values ( 5, 3);

insert into test_connect_by values (18,11);
insert into test_connect_by values (18, 7);

insert into test_connect_by values (17, 9);
insert into test_connect_by values (17, 8);

insert into test_connect_by values (26,13);
insert into test_connect_by values (26, 1);
insert into test_connect_by values (26,12);


insert into test_connect_by values (15,10);
insert into test_connect_by values (15, 5);

insert into test_connect_by values (38,15);
insert into test_connect_by values (38,17);
insert into test_connect_by values (38, 6);

--38, 26 and 18 have no parents (the parent is null)
insert into test_connect_by values (null, 38);
insert into test_connect_by values (null, 26);
insert into test_connect_by values (null, 18);


select lpad(' ',2*(level-1)) || to_char(child) s
from test_connect_by
start with parent is null
connect by prior child = parent;

drop table if exists test_connect_by;