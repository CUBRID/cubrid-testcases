-- reproduce bug chk for CBRD-24930
set system parameters 'print_index_detail=y';
set system parameters 'deduplicate_key_level=0';

drop table if exists tbl;

create table tbl(id int, uid int);
-- Error
create unique index ix_uid on tbl2(uid) with deduplicate=3;

drop table if exists tbl;
set system parameters 'deduplicate_key_level=-1';
set system parameters 'print_index_detail=n';
