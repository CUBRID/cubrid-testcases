set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
--the test point need 'autocommit off' environment

autocommit off;
drop table if exists tb1,foo,tree2;
create class tb1(
        id int primary key,
        address varchar(100)
);
insert into tb1 (id, address) values(1, 'beijing');
select tb1 into oid1 from tb1 where id = 1;
drop variable oid1;
drop class tb1;
commit;

create table foo (a int ,id int);
insert into foo values (1, 1);
update foo set id=oid1 where a=1;

drop table if exists tb1,tree2;
create class tb1(
        id int primary key,
        address varchar(100)
);
insert into tb1 (id, address) values(1, 'beijing');
select tb1 into a from tb1 where id = 1;
drop variable a;
drop class tb1;
commit;

CREATE TABLE tree2(ID INT, ParentID INT);
insert into tree2 (a, id, parentid) values (1, null, null);
drop table if exists tb1,foo,tree2;
commit;
autocommit on;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
