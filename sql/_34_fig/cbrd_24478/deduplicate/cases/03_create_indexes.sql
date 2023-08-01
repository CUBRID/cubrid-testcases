-- SET WITH DEDUPLICATE OPTION TO SHOW
set system parameters 'print_index_detail=y';

set system parameters 'deduplicate_key_level=9';
CREATE INDEX [ix_val_pid_de09] ON [t_child] ([val], [pid]);
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc  FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_de09';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_de09] ON [t_child];

set system parameters 'deduplicate_key_level=10';
CREATE INDEX [ix_val_pid_de10] ON [t_child] ([val] DESC, [pid]);
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc  FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_de10';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_de10] ON [t_child];

set system parameters 'deduplicate_key_level=11';
CREATE INDEX [ix_val_pid_de11] ON [t_child] ([val], [pid] DESC);
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc  FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_de11';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_de11] ON [t_child];

set system parameters 'deduplicate_key_level=12';
CREATE INDEX [ix_val_pid_de12] ON [t_child] ([val] DESC, [pid] DESC);
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc  FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_de12';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_de12] ON [t_child];

-- SET WITH DEDUPLICATE OPTION TO HIDE
set system parameters 'print_index_detail=n';

set system parameters 'deduplicate_key_level=13';
CREATE INDEX [ix_val_pid_de13] ON [t_child] (NVL([val],''), [pid] DESC);
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc, func FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_de13';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_de13] ON [t_child];

set system parameters 'deduplicate_key_level=14';
CREATE INDEX [ix_val_pid_de14] ON [t_child] ([val], [pid]) WHERE [val] = 'N';
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc, func, index_of.filter_expression FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_de14';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_de14] ON [t_child];

-- SET WITH DEDUPLICATE OPTION TO SHOW (OPTION WRONG)
set system parameters 'deduplicate_key_level=15';

-- CREATING INDEX WITH UNIQUE COLUMN ADD TO NOT HAVING DEDUPLICATE OPTION
CREATE INDEX [ix_val_pid_id_de14] ON [t_child] ([val], [pid] DESC, id) WHERE [val] = 'N';
;SC t_child
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc, func, index_of.filter_expression FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_id_de14';
SHOW CREATE TABLE [t_child];
DROP INDEX [ix_val_pid_id_de14] ON [t_child];
