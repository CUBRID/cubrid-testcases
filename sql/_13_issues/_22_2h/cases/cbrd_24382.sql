-- This case verifies segmentation fault while executing CALL with built-in function.
-- To reproduce the case test 'TO_DATE', 'DISK_SIZE' function.
-- result must show -493 error 

--err case
CALL TO_DATE('12/25/2008');
CALL DISK_SIZE('abc');
