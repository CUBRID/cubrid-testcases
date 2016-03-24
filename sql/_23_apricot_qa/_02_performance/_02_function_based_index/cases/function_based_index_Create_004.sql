--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create failed
CREATE INDEX my_idx ON t1 (lower(LEFT(FirstName, 3)));
--TEST Create failed
CREATE INDEX my_idx ON t1 (LEFT(FirstName, LastName + 3));
--TEST Create failed
CREATE REVERSE INDEX my_idx ON t1 (lower(LEFT(FirstName, 3)));
--TEST Create failed
CREATE UNIQUE INDEX my_idx ON t1 (lower(LEFT(FirstName, 3)));
--TEST Create failed
CREATE REVERSE UNIQUE INDEX my_idx ON t1 (LEFT(FirstName, LastName + 3));
drop table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
