create table t1(id   INTEGER NOT NULL, code CHARACTER VARYING(22) NOT NULL) partition by hash(id) partitions 3;
insert into t1 values(82,'SO51700');
insert into t1 values(281,'\tabcabc\t\t');
insert into t1 values(281,'_...comd899');
insert into t1 values(281,'$$dfjd$');
insert into t1 values(281,'$12.3');
insert into t1 values(281,'ff$9');
insert into t1 values(532,'_ Word _');
insert into t1 values(532,'word _df');
insert into t1 values(532,'');
insert into t1 values(532,'aabc');
insert into t1 values(532,'?aabababc_');
insert into t1 values(532,'~_~');
insert into t1 values(532,'~\t');

create table t2(id INTEGER primary key NOT NULL, code  CHARACTER VARYING(30));
insert into t2 values(532,'[[:alnum:]]');
insert into t2 values(481,'[[.tab.]]$');
insert into t2 values(376,'^[^a-z0-9].*[0-9]$');
insert into t2 values(257,'[0-9|A-Z]+$');
insert into t2 values(255,'[[:<:]]Word[[:>:]]');
insert into t2 values(82,'(abc)+');

select * from t1 f,t2 d where f.code regexp d.code order by 1,2,3,4;
select * from t1 f left join t2 d on not f.code not regexp d.code order by 1,2,3,4;
select * from t1 f right join t2 d on not f.code not regexp d.code order by 1,2,3,4;

create serial s start with 0 increment by 1;

select (s.next_value rlike '[0-9]');

select (s.next_value rlike '[0-9]a');

select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');
select (s.next_value rlike '^[0-9]$');

select (s.next_value rlike '^[0-9]$');

drop serial s;
drop table t1;
drop table t2;
