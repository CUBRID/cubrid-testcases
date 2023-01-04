-- This test case verifies CBRD-24598 issue.
-- Core occures because of not freed memory.
-- Core occures in second execution query on all after 10.x version.
-- Core does not occures in 9.x version.
-- Allocated memory on the global heap must be freed on the global heap.
-- After error fix both query should be executed normaly.

drop table if exists t;

-- prepare required 
prepare q from 'select decode (?, '''', c, NULL, c, -1) from table ({1}) as t (c)'; 

-- temporary it will occure error.
-- ERROR: Cannot coerce value of domain "character" to domain "double".
execute q using 'A'; 

-- success
execute q using 1; 

drop prepare q;
