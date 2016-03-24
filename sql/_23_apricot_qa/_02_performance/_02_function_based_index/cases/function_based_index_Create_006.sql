--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create failed
CREATE INDEX my_idx ON t1 ( TRIM(FirstName), LastName, LEFT(gender, 5) );
--TEST Create failed
CREATE INDEX my_idx ON t1 ( TRIM(FirstName), 1=1);
--TEST Create failed
CREATE INDEX my_idx ON t1 ( 1=1,TRIM(FirstName));
--TEST Create failed
CREATE INDEX my_idx ON t1 ( null,TRIM(FirstName));
--TEST Create failed
CREATE INDEX my_idx ON t1 ( 1,TRIM(FirstName));
drop table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
