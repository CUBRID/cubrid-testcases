create table t1( id int auto_increment not null , c char(1) not null, counter int not null default 1, primary key (id), unique key (c) ) ;
insert into t1 (id, c) values (NULL, 'a'), (NULL, 'a') on duplicate key update id = null, counter = counter + 1;
drop t1;

create table t1(id int primary key);
insert into t1 values(NULL);
drop t1;

create table t0(id int primary key);
create table t1(id int primary key);
alter table t1 add constraint foreign key t1(id) references t0(id) on update set null;
insert into t0 values(1),(2),(3);
insert into t1 values(1),(2),(3);
update t0 set id=33 where id=3;

drop t1;
drop t0;

create table t1(id int primary key) partition by hash(id) partitions 3;
create table temp (i int);
insert into temp values(NULL);
insert into t1 select * from temp;

drop t1;
drop temp;

create table t1(id int primary key,j int) partition by hash(id) partitions 3;
insert into t1 values(1,NULL);
update t1 set id=j;
drop t1;