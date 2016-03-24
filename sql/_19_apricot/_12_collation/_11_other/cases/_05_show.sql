
create table t1 (s1 string collate utf8_en_ci,
				 s2 char(20) collate utf8_en_cs, 
				 s3 national char(10) collate iso88591_en_cs,
				 s4 national char varying (10) collate utf8_tr_cs);

desc t1;

show columns in t1;

show full columns in t1;

show full columns in t1 LIKE 's%';

show full columns in t1 WHERE Field = 's1';

-- error : need 'FULL'
show columns in t1 WHERE "Collation" like 'utf8%';

show full columns in t1 WHERE "Collation" like 'utf8%';

drop table t1;
