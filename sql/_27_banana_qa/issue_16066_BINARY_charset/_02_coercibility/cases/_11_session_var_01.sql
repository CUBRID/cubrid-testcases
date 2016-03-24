--+ holdcas on;

set names binary;
set @v1='abc' collate binary;
set @v2=_binary'def';

select charset(@v1);
select charset(@v2);
-- expect binary, CUBRIDSUS-17853
select charset(concat(@v1, @v2));

select collation(@v1);
select collation(@v2);
-- expect binary, CUBRIDSUS-17853
select collation(concat(@v1, @v2));

select coercibility(@v1);
select coercibility(@v2);
-- expect coercibility is 5, CUBRIDSUS-17853
select coercibility(concat(@v1, @v2));
drop variable @v1,@v2;

commit;
--+ holdcas off;
