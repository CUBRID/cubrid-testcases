-- SET WITH DEDUPLICATE OPTION TO SHOW 
set system parameters 'print_index_detail=y';
set system parameters 'deduplicate_key_level=-1';

DROP TABLE IF EXISTS [t_parent];
CREATE TABLE [t_parent] (
[id] INTEGER NOT NULL PRIMARY KEY,
[val] CHARACTER VARYING(1) DEFAULT 'N',
INDEX [ix_val_de00] ([val]) WITH DEDUPLICATE=1);
SHOW CREATE TABLE [t_parent];

DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=1 REFERENCES [t_parent]([id])
);
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=0';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=1 REFERENCES [t_parent]([id])
);
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=3';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N'
);
ALTER TABLE [t_child] ADD CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) REFERENCES [t_parent]([id]);
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=3';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N'
);
ALTER TABLE [t_child] ADD CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=3 REFERENCES [t_parent]([id]);
SHOW CREATE TABLE [t_child];
ALTER TABLE [t_child] DROP CONSTRAINT [fk_t_child_parent_pid];
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=5';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N'
);
ALTER TABLE [t_child] ADD CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=5 REFERENCES [t_parent]([id]);
ALTER TABLE [t_child] ADD UNIQUE INDEX [ux_pid]([pid]); -- Fail
ALTER TABLE [t_child] ADD UNIQUE INDEX [ux_pid]([pid] DESC);
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=7';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N'
);
ALTER TABLE [t_child] ADD UNIQUE INDEX [ux_pid]([pid]);
ALTER TABLE [t_child] ADD CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=7 REFERENCES [t_parent]([id]);
ALTER TABLE [t_child] ADD INDEX [mx_id_val_de07]([id],[val]) WITH DEDUPLICATE=7;
ALTER TABLE [t_child] ADD INDEX [mx_id_val_de00]([id],[val]) WITH DEDUPLICATE=9; -- Fail
ALTER TABLE [t_child] ADD INDEX [mx_pid_val_de07]([pid],[val]) WITH DEDUPLICATE=7;
ALTER TABLE [t_child] ADD INDEX [mx_pid_val_de00]([pid],[val]) WITH DEDUPLICATE=9; -- Fail
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=13';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N'
);
ALTER TABLE [t_child] ADD UNIQUE INDEX [ux_pid]([pid]);
ALTER TABLE [t_child] ADD CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=9 REFERENCES [t_parent]([id]);
ALTER TABLE [t_child] DROP UNIQUE INDEX [ux_pid];
ALTER TABLE [t_child] ADD INDEX [mx_pid_val_de09]([pid],[val]) WITH DEDUPLICATE=9;
SHOW CREATE TABLE [t_child];

CREATE TABLE [t_child2] LIKE [t_child];
SHOW CREATE TABLE [t_child2];

DROP TABLE IF EXISTS [t_child2], [t_child], [t_parent];
set system parameters 'deduplicate_key_level=-1';
set system parameters 'print_index_detail=n';
