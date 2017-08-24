drop table if exists alltypes;
CREATE table alltypes(blob_col blob,clob_col clob);
insert into alltypes values('123', '123');
select blob_to_bit(blob_col), clob_to_char(clob_col) from alltypes;
drop table if exists alltypes;

