
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t2;
C1: create table t2(class_id bigint, class_name varchar(10),stu_id int);
C1: insert into t2 values(1,'math',4),(1,'math',8),(2,'english',1),(2,'english',4),(3,'history',1),(3,'history',8),(4,'art',-8),(5,'aaaaa',-9);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t2 set stu_id=-16 where class_name='history' and stu_id=8;
MC: wait until C1 ready;
C2: create index idx_t2_3 on t2(class_id,class_name,stu_id) where stu_id>0  with online parallel 5;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: show indexes from t2;
C2: commit;
MC: wait until C2 ready;
C1: select /*+ recompile */ class_id,class_name,stu_id  from t2 where stu_id>0 using index idx_t2_3(+);
C1: commit work;
MC: wait until C1 ready;
C2: commit;

C2: quit;
C1: quit;
