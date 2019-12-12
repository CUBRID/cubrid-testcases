--insert data into super/sub class with blob/clob column

create class insert10_t1 (name varchar(20), age integer, photo blob);
create class sub_insert10_t1 as subclass of insert10_t1(doc clob);

insert into insert10_t1 values('Jerry', 25, bit_to_blob(X'0101'));
insert into insert10_t1 values('Tom', 26, bit_to_blob(X'010101'));
insert into insert10_t1 values('Kitty', 27, bit_to_blob(X'10101'));
insert into insert10_t1 values('Cat', 23, bit_to_blob(X'0101110'));


insert into sub_insert10_t1 values('Sun', 26, bit_to_blob(X'1110'), char_to_clob('abcd'));
insert into sub_insert10_t1 values('Moon', 27, bit_to_blob(X'01101'), char_to_clob('rrrrrrr'));
insert into sub_insert10_t1 values('Star', 22, bit_to_blob(X'10101'), char_to_clob('adfaeee'));
insert into sub_insert10_t1 values('K', 21, bit_to_blob(X'01011001'), char_to_clob('fijklms'));

select name, age, blob_to_bit(photo) from insert10_t1 order by 1;
select name, age, blob_to_bit(photo), clob_to_char(doc) from sub_insert10_t1 order by name,age;

delete from insert10_t1;
delete from sub_insert10_t1;
drop class insert10_t1;
drop class sub_insert10_t1;
