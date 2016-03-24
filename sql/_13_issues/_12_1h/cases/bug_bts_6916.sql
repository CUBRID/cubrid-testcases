create table t1(i int primary key);
insert into t1 values(1);
create table t2(i int,j int) partition by hash(i) partitions 4;
insert into t2 values(2,2);
alter table t2 add constraint foreign key t2(i) references t1(i);
drop t2,t1;

create table t1 (id int not null auto_increment, parent_id int default 1, primary key (id,parent_id));
create table t2(id int auto_increment,i int,j int);
alter table t1 partition by hash (id) partitions 2;
alter table t2 partition by hash (id) partitions 4;
insert into t1 values(NULL,1),(NULL,2),(NULL,2);
insert into t2 values(NULL,NULL,1);
alter table t2 add constraint test_ibfk_1 foreign key (id,i) references t1 (id,parent_id);
drop t2,t1;

create table t1(t timestamp primary key);
create table t2(t timestamp,i int);
insert into t1 values(now());
insert into t2 values(NULL,0),((select t from t1),1),((select t from t1),2);
alter table t1 partition by hash (t) partitions 2;
alter table t2 partition by hash (t) partitions 4;
alter table t2 add constraint test_ibfk_1 foreign key (t) references t1 (t);
drop t2,t1;

create table t1(i int primary key);
insert into t1 values(1);
create table t2(i int,j int) partition by hash(i) partitions 4;
insert into t2 values(2,2);
alter table t2 add constraint foreign key t2(i) references t1(i) on delete cascade;
update t2 set i=1;
alter table t2 add constraint foreign key t2(i) references t1(i) on delete cascade;
delete from t1;
select * from t2;

drop t2,t1;
