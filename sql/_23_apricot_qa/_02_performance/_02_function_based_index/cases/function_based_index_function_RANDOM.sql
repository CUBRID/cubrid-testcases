--+ holdcas on;
CREATE TABLE bit_tbl(id int);
INSERT INTO bit_tbl VALUES (1), (2), (3), (4), (5);
--Test create index failed;
create index idx_id on bit_tbl(RANDOM(id));
drop table bit_tbl ;

commit;
--+ holdcas off;
