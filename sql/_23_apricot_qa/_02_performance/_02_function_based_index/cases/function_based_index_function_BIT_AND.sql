--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE bit_tbl(id int);
INSERT INTO bit_tbl VALUES (1), (2), (3), (4), (5);
--Test create index failed;
create index idx_id on bit_tbl(bit_and(id));
drop table bit_tbl ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
