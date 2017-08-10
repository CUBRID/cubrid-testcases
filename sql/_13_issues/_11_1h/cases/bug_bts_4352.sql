drop table if exists t1;


 CREATE CLASS t1 (
       id character varying(20) NOT NULL,
       id2 smallint NOT NULL,
       test_no smallint NOT NULL,
       s smallint NOT NULL
);

ALTER CLASS t1 ADD ATTRIBUTE
       CONSTRAINT [ipk_t1] PRIMARY KEY(id, id2);


INSERT INTO t1
  VALUES (
   'tsyeun',
   299,
   1,
   (SELECT IFNULL(MAX(s),0) + 1 FROM t1 WHERE id = 'tsyeun')
  )
ON DUPLICATE KEY UPDATE
   test_no = 1;


select * from t1;

drop table t1;


