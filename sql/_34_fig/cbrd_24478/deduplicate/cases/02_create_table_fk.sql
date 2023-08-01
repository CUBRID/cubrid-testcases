-- SET WITH DEDUPLICATE OPTION TO SHOW
set system parameters 'print_index_detail=y';

set system parameters 'deduplicate_key_level=-1';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=1 REFERENCES [dba.t_parent]([id])
);

set system parameters 'deduplicate_key_level=1';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) REFERENCES [dba.t_parent]([id])
);
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=3';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=3 REFERENCES [dba.t_parent]([id])
);
SHOW CREATE TABLE [t_child];

-- SET WITH DEDUPLICATE OPTION TO HIDE
set system parameters 'print_index_detail=n';

set system parameters 'deduplicate_key_level=5';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) REFERENCES [dba.t_parent]([id])
);
SHOW CREATE TABLE [t_child];

set system parameters 'deduplicate_key_level=7';
DROP TABLE IF EXISTS [t_child];
CREATE TABLE [t_child] (
[id] INTEGER NOT NULL PRIMARY KEY,
[pid] INTEGER NOT NULL,
[val] CHARACTER VARYING(1) DEFAULT 'N',
CONSTRAINT [fk_t_child_parent_pid] FOREIGN KEY ([pid]) WITH DEDUPLICATE=7 REFERENCES [dba.t_parent]([id])
);
SHOW CREATE TABLE [t_child];
