-- This test case verifies CBRD-24598 issue.
-- Core occures because of not freed memory.
-- Core occures in second execution query on all after 10.x version.
-- Core does not occures in 9.x version.
-- Allocated memory on the global heap must be freed on the global heap.
-- After error fix both query should be executed normaly.

-- prepare required 
prepare q from 'select decode (?, '''', c, NULL, c, -1) from table ({1}) as t (c)'; 

-- success
execute q using 'A'; 

-- success
execute q using 1; 

-- develop failed here with -181: the previous execution's INT bind had converted the cached literal '' in place.
-- CBRD-27510 converts a constant into a value of its own per execution, so the literal stays as it is.
execute q using 'A'; 

-- prepare required 
prepare p from 'select decode (?, '''', c, NULL, c, ''Z'') from table ({''X''}) as t (c)';

-- success
execute p using 1;

-- develop failed here with -181 for the same reason.
execute p using 'A';

-- success
execute p using 1;


drop prepare q;
drop prepare p;
