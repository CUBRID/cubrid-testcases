-- These tests attempt to check the nested loop join and in particular the correctness of the sc_next_scan_blocks() routine.  The order of the heap file is important.  We are trying to get a qualified tuple on the outer scan (accommodations) in the first block, a middle block, and the last block of the heap file.  If the order of the heap file changes this test should also change.

autocommit off;
select h
from all accommodations, (select serving_hours from dinner) as t(h)
where name = 'Couples';
select h
from all accommodations, (select serving_hours from dinner) as t(h)
where name = 'British Colonial Beach Resort';
select h
from all accommodations, (select serving_hours from dinner) as t(h)
where name = 'Seawind Beach Resort';
rollback;
