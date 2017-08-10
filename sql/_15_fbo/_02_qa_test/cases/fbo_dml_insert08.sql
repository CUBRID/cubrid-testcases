--create table by range partition on blob/clob column and insert data

--blob
--error
create class insert8_t1 (a integer auto_increment, b blob)
        PARTITION BY RANGE(data_length(b)) (
            PARTITION p0 VALUES LESS THAN (10),
            PARTITION p1 VALUES LESS THAN (12),
            PARTITION p2 VALUES LESS THAN (15)
        );

--clob
--error
create class insert8_t1 (a integer auto_increment, b clob)
        PARTITION BY RANGE(b) (
            PARTITION p0 VALUES LESS THAN (3),
            PARTITION p0 VALUES LESS THAN (6),
            PARTITION p0 VALUES LESS THAN (9)
        );


--create table by range partition on non-blob/clob column and insert data

create class insert8_t1 (a integer auto_increment, b blob, c smallint)
        PARTITION BY RANGE(c) (
            PARTITION p0 VALUES LESS THAN (100),
            PARTITION p1 VALUES LESS THAN (1000),
            PARTITION p2 VALUES LESS THAN (10000)
        );
        
insert into insert8_t1 (b, c) values(bit_to_blob(X'0001'), 999);
insert into insert8_t1 (b, c) values(bit_to_blob(X'0000'), 34);
insert into insert8_t1 (b, c) values(bit_to_blob(X'10000'), 8463);
insert into insert8_t1 (b, c) values(bit_to_blob(X'10000'), 1);
insert into insert8_t1 (b, c) values(bit_to_blob(X'010000'), 884);
insert into insert8_t1 (b, c) values(bit_to_blob(X'010000'), 8099);
insert into insert8_t1 (b, c) values(bit_to_blob(X'1001000'), 22);
insert into insert8_t1 (b, c) values(bit_to_blob(X'1001000'), 101);
insert into insert8_t1 (b, c) values(bit_to_blob(X'00100000'), 9999);
insert into insert8_t1 (b, c) values(bit_to_blob(X'00100000'), 2325);

select a, blob_to_bit(b), c from insert8_t1__p__p0 order by 1;
select a, blob_to_bit(b), c from insert8_t1__p__p1 order by 1;
select a, blob_to_bit(b), c from insert8_t1__p__p2 order by 1;

--insert a value which is out of the range of the partition value
--error??
insert into insert8_t1 (b, c) values(bit_to_blob(X'11111111111111'), 28393);

delete from insert8_t1;
drop table insert8_t1;



create class insert8_t1 (a integer auto_increment, b clob, c string)
        PARTITION BY RANGE(char_length(c)) (
            PARTITION p0 VALUES LESS THAN (5),
            PARTITION p1 VALUES LESS THAN (8),
            PARTITION p2 VALUES LESS THAN (12)
        );
        
insert into insert8_t1 (b, c) values(char_to_clob('c'), 'aaa');
insert into insert8_t1 (b, c) values(char_to_clob('cd'), 'aaaa');
insert into insert8_t1 (b, c) values(char_to_clob('cdef'), 'aaaaa');
insert into insert8_t1 (b, c) values(char_to_clob('abcde'), 'aaaaaa');
insert into insert8_t1 (b, c) values(char_to_clob('eeeee'), 'aaaaaaa');
insert into insert8_t1 (b, c) values(char_to_clob('a12bcd66'), 'aaaaaaaa');
insert into insert8_t1 (b, c) values(char_to_clob('hahahahahha'), 'aaaaaaaaa');
insert into insert8_t1 (b, c) values(char_to_clob('zzzzz'), 'aaaaaaaaaa');
insert into insert8_t1 (b, c) values(char_to_clob('uuuuuuu'), 'aaaaaaaaaaa');

select a, clob_to_char(b), c from insert8_t1__p__p0 order by 1;
select a, clob_to_char(b), c from insert8_t1__p__p1 order by 1;
select a, clob_to_char(b), c from insert8_t1__p__p2 order by 1;

--insert a value which is out of the range of the partition value
--error??
insert into insert8_t1 (b, c) values(char_to_clob('oooooooooooooooooooooooo'), 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

delete from insert8_t1;
drop table insert8_t1;
