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

-- error : temporary
-- known bug
execute q using 'A'; 

-- prepare required 
prepare p from 'select decode (?, '''', c, NULL, c, ''Z'') from table ({''X''}) as t (c)';

-- error : temporary
-- known bug
execute p using 1;

-- success
execute p using 'A';

-- error : temporary
-- known bug
execute p using 1;


drop prepare q;
drop prepare p;
