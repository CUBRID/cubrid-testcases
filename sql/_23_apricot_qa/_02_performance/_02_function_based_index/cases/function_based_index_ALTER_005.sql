--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
--TEST Create successfully
CREATE unique INDEX first_name_lower ON t1 (LOWER(FirstName));
--TEST Alter successfully 
ALTER  unique INDEX first_name_lower ON t1 (LOWER(LastName)) REBUILD;
--TEST Insert failed
insert into t1 value('yin', 'jian ye',31,'M');
--TEST Insert failed 
insert into t1 value('yin', 'Jian Ye',31,'M');
--TEST Alter successfully 
drop unique index  first_name_lower ON t1 (LOWER(FirstName));
--TEST Insert successfully 
insert into t1 value('yin', 'Jian Ye',31,'M');
--TEST Alter failed 
ALTER table t1 add  INDEX first_name_lower (LOWER(LastName));
drop  table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
