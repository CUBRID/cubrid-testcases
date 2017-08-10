--create table by hash partition on blob/clob column and insert data

--blob
create class insert9_t1 (a integer auto_increment, b blob)
        PARTITION BY HASH (b)
        partitions 4;

--clob
create class insert9_t1 (a integer auto_increment, b clob)
        PARTITION BY RANGE(b)
        PARTITIONS 4;



--create table by hash partition on non-blob/clob column and insert data

create class insert9_t1 (a integer auto_increment, b blob)
        PARTITION BY HASH (a)
        partitions 4;
        
insert into insert9_t1 (b) values(bit_to_blob(X'0001'));
insert into insert9_t1 (b) values(bit_to_blob(X'0000'));
insert into insert9_t1 (b) values(bit_to_blob(X'10000'));
insert into insert9_t1 (b) values(bit_to_blob(X'10000'));
insert into insert9_t1 (b) values(bit_to_blob(X'010000'));
insert into insert9_t1 (b) values(bit_to_blob(X'010000'));
insert into insert9_t1 (b) values(bit_to_blob(X'1001000'));
insert into insert9_t1 (b) values(bit_to_blob(X'1001000'));
insert into insert9_t1 (b) values(bit_to_blob(X'00100000'));
insert into insert9_t1 (b) values(bit_to_blob(X'00100000'));
insert into insert9_t1 (b) values(bit_to_blob(X'010000'));
insert into insert9_t1 (b) values(bit_to_blob(X'1001000'));
insert into insert9_t1 (b) values(bit_to_blob(X'1001000'));
insert into insert9_t1 (b) values(bit_to_blob(X'00100000'));
insert into insert9_t1 (b) values(bit_to_blob(X'00100000'));
insert into insert9_t1 (b) values(bit_to_blob(X'010000'));
insert into insert9_t1 (b) values(bit_to_blob(X'1001000'));
insert into insert9_t1 (b) values(bit_to_blob(X'1001000'));
insert into insert9_t1 (b) values(bit_to_blob(X'00100000'));
insert into insert9_t1 (b) values(bit_to_blob(X'00100111111111'));

select a, blob_to_bit(b) from insert9_t1__p__p0 order by a;
select a, blob_to_bit(b) from insert9_t1__p__p1 order by a;
select a, blob_to_bit(b) from insert9_t1__p__p2 order by a;
select a, blob_to_bit(b) from insert9_t1__p__p3 order by a;

delete from insert9_t1;
drop table insert9_t1;



create class insert9_t1 (a integer auto_increment, b blob, c clob, d varchar)
        PARTITION BY HASH(d)
        PARTITIONS 4;
        
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('c'), 'aaa');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('cd'), 'bbb');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('cdef'), 'ccc');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('abcde'), 'ddd');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('eeeee'), 'eee');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('a12bcd66'), 'fff');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('hahahahahha'), 'ggg');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('zzzzz'), 'hhh');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('uuuuuuu'), 'iii');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('67t'), 'jjj');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('SDFASDFA'), 'kkk');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('fkdfewasdfga'), 'lll');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('78asdjlaksjfaklsdfasdfafsd'), 'mmm');
insert into insert9_t1 (b, c, d) values(bit_to_blob(X'10101'), char_to_clob('74ijajkl;ddfhdj'), 'n''nn');

select a, blob_to_bit(b), clob_to_char(c), d from insert9_t1__p__p0 order by 1;
select a, blob_to_bit(b), clob_to_char(c), d from insert9_t1__p__p1 order by 1;
select a, blob_to_bit(b), clob_to_char(c), d from insert9_t1__p__p2 order by 1;
select a, blob_to_bit(b), clob_to_char(c), d from insert9_t1__p__p3 order by 1;

delete from insert9_t1;
drop table insert9_t1;
