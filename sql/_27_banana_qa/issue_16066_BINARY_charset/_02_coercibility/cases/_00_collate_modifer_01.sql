--+ holdcas on;
set names binary;

-- column
drop table if exists t;
create table t(col1 string collate binary, col2 string collate utf8_bin);
insert into t values(cast(_utf8'안녕' as string charset euckr),'abc');
select concat(col1 collate binary, col2 collate utf8_bin) from t;

select concat(col1 collate binary,'abc' collate binary) from t;
select concat(col1 collate binary, 'abc' collate utf8_bin) from t;

select coercibility(col1 collate binary), coercibility('abc' collate binary) from t;
select coercibility(concat(col1 + col2)) from t;
select coercibility(concat(col1 + col2 collate utf8_bin)) from t;

select coercibility(_binary'abc');

select coercibility('abc' collate binary + (select col1 from t));

-- expression
select coercibility ((select col2 collate utf8_gen from t where col2 collate utf8_es_cs='abc'));
select coercibility ((select col1 collate binary from t where col2 collate utf8_es_cs='abc'));
select coercibility (cast((select col2 collate utf8_gen from t where col2 collate utf8_es_cs='abc') as string collate utf8_bin));
select coercibility (cast((select col2 collate utf8_gen from t where col2 collate utf8_es_cs='abc') as string collate binary));

select charset((select cast(col1 as string charset utf8) from t where col2 collate utf8_es_cs='abc')); 
select charset((select col1 from t where col2 collate utf8_es_cs='abc')); 

--session
set @a='a';
select coercibility(cast(@a as string collate binary));

drop variable @a;
drop t;
set names iso88591;

commit;

--+ holdcas off;
