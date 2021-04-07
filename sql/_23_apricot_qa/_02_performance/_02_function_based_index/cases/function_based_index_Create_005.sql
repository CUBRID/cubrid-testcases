--+ holdcas on;
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create failed
CREATE INDEX my_idx ON t1 ( lower(FirstName) ) WHERE FirstName < 'SQL';
--TEST Create failed
CREATE INDEX my_idx ON t1 ( lower(FirstName) ) WHERE 1=1;
--TEST Create failed
CREATE INDEX my_idx ON t1 (FirstName(FirstName)) WHERE 1=1;
--TEST Create successfully
CREATE INDEX my_idx ON t1 (FirstName) WHERE 1=1;
drop table t1 ;

commit;
--+ holdcas off;
