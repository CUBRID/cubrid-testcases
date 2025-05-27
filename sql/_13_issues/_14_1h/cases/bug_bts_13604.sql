drop table if exists t1;

CREATE TABLE t1(
       col1 character varying(255) NOT NULL
) COLLATE utf8_bin;

prepare s from 'select * from t1 A, (SELECT ? AS col1 FROM DB_ROOT) B where A.col1=B.col1';
deallocate prepare s;

prepare s from 'insert into t1 SELECT ? AS col1 FROM DB_ROOT';
deallocate prepare s;

prepare s from 'delete from t1 A where A.col1 = (SELECT ? AS col1 FROM DB_ROOT)';
deallocate prepare s;

prepare s from 'MERGE INTO t1 A  USING (SELECT ? AS col1 FROM DB_ROOT ) B  ON  A.col1 = B.col1  WHEN MATCHED THEN   UPDATE  SET A.col1 = b.col1  WHEN NOT MATCHED THEN          INSERT VALUES ( b.col1 )';
deallocate prepare s;

drop table if exists t1;
