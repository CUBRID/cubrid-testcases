--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin','jianye',32,'m');

CREATE  FUNCTION test_int1(i number) RETURN number
as language java name 'SpTest.testInt(int) return int';

--TEST Create failed
CREATE INDEX my_idx ON t1(Sp_int(Age));
drop table t1 ;

drop FUNCTION test_int1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
