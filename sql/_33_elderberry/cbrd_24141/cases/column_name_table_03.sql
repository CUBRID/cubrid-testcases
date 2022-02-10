drop if exists t_colname;
create table t_colname (
JSON_ARRAYAGG int,
JSON_ARRAY_APPEND int,
JSON_ARRAY_INSERT int,
JSON_ARRAY_LEX int,
JSON_CONTAINS int,
JSON_CONTAINS_PATH int,
JSON_DEPTH int,
JSON_EXTRACT int,
JSON_GET_ALL_PATHS int,
JSON_INSERT int,
JSON_KEYS int,
JSON_LENGTH int,
JSON_MERGE int,
JSON_MERGE_PATCH int,
JSON_MERGE_PRESERVE int,
JSON_OBJECTAGG int,
JSON_OBJECT_LEX int,
JSON_PRETTY int,
JSON_QUOTE int,
JSON_REMOVE int,
JSON_REPLACE int,
JSON_SEARCH int,
JSON_SET int,
JSON_TABLE int,
JSON_TYPE int,
JSON_UNQUOTE int,
JSON_VALID int
);

create index JSON_ARRAYAGG on t_colname (JSON_ARRAYAGG);
create index JSON_ARRAY_APPEND on t_colname (JSON_ARRAY_APPEND);
create index JSON_ARRAY_INSERT on t_colname (JSON_ARRAY_INSERT);
create index JSON_ARRAY_LEX on t_colname (JSON_ARRAY_LEX);
create index JSON_CONTAINS on t_colname (JSON_CONTAINS);
create index JSON_CONTAINS_PATH on t_colname (JSON_CONTAINS_PATH);
create index JSON_DEPTH on t_colname (JSON_DEPTH);
create index JSON_EXTRACT on t_colname (JSON_EXTRACT);
create index JSON_GET_ALL_PATHS on t_colname (JSON_GET_ALL_PATHS);
create index JSON_INSERT on t_colname (JSON_INSERT);
create index JSON_KEYS on t_colname (JSON_KEYS);
create index JSON_LENGTH on t_colname (JSON_LENGTH);
create index JSON_MERGE on t_colname (JSON_MERGE);
create index JSON_MERGE_PATCH on t_colname (JSON_MERGE_PATCH);
create index JSON_MERGE_PRESERVE on t_colname (JSON_MERGE_PRESERVE);
create index JSON_OBJECTAGG on t_colname (JSON_OBJECTAGG);
create index JSON_OBJECT_LEX on t_colname (JSON_OBJECT_LEX);
create index JSON_PRETTY on t_colname (JSON_PRETTY);
create index JSON_QUOTE on t_colname (JSON_QUOTE);
create index JSON_REMOVE on t_colname (JSON_REMOVE);
create index JSON_REPLACE on t_colname (JSON_REPLACE);
create index JSON_SEARCH on t_colname (JSON_SEARCH);
create index JSON_SET on t_colname (JSON_SET);
create index JSON_TABLE on t_colname (JSON_TABLE);
create index JSON_TYPE on t_colname (JSON_TYPE);
create index JSON_UNQUOTE on t_colname (JSON_UNQUOTE);
create index JSON_VALID on t_colname (JSON_VALID);

insert into t_colname values ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ,14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27);
select * from t_colname;
select JSON_ARRAYAGG,JSON_ARRAY_APPEND,JSON_ARRAY_INSERT,JSON_ARRAY_LEX,JSON_CONTAINS,JSON_CONTAINS_PATH,JSON_DEPTH, 
 JSON_EXTRACT,JSON_GET_ALL_PATHS,JSON_INSERT,JSON_KEYS,JSON_LENGTH,JSON_MERGE,JSON_MERGE_PATCH,JSON_MERGE_PRESERVE,
 JSON_OBJECTAGG,JSON_OBJECT_LEX,JSON_PRETTY,JSON_QUOTE,JSON_REMOVE,JSON_REPLACE,JSON_SEARCH,JSON_SET,
 JSON_TABLE,JSON_TYPE,JSON_UNQUOTE,JSON_VALID 
from t_colname;


create table JSON_ARRAYAGG (JSON_ARRAYAGG int);
create index JSON_ARRAYAGG on JSON_ARRAYAGG (JSON_ARRAYAGG );
insert into JSON_ARRAYAGG select JSON_ARRAYAGG from t_colname;
select JSON_ARRAYAGG from JSON_ARRAYAGG ;
drop table JSON_ARRAYAGG ;

create table JSON_ARRAY_APPEND (JSON_ARRAY_APPEND int);
create index JSON_ARRAY_APPEND on JSON_ARRAY_APPEND (JSON_ARRAY_APPEND );
insert into JSON_ARRAY_APPEND select JSON_ARRAY_APPEND from t_colname;
select JSON_ARRAY_APPEND from JSON_ARRAY_APPEND ;
drop table JSON_ARRAY_APPEND ;

create table JSON_ARRAY_INSERT (JSON_ARRAY_INSERT int);
create index JSON_ARRAY_INSERT on JSON_ARRAY_INSERT (JSON_ARRAY_INSERT );
insert into JSON_ARRAY_INSERT select JSON_ARRAY_INSERT from t_colname;
select JSON_ARRAY_INSERT from JSON_ARRAY_INSERT ;
drop table JSON_ARRAY_INSERT ;

create table JSON_ARRAY_LEX (JSON_ARRAY_LEX int);
create index JSON_ARRAY_LEX on JSON_ARRAY_LEX (JSON_ARRAY_LEX );
insert into JSON_ARRAY_LEX select JSON_ARRAY_LEX from t_colname;
select JSON_ARRAY_LEX from JSON_ARRAY_LEX ;
drop table JSON_ARRAY_LEX ;

create table JSON_CONTAINS (JSON_CONTAINS int);
create index JSON_CONTAINS on JSON_CONTAINS (JSON_CONTAINS );
insert into JSON_CONTAINS select JSON_CONTAINS from t_colname;
select JSON_CONTAINS from JSON_CONTAINS ;
drop table JSON_CONTAINS ;

create table JSON_CONTAINS_PATH (JSON_CONTAINS_PATH int);
create index JSON_CONTAINS_PATH on JSON_CONTAINS_PATH (JSON_CONTAINS_PATH );
insert into JSON_CONTAINS_PATH select JSON_CONTAINS_PATH from t_colname;
select JSON_CONTAINS_PATH from JSON_CONTAINS_PATH;
drop table JSON_CONTAINS_PATH;

create table JSON_DEPTH (JSON_DEPTH int);
create index JSON_DEPTH on JSON_DEPTH (JSON_DEPTH );
insert into JSON_DEPTH select JSON_DEPTH from t_colname;
select JSON_DEPTH from JSON_DEPTH;
drop table JSON_DEPTH;

create table JSON_EXTRACT (JSON_EXTRACT int);
create index JSON_EXTRACT on JSON_EXTRACT (JSON_EXTRACT );
insert into JSON_EXTRACT select JSON_EXTRACT from t_colname;
select JSON_EXTRACT from JSON_EXTRACT;
drop table JSON_EXTRACT;

create table JSON_GET_ALL_PATHS (JSON_GET_ALL_PATHS int);
create index JSON_GET_ALL_PATHS on JSON_GET_ALL_PATHS (JSON_GET_ALL_PATHS );
insert into JSON_GET_ALL_PATHS select JSON_GET_ALL_PATHS from t_colname;
select JSON_GET_ALL_PATHS from JSON_GET_ALL_PATHS;
drop table JSON_GET_ALL_PATHS;

create table JSON_INSERT (JSON_INSERT int);
create index JSON_INSERT on JSON_INSERT (JSON_INSERT );
insert into JSON_INSERT select JSON_INSERT from t_colname;
select JSON_INSERT from JSON_INSERT;
drop table JSON_INSERT;

create table JSON_KEYS (JSON_KEYS int);
create index JSON_KEYS on JSON_KEYS (JSON_KEYS );
insert into JSON_KEYS select JSON_KEYS from t_colname;
select JSON_KEYS from JSON_KEYS;
drop table JSON_KEYS;

create table JSON_LENGTH (JSON_LENGTH int);
create index JSON_LENGTH on JSON_LENGTH (JSON_LENGTH );
insert into JSON_LENGTH select JSON_LENGTH from t_colname;
select JSON_LENGTH from JSON_LENGTH;
drop table JSON_LENGTH;

create table JSON_MERGE (JSON_MERGE int);
create index JSON_MERGE on JSON_MERGE (JSON_MERGE );
insert into JSON_MERGE select JSON_MERGE from t_colname;
select JSON_MERGE from JSON_MERGE;
drop table JSON_MERGE;

create table JSON_MERGE_PATCH (JSON_MERGE_PATCH int);
create index JSON_MERGE_PATCH on JSON_MERGE_PATCH (JSON_MERGE_PATCH );
insert into JSON_MERGE_PATCH select JSON_MERGE_PATCH from t_colname;
select JSON_MERGE_PATCH from JSON_MERGE_PATCH;
drop table JSON_MERGE_PATCH;

create table JSON_MERGE_PRESERVE (JSON_MERGE_PRESERVE int);
create index JSON_MERGE_PRESERVE on JSON_MERGE_PRESERVE (JSON_MERGE_PRESERVE );
insert into JSON_MERGE_PRESERVE select JSON_MERGE_PRESERVE from t_colname;
select JSON_MERGE_PRESERVE from JSON_MERGE_PRESERVE;
drop table JSON_MERGE_PRESERVE;

create table JSON_OBJECTAGG (JSON_OBJECTAGG int);
create index JSON_OBJECTAGG on JSON_OBJECTAGG (JSON_OBJECTAGG );
insert into JSON_OBJECTAGG select JSON_OBJECTAGG from t_colname;
select JSON_OBJECTAGG from JSON_OBJECTAGG ;
drop table JSON_OBJECTAGG ;

create table JSON_OBJECT_LEX (JSON_OBJECT_LEX int);
create index JSON_OBJECT_LEX on JSON_OBJECT_LEX (JSON_OBJECT_LEX );
insert into JSON_OBJECT_LEX select JSON_OBJECT_LEX from t_colname;
select JSON_OBJECT_LEX from JSON_OBJECT_LEX;
drop table JSON_OBJECT_LEX;

create table JSON_PRETTY (JSON_PRETTY int);
create index JSON_PRETTY on JSON_PRETTY (JSON_PRETTY );
insert into JSON_PRETTY select JSON_PRETTY from t_colname;
select JSON_PRETTY from JSON_PRETTY;
drop table JSON_PRETTY;

create table JSON_QUOTE (JSON_QUOTE int);
create index JSON_QUOTE on JSON_QUOTE (JSON_QUOTE );
insert into JSON_QUOTE select JSON_QUOTE from t_colname;
select JSON_QUOTE from JSON_QUOTE;
drop table JSON_QUOTE;

create table JSON_REMOVE (JSON_REMOVE int);
create index JSON_REMOVE on JSON_REMOVE (JSON_REMOVE );
insert into JSON_REMOVE select JSON_REMOVE from t_colname;
select JSON_REMOVE from JSON_REMOVE;
drop table JSON_REMOVE;

create table JSON_REPLACE (JSON_REPLACE int);
create index JSON_REPLACE on JSON_REPLACE (JSON_REPLACE );
insert into JSON_REPLACE select JSON_REPLACE from t_colname;
select JSON_REPLACE from JSON_REPLACE;
drop table JSON_REPLACE;

create table JSON_SEARCH (JSON_SEARCH int);
create index JSON_SEARCH on JSON_SEARCH (JSON_SEARCH );
insert into JSON_SEARCH select JSON_SEARCH from t_colname;
select JSON_SEARCH from JSON_SEARCH;
drop table JSON_SEARCH;

create table JSON_SET (JSON_SET int);
create index JSON_SET on JSON_SET (JSON_SET );
insert into JSON_SET select JSON_SET from t_colname;
select JSON_SET from JSON_SET ;
drop table JSON_SET ;

create table JSON_TABLE (JSON_TABLE int);
create index JSON_TABLE on JSON_TABLE (JSON_TABLE );
insert into JSON_TABLE select JSON_TABLE from t_colname;
select JSON_TABLE from JSON_TABLE;
drop table JSON_TABLE;

create table JSON_TYPE (JSON_TYPE int);
create index JSON_TYPE on JSON_TYPE (JSON_TYPE );
insert into JSON_TYPE select JSON_TYPE from t_colname;
select JSON_TYPE from JSON_TYPE;
drop table JSON_TYPE;

create table JSON_UNQUOTE (JSON_UNQUOTE int);
create index JSON_UNQUOTE on JSON_UNQUOTE (JSON_UNQUOTE );
insert into JSON_UNQUOTE select JSON_UNQUOTE from t_colname;
select JSON_UNQUOTE from JSON_UNQUOTE;
drop table JSON_UNQUOTE;

create table JSON_VALID (JSON_VALID int);
create index JSON_VALID on JSON_VALID (JSON_VALID );
insert into JSON_VALID select JSON_VALID from t_colname;
select JSON_VALID from JSON_VALID;
drop table JSON_VALID;

drop table t_colname;
