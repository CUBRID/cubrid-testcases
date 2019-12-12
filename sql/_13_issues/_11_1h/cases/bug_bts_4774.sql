create table init_a (a int auto_increment);
insert into init_a values(NULL);
select last_insert_id();
create table aaa (a int);
insert into aaa values (-1);
select last_insert_id();
create serial aa;
insert into aaa values (aa.next_value);
select last_insert_id();

drop table init_a;
drop table aaa;
drop serial aa;

