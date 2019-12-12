drop table if exists t1,t2,t3;
create table t1 (id int not null auto_increment, parent_id int default null, primary key (id), key parent_id (parent_id));
create table t2 (id int , primary key (id));
insert into t1 values(NULL,1),(NULL,NULL),(NULL,2);
insert into t2 values(1),(3),(2);
alter table t1 partition by hash (id) partitions 1;
alter table t1 add constraint test_ibfk_1 foreign key (parent_id) references t2 (id);
alter table t2 partition by hash (id) partitions 2;
alter table t2 add constraint test_ibfk_1 foreign key (id) references t2 (id);

drop table t1, t2;

create table t1 (id int not null auto_increment, parent_id int default 1, primary key (id,parent_id));
create table t2 (id int , primary key (id));
create table t3(id int auto_increment,i int,j int);
alter table t1 partition by hash (id) partitions 1;
alter table t2 partition by hash (id) partitions 2;

alter table t1 add constraint test_ibfk_1 foreign key (parent_id) references t2 (id);
alter table t3 add constraint test_ibfk_1 foreign key (id,i) references t1 (id,parent_id);

insert into t2 values(1),(2),(3);
insert into t1 values(NULL,1),(NULL,NULL),(NULL,2);
insert into t1 values(NULL,1),(NULL,2),(NULL,2);
insert into t3 values(1,1,1),(2,NULL,2),(3,NULL,3);

drop t3,t1,t2;









