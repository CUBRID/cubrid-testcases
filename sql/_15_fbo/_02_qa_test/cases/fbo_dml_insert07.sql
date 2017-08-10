--create table by list partition on blob/clob column and insert data

--blob
create class insert7_t1 (a integer, b blob)
        PARTITION BY LIST (a) (
            PARTITION p0 VALUES IN (1, 3, 5, 7, 9),
            PARTITION p1 VALUES IN (2, 4, 6, 8, 10),
            PARTITION p2 VALUES IN (11, 13, 15, 17, 19)
        );
        
insert into insert7_t1 (a, b) values(3, bit_to_blob(X'0000'));
insert into insert7_t1 (a, b) values(6, bit_to_blob(X'1000'));
insert into insert7_t1 (a, b) values(7, bit_to_blob(X'0100'));
insert into insert7_t1 (a, b) values(13, bit_to_blob(X'1001'));
insert into insert7_t1 (a, b) values(19, bit_to_blob(X'0010'));
insert into insert7_t1 (a, b) values(8, bit_to_blob(X'0111'));
insert into insert7_t1 (a, b) values(21, bit_to_blob(X'0111'));

select a, blob_to_bit(b) from insert7_t1__p__p0 order by a;
select a, blob_to_bit(b) from insert7_t1__p__p1 order by a;
select a, blob_to_bit(b) from insert7_t1__p__p2 order by a;

--insert a value which is not included in the partition value into blob column
--error
insert into insert7_t1 (a, b) values(101, bit_to_blob(X'1111'));

delete from insert7_t1
drop table insert7_t1;


--clob
create class insert7_t2 (a integer auto_increment, b clob, c char(10))
        PARTITION BY LIST (c) (
            PARTITION p0 VALUES IN ('aaa', 'bbb', 'ccc', 'ddd'),
            PARTITION p1 VALUES IN ('eee', 'fff', 'ggg', 'hhh'),
            PARTITION p2 VALUES IN ('iii', 'jjj', 'kkk', 'lll')
        );
        
insert into insert7_t2 (b, c) values(char_to_clob('aaa1'), 'bbb');
insert into insert7_t2 (b, c) values(char_to_clob('bbb1'), 'kkk');
insert into insert7_t2 (b, c) values(char_to_clob('ccc2'), 'ggg');
insert into insert7_t2 (b, c) values(char_to_clob('ddd2'), 'ddd');
insert into insert7_t2 (b, c) values(char_to_clob('bbb3'), 'hhh');
insert into insert7_t2 (b, c) values(char_to_clob('ccc3'), 'eee');
insert into insert7_t2 (b, c) values(char_to_clob('zzz3'), 'zzz');

select a, clob_to_char(b), c from insert7_t2__p__p0 order by a;
select a, clob_to_char(b), c from insert7_t2__p__p1 order by a;
select a, clob_to_char(b), c from insert7_t2__p__p2 order by a;

--insert a value which is not included in the partition value into blob column
--error
insert into insert7_t2 (b, c) values(char_to_clob('fff6'), 'abcd');

delete from insert7_t2;
drop table insert7_t2;
