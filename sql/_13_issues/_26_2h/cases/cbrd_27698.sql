/**
 *  This test case verifies CBRD-27698: a serial cache block size is computed in 64 bits
 *
 *  SERIAL_NEXT_VALUE (s, n) on a cached serial reserves a block of ceil(n / cached_num) * cached_num
 *  values. The block size was computed in int, so near INT_MAX it overflowed, and the block end
 *  written to _db_serial covered one value while the draw handed out n values. A crash then issued
 *  those values again. Each case reads current_val of the serial row, the value a restart resumes
 *  from: it must be at or past the last value handed out.
 *
 *  The lock-free refill of a non-cyclic serial, which also reserves a block wider than int, is
 *  checked by cbrd_27019. These cases take the paths that it does not take.
 *
 *  Coverage:
 *    Case 1:  the install after a decache (cache miss): the block end covers the INT_MAX draw
 *    Case 2:  the install on the first draw of a serial, a product past int: the block end covers the draw
 *    Case 3:  the refill of a cyclic serial up to MAXVALUE: the block end wraps to MINVALUE
 *    Case 4:  the install on the first draw whose product fits int (control)
 */

drop serial if exists s27698_1;
drop serial if exists s27698_2;
drop serial if exists s27698_3;
drop serial if exists s27698_4;

evaluate 'Case 1: the install after a decache; result = current_val 2147483652';
create serial s27698_1 start with 1 cache 2;
select s27698_1.next_value from db_root;
select s27698_1.next_value from db_root;
alter serial s27698_1 cache 2;
select serial_next_value (s27698_1, 2147483647) from db_root;
select s27698_1.next_value from db_root;
select s27698_1.next_value from db_root;
select current_val from db_serial where name = 's27698_1';

evaluate 'Case 2: the install on the first draw of a CACHE 1000000000 serial; result = current_val 3000000001';
create serial s27698_2 start with 1 cache 1000000000;
select serial_next_value (s27698_2, 2147483647) from db_root;
select s27698_2.next_value from db_root;
select current_val from db_serial where name = 's27698_2';

evaluate 'Case 3: the refill of a CYCLE serial up to MAXVALUE 2147483649; result = current_val 1';
create serial s27698_3 start with 1 maxvalue 2147483649 cache 2 cycle;
select s27698_3.next_value from db_root;
select s27698_3.next_value from db_root;
select serial_next_value (s27698_3, 2147483647) from db_root;
select current_val from db_serial where name = 's27698_3';

evaluate 'Case 4: the install on the first draw of a CACHE 3 serial (control); result = current_val 2147483650';
create serial s27698_4 start with 1 cache 3;
select serial_next_value (s27698_4, 2147483647) from db_root;
select s27698_4.next_value from db_root;
select current_val from db_serial where name = 's27698_4';

drop serial s27698_1;
drop serial s27698_2;
drop serial s27698_3;
drop serial s27698_4;
