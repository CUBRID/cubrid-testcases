drop if exists tx;
create table tx (tx int);
insert into tx values (7);
create view JSON_ARRAYAGG as select tx from tx where tx is not null;
select * from JSON_ARRAYAGG;
drop view JSON_ARRAYAGG;

rename table tx as JSON_ARRAY_INSERT;
alter table JSON_ARRAY_INSERT change tx JSON_ARRAY_INSERT integer;
create view JSON_ARRAY_APPEND as select JSON_ARRAY_INSERT from JSON_ARRAY_INSERT where JSON_ARRAY_INSERT is not null;
select * from JSON_ARRAY_APPEND;
drop view JSON_ARRAY_APPEND;

rename table JSON_ARRAY_INSERT as JSON_ARRAY_LEX;
alter table JSON_ARRAY_LEX change JSON_ARRAY_INSERT JSON_ARRAY_LEX integer;
create view JSON_ARRAY_INSERT as select JSON_ARRAY_LEX from JSON_ARRAY_LEX where JSON_ARRAY_LEX is not null;
select * from JSON_ARRAY_INSERT;
drop view JSON_ARRAY_INSERT;

rename table JSON_ARRAY_LEX as JSON_CONTAINS;
alter table JSON_CONTAINS change JSON_ARRAY_LEX JSON_CONTAINS integer;
create view JSON_ARRAY_LEX as select JSON_CONTAINS from JSON_CONTAINS where JSON_CONTAINS is not null;
select * from JSON_ARRAY_LEX;
drop view JSON_ARRAY_LEX;

rename table JSON_CONTAINS as JSON_CONTAINS_PATH;
alter table JSON_CONTAINS_PATH change JSON_CONTAINS JSON_CONTAINS_PATH integer;
create view JSON_CONTAINS as select JSON_CONTAINS_PATH from JSON_CONTAINS_PATH where JSON_CONTAINS_PATH is not null;
select * from JSON_CONTAINS;
drop view JSON_CONTAINS;

rename table JSON_CONTAINS_PATH as JSON_DEPTH;
alter table JSON_DEPTH change JSON_CONTAINS_PATH JSON_DEPTH integer;
create view JSON_CONTAINS_PATH as select JSON_DEPTH from JSON_DEPTH where JSON_DEPTH is not null;
select * from JSON_CONTAINS_PATH;
drop view JSON_CONTAINS_PATH;

rename table JSON_DEPTH as JSON_EXTRACT;
alter table JSON_EXTRACT change JSON_DEPTH JSON_EXTRACT integer;
create view JSON_DEPTH as select JSON_EXTRACT from JSON_EXTRACT where JSON_EXTRACT is not null;
select * from JSON_DEPTH;
drop view JSON_DEPTH;

rename table JSON_EXTRACT as JSON_GET_ALL_PATHS;
alter table JSON_GET_ALL_PATHS change JSON_EXTRACT JSON_GET_ALL_PATHS integer;
create view JSON_EXTRACT as select JSON_GET_ALL_PATHS from JSON_GET_ALL_PATHS where JSON_GET_ALL_PATHS is not null;
select * from JSON_EXTRACT;
drop view JSON_EXTRACT;

rename table JSON_GET_ALL_PATHS as JSON_INSERT;
alter table JSON_INSERT change JSON_GET_ALL_PATHS JSON_INSERT integer;
create view JSON_GET_ALL_PATHS as select JSON_INSERT from JSON_INSERT where JSON_INSERT is not null;
select * from JSON_GET_ALL_PATHS;
drop view JSON_GET_ALL_PATHS;

rename table JSON_INSERT as JSON_KEYS;
alter table JSON_KEYS change JSON_INSERT JSON_KEYS integer;
create view JSON_INSERT as select JSON_KEYS from JSON_KEYS where JSON_KEYS is not null;
select * from JSON_INSERT;
drop view JSON_INSERT;

rename table JSON_KEYS as JSON_LENGTH;
alter table JSON_LENGTH change JSON_KEYS JSON_LENGTH integer;
create view JSON_KEYS as select JSON_LENGTH from JSON_LENGTH where JSON_LENGTH is not null;
select * from JSON_KEYS;
drop view JSON_KEYS;

rename table JSON_LENGTH as JSON_MERGE;
alter table JSON_MERGE change JSON_LENGTH JSON_MERGE integer;
create view JSON_LENGTH as select JSON_MERGE from JSON_MERGE where JSON_MERGE is not null;
select * from JSON_LENGTH;
drop view JSON_LENGTH;

rename table JSON_MERGE as JSON_MERGE_PATCH;
alter table JSON_MERGE_PATCH change JSON_MERGE JSON_MERGE_PATCH integer;
create view JSON_MERGE as select JSON_MERGE_PATCH from JSON_MERGE_PATCH where JSON_MERGE_PATCH is not null;
select * from JSON_MERGE;
drop view JSON_MERGE;

rename table JSON_MERGE_PATCH as JSON_MERGE_PRESERVE;
alter table JSON_MERGE_PRESERVE change JSON_MERGE_PATCH JSON_MERGE_PRESERVE integer;
create view JSON_MERGE_PATCH as select JSON_MERGE_PRESERVE from JSON_MERGE_PRESERVE where JSON_MERGE_PRESERVE is not null;
select * from JSON_MERGE_PATCH;
drop view JSON_MERGE_PATCH;

rename table JSON_MERGE_PRESERVE as JSON_OBJECTAGG;
alter table JSON_OBJECTAGG change JSON_MERGE_PRESERVE JSON_OBJECTAGG integer;
create view JSON_MERGE_PRESERVE as select JSON_OBJECTAGG from JSON_OBJECTAGG where JSON_OBJECTAGG is not null;
select * from JSON_MERGE_PRESERVE;
drop view JSON_MERGE_PRESERVE;

rename table JSON_OBJECTAGG as JSON_OBJECT_LEX;
alter table JSON_OBJECT_LEX change JSON_OBJECTAGG JSON_OBJECT_LEX integer;
create view JSON_OBJECTAGG as select JSON_OBJECT_LEX from JSON_OBJECT_LEX where JSON_OBJECT_LEX is not null;
select * from JSON_OBJECTAGG;
drop view JSON_OBJECTAGG;

rename table JSON_OBJECT_LEX as JSON_PRETTY;
alter table JSON_PRETTY change JSON_OBJECT_LEX JSON_PRETTY integer;
create view JSON_OBJECT_LEX as select JSON_PRETTY from JSON_PRETTY where JSON_PRETTY is not null;
select * from JSON_OBJECT_LEX;
drop view JSON_OBJECT_LEX;

rename table JSON_PRETTY as JSON_QUOTE;
alter table JSON_QUOTE change JSON_PRETTY JSON_QUOTE integer;
create view JSON_PRETTY as select JSON_QUOTE from JSON_QUOTE where JSON_QUOTE is not null;
select * from JSON_PRETTY;
drop view JSON_PRETTY;

rename table JSON_QUOTE as JSON_REMOVE;
alter table JSON_REMOVE change JSON_QUOTE JSON_REMOVE integer;
create view JSON_QUOTE as select JSON_REMOVE from JSON_REMOVE where JSON_REMOVE is not null;
select * from JSON_QUOTE;
drop view JSON_QUOTE;

rename table JSON_REMOVE as JSON_REPLACE;
alter table JSON_REPLACE change JSON_REMOVE JSON_REPLACE integer;
create view JSON_REMOVE as select JSON_REPLACE from JSON_REPLACE where JSON_REPLACE is not null;
select * from JSON_REMOVE;
drop view JSON_REMOVE;

rename table JSON_REPLACE as JSON_SEARCH;
alter table JSON_SEARCH change JSON_REPLACE JSON_SEARCH integer;
create view JSON_REPLACE as select JSON_SEARCH from JSON_SEARCH where JSON_SEARCH is not null;
select * from JSON_REPLACE;
drop view JSON_REPLACE;

rename table JSON_SEARCH as JSON_SET;
alter table JSON_SET change JSON_SEARCH JSON_SET integer;
create view JSON_SEARCH as select JSON_SET from JSON_SET where JSON_SET is not null;
select * from JSON_SEARCH;
drop view JSON_SEARCH;

rename table JSON_SET as JSON_TABLE;
alter table JSON_TABLE change JSON_SET JSON_TABLE integer;
create view JSON_SET as select JSON_TABLE from JSON_TABLE where JSON_TABLE is not null;
select * from JSON_SET;
drop view JSON_SET;

rename table JSON_TABLE as JSON_TYPE;
alter table JSON_TYPE change JSON_TABLE JSON_TYPE integer;
create view JSON_TABLE as select JSON_TYPE from JSON_TYPE where JSON_TYPE is not null;
select * from JSON_TABLE;
drop view JSON_TABLE;

rename table JSON_TYPE as JSON_UNQUOTE;
alter table JSON_UNQUOTE change JSON_TYPE JSON_UNQUOTE integer;
create view JSON_TYPE as select JSON_UNQUOTE from JSON_UNQUOTE where JSON_UNQUOTE is not null;
select * from JSON_TYPE;
drop view JSON_TYPE;

rename table JSON_UNQUOTE as JSON_VALID;
alter table JSON_VALID change JSON_UNQUOTE JSON_VALID integer;
create view JSON_UNQUOTE as select JSON_VALID from JSON_VALID where JSON_VALID is not null;
select * from JSON_UNQUOTE;
drop view JSON_UNQUOTE;

rename table JSON_VALID as JSON_ARRAYAGG;
alter table JSON_ARRAYAGG change JSON_VALID JSON_ARRAYAGG integer;
create view JSON_VALID as select JSON_ARRAYAGG from JSON_ARRAYAGG where JSON_ARRAYAGG is not null;
select * from JSON_VALID;
drop view JSON_VALID;

rename table JSON_ARRAYAGG as JSON_ARRAY_APPEND;
alter table JSON_ARRAY_APPEND change JSON_ARRAYAGG JSON_ARRAY_APPEND integer;
create view JSON_ARRAYAGG as select JSON_ARRAY_APPEND from JSON_ARRAY_APPEND where JSON_ARRAY_APPEND is not null;
select * from JSON_ARRAYAGG;
drop view JSON_ARRAYAGG;
  

drop table JSON_ARRAY_APPEND;
