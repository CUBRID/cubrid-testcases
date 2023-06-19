
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t2;
C1: drop table if exists t1;
C1: create table t1(stu_id int primary key, stu_name varchar(30));
C1: insert into t1 values(1,'james'),(4,'mikey'),(8,'lucy'),(-8,'un');
C1: create table t2(class_id bigint, class_name varchar(10),stu_id int, constraint foreign key(stu_id) references t1(stu_id));
C1: insert into t2 values(1,'math',4),(1,'math',8),(2,'english',1),(2,'english',4),(3,'history',1),(3,'history',8),(4,'art',-8);
C1: alter table t2 add column birty_date datetime default '2000-01-01 00:00:00';
C1: update statistics on t2;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values(-16,'bob');
C1: update t2 set stu_id=-16 where class_name='history' and stu_id=8;
MC: wait until C1 ready;
C2: create index idx3 on t2(ADD_MONTHS(birty_date,1)) with online parallel 2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: update statistics on t2;
C2: show indexes from t2;
C2: commit;
MC: wait until C2 ready;
C1: select /*+ recompile */ * from t2 where ADD_MONTHS(birty_date,1)='2000-02-01' using index idx3(+)  ;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;
