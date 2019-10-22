drop table if exists t1;
create table t1 (id int primary key, b varchar(100));

-- expected fail
--test: cub_server crashed
create index idxSearch on t1(JSON_SEARCH(b, 'all', 'hello'));
create index idxExtract on t1(json_extract(b,'$.');
create index idxUQ on t1(b->>'$.');
create index idxExt on t1(b->'$.');
create index idxMP on t1(JSON_MERGE_PRESERVE(b, b, 1));
create index idxSTS on t1(JSON_STORAGE_SIZE(b));
create index idxSTF on t1(JSON_STORAGE_FREE(b));

--expecte success
create index idxValid on t1(json_valid(b));
create index idxType on t1(json_type(b));
create index idxLength on t1(json_length(b));
create index idxPretty on t1(json_pretty(b));
create index idxb on t1(b);
create index idxQuote on t1(json_quote(b));
create index idxUnquote on t1(json_unquote(b));

show indexes from t1;
insert into t1(id, b) values (1,1);
select /*+ recompile */ * from t1 where json_length(b)=1;
select /*+ recompile */ * from t1 where json_valid(b)=1;
select /*+ recompile */ json_pretty(b) from t1 where json_extract(b,'$."a"')=1;
select /*+ recompile */ json_pretty(b) from t1;
select /*+ recompile */ json_pretty(b) from t1 where json_pretty(b) is not null;

drop table if exists t1;
create table t1 (id int primary key, b json);

--expected fail
--test: cub_server crashed
create index idx1 on t1(JSON_SEARCH(b, 'all', 'hello'));
create index idx2 on t1(json_extract(b,'$.');
create index idx7 on t1(b->>'$.');
create index idx7 on t1(JSON_MERGE_PRESERVE(b, b, 1));
create index idx12 on t1(JSON_STORAGE_SIZE(b));
create index idx13 on t1(JSON_STORAGE_FREE(b));
create index idx3 on t1(json_valid(b));
create index idx4 on t1(json_type(b));
create index idx5 on t1(json_length(b));
create index idx8 on t1(json_pretty(b));
create index idx10 on t1(json_quote(b));
create index idx11 on t1(json_unquote(b));
create index idx9 on t1(b);
show indexes from t1;

insert into t1(id, b) values (1,'{"a": 1}');

select /*+ recompile */ * from t1 where json_length(b)=1;
select /*+ recompile */ json_pretty(b) from t1 where json_extract(b,'$."a"')=1;
select /*+ recompile */ json_pretty(b) from t1;
select /*+ recompile */ json_pretty(b) from t1 where json_pretty(b) is not null;

drop table if exists t1;

