--+ holdcas on;
--TEST: [I18N] CHARSET function doesn't support user-defined variables


set @v1='abc' collate iso88591_bin;
set @v2=_iso88591'def';

select charset(@v1);
select charset(@v2);
select charset(concat(@v1, @v2));

select collation(@v1);
select collation(@v2);
select collation(concat(@v1, @v2));

select coercibility(@v1);
select coercibility(@v2);
select coercibility(concat(@v1, @v2));
drop variable @v1,@v2;

--+ holdcas off;
