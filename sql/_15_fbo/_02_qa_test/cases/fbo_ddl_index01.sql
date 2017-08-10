-- create normal table
create table fbo_index (col1 int, col2 string, col3 char(10), col4 varchar(10), col6 blob, col7 clob);
insert into fbo_index values (1,'string1','char1','varchar1',bit_to_blob(X'1aaabbbccc'),char_to_clob('1aaabbbccc'));
insert into fbo_index values (2,'string2','char2','varchar2',bit_to_blob(X'2aaabbbccc'),char_to_clob('2aaabbbccc'));
insert into fbo_index values (3,'string3','char3','varchar3',bit_to_blob(X'3aaabbbccc'),char_to_clob('3aaabbbccc'));
insert into fbo_index values (4,'string4','char4','varchar4',bit_to_blob(X'4aaabbbccc'),char_to_clob('4aaabbbccc'));
insert into fbo_index values (5,'string5','char5','varchar5',bit_to_blob(X'5aaabbbccc'),char_to_clob('5aaabbbccc'));

-- ok ; index ; unique index ; reverse index; reverse unique index;
create index pre_fbo_index on fbo_index(col4(3));
create index idx_col1_col2 on fbo_index(col1,col2);
create index fbo_index_index on fbo_index(col1,col2,col3);
create unique index u_idx on fbo_index(col1,col2,col3,col4);
create unique index fbo_index_unique on fbo_index(col1);
create unique index fbo_index_unique2 on fbo_index(col1,col2,col3,col4);

create reverse index r_idx1 on fbo_index(col1);
create reverse index r_idx2 on fbo_index(col1,col4);
create reverse unique index fbo_index_ruindex on fbo_index(col1,col2,col3);

-- error
create index pre_fbo_er_index on fbo_index(col7(3));
create index idx1 on fbo_index(col6);
create index idx2 on fbo_index(col7);
create index idx3 on fbo_index(col6,col7);
create index fbo_index_index_er on fbo_index(col1,col6,col7);
create unique index idx4 on fbo_index(col1,col2,col6,col7);
create unique index fbo_index_unique_er1 on fbo_index(col6);
create unique index fbo_index_unique_er2 on fbo_index(col7);
create unique index fbo_index_unique2_er on fbo_index(col1,col2,col3,col4,col6,col7);

create reverse index r_idx3 on fbo_index(col7);
create reverse index r_idx4 on fbo_index(col1,col6);
create reverse unique index fbo_index_ruindex_er on fbo_index(col1,col6,col7);

delete from fbo_index;
drop table fbo_index;
