--TEST: [FilteredIndex] ERROR: System error (generate var) in ../../src/parser/xasl_generation.c (line: 9360) error occurs when creating a filtered index with clob_from_file() function.

create table t(id integer, textlabel varchar(255), description varchar(4096));

create index idx_t_description on t(description) where char_length(description) < char_length(clob_from_file('aa'));

create index idx_t_description on t(description) where char_length(description) < char_length(blob_from_file('aa'));

create index idx_t_description on t(description) where char_length(description) < char_length(char_to_clob('aa'));

create index idx_t_description on t(description) where char_length(description) < char_length(char_to_blob('aa'));

create index idx_t_description on t(description) where char_length(description) < char_length(bit_to_blob(b'010101'));

drop table t;

select clob_from_file ('aa');

select blob_from_file ('aa');

create table t (i int, c clob);

insert into t select 1, clob_from_file ('aa');

drop table t;

create table t (i int, c blob);

insert into t select 1, blob_from_file ('aa');

drop table t;

