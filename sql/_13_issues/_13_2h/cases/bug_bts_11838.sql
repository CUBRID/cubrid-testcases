--+ holdcas on;

select PERCENT_RANK(null,3) within group (order by score,score1)
from (select NULL score,'00001' score1 from db_root) S;

--+ holdcas off;
commit;
