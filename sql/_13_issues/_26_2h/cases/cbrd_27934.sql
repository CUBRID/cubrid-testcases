/**
 *  This test case verifies CBRD-27934: SERIAL_NEXT_VALUE (s, n) judges a used-up cache block in the
 *  direction of the increment
 *
 *  A draw of several values from a cached serial decides whether it used up the block. The decision
 *  compared next_val >= last_cached_val whatever the sign of the increment, so a descending draw
 *  inside the block reserved another block on every call, a descending draw past the block end
 *  reserved nothing, and an ascending draw that ended at the block end reserved the next block. A
 *  cyclic serial whose draw wrapped kept the block end of the previous lap. Each case reads
 *  current_val of the serial row, the value a restart resumes from.
 *
 *  A non-cyclic serial whose values fit BIGINT draws on the lock-free count, which cbrd_27019
 *  checks. These cases take the path that keeps this decision: a cyclic serial, or values below the
 *  BIGINT range.
 *
 *  Coverage:
 *    Case 1:  descending CYCLE, a draw past the block end: the next block is reserved
 *    Case 2:  descending below BIGINT, a draw past the block end: the next block is reserved
 *    Case 3:  descending below BIGINT, three draws inside the block: no block is reserved
 *    Case 4:  ascending CYCLE, a draw that ends at the block end: no block is reserved
 *    Case 5:  ascending CYCLE, a draw that wraps to another increment lattice: the block end follows it
 *    Case 6:  ascending CYCLE, a draw that wraps on the same lattice: the block end follows it
 *    Case 7:  descending CYCLE, a draw that wraps (control)
 */

drop serial if exists s27934_1;
drop serial if exists s27934_2;
drop serial if exists s27934_3;
drop serial if exists s27934_4;
drop serial if exists s27934_5;
drop serial if exists s27934_6;
drop serial if exists s27934_7;

evaluate 'Case 1: descending CYCLE CACHE 10, n = 1 then n = 15; result = current_val -30';
create serial s27934_1 start with -1 increment by -1 minvalue -1000 maxvalue -1 cache 10 cycle;
select serial_next_value (s27934_1, 1) from db_root;
select serial_next_value (s27934_1, 15) from db_root;
select current_val from db_serial where name = 's27934_1';

evaluate 'Case 2: descending below BIGINT CACHE 10, n = 1 then n = 15; result = current_val -9223372036854775839';
create serial s27934_2 start with -9223372036854775810 increment by -1 maxvalue -9223372036854775810 minvalue -99999999999999999999 cache 10;
select serial_next_value (s27934_2, 1) from db_root;
select serial_next_value (s27934_2, 15) from db_root;
select current_val from db_serial where name = 's27934_2';

evaluate 'Case 3: descending below BIGINT CACHE 1000, n = 3 three times inside the block; result = current_val -9223372036854778807 each time';
create serial s27934_3 start with -9223372036854775810 increment by -3 maxvalue -9223372036854775810 minvalue -99999999999999999999 cache 1000;
select s27934_3.next_value from db_root;
select current_val from db_serial where name = 's27934_3';
select serial_next_value (s27934_3, 3) from db_root;
select current_val from db_serial where name = 's27934_3';
select serial_next_value (s27934_3, 3) from db_root;
select current_val from db_serial where name = 's27934_3';
select serial_next_value (s27934_3, 3) from db_root;
select current_val from db_serial where name = 's27934_3';

evaluate 'Case 4: ascending CYCLE CACHE 10, seven values then n = 3 to the block end 10; result = current_val 10';
create serial s27934_4 start with 1 maxvalue 1000 cache 10 cycle;
select s27934_4.next_value from db_root;
select s27934_4.next_value from db_root;
select s27934_4.next_value from db_root;
select s27934_4.next_value from db_root;
select s27934_4.next_value from db_root;
select s27934_4.next_value from db_root;
select s27934_4.next_value from db_root;
select current_val from db_serial where name = 's27934_4';
select serial_next_value (s27934_4, 3) from db_root;
select current_val from db_serial where name = 's27934_4';

evaluate 'Case 5: INCREMENT BY 3 MINVALUE 0 MAXVALUE 20 CYCLE CACHE 3, n = 7 wraps to the 0, 3, 6 lattice, then twelve values; result = current_val 0, then 18';
create serial s27934_5 start with 1 increment by 3 minvalue 0 maxvalue 20 cycle cache 3;
select s27934_5.next_value from db_root;
select serial_next_value (s27934_5, 7) from db_root;
select current_val from db_serial where name = 's27934_5';
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select s27934_5.next_value from db_root;
select current_val from db_serial where name = 's27934_5';

evaluate 'Case 6: MAXVALUE 20 CYCLE CACHE 10, five values, n = 18 wraps, one value; result = current_val 1, then 11';
create serial s27934_6 start with 1 maxvalue 20 cache 10 cycle;
select s27934_6.next_value from db_root;
select s27934_6.next_value from db_root;
select s27934_6.next_value from db_root;
select s27934_6.next_value from db_root;
select s27934_6.next_value from db_root;
select serial_next_value (s27934_6, 18) from db_root;
select current_val from db_serial where name = 's27934_6';
select s27934_6.next_value from db_root;
select current_val from db_serial where name = 's27934_6';

evaluate 'Case 7: descending MINVALUE -20 CYCLE CACHE 10, five values, n = 18 wraps, one value (control); result = current_val -11 after the last value';
create serial s27934_7 start with -1 increment by -1 minvalue -20 maxvalue -1 cache 10 cycle;
select s27934_7.next_value from db_root;
select s27934_7.next_value from db_root;
select s27934_7.next_value from db_root;
select s27934_7.next_value from db_root;
select s27934_7.next_value from db_root;
select serial_next_value (s27934_7, 18) from db_root;
select current_val from db_serial where name = 's27934_7';
select s27934_7.next_value from db_root;
select current_val from db_serial where name = 's27934_7';

drop serial s27934_1;
drop serial s27934_2;
drop serial s27934_3;
drop serial s27934_4;
drop serial s27934_5;
drop serial s27934_6;
drop serial s27934_7;
