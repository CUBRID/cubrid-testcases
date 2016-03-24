create table t1(id int not null, treeid int, age int, text varchar(32));

insert into t1 values(3,1,0, 'BAA');
insert into t1 values(8,null,0, 'C');
insert into t1 values(5,2,0, 'CBA');
insert into t1 values(2,null,null, 'A');
insert into t1 values(1,null,0, null);
insert into t1 values(4,1,0,'AB');
insert into t1 values(7,6,0, 'CBBA');
insert into t1 values(6,2,0, 'DBB');

create index idx1 on t1(id);
create index idx2 on t1(treeid);
create index idx3 on t1(text);
create index idx4 on t1(id, text);

select treeid from t1 where treeid is null order by treeid;
select treeid from t1 where id > treeid order by treeid;
select treeid from t1 where treeid - 1 > 0 order by treeid;
select treeid from t1 where id > 0 or treeid < 100 and id < 10 or text > 'A' order by treeid;
select treeid from t1 where id > treeid or text < 'C' order by treeid;

drop table t1;

