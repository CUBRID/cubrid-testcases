-- SET WITH DEDUPLICATE OPTION TO HIDE
set system parameters 'print_index_detail=n';
set system parameters 'deduplicate_key_level=-1';

CREATE TABLE [t_parent] (
[id] INTEGER NOT NULL PRIMARY KEY, 
[val] CHARACTER VARYING(1) DEFAULT 'N',  
INDEX [ix_val_de00] ([val]) WITH DEDUPLICATE=2);
SHOW CREATE TABLE [t_parent];

set system parameters 'deduplicate_key_level=0';
DROP TABLE IF EXISTS [t_parent];
CREATE TABLE [t_parent] (
[id] INTEGER NOT NULL PRIMARY KEY, 
[val] CHARACTER VARYING(1) DEFAULT 'N',  
INDEX [ix_val_de02] ([val]) WITH DEDUPLICATE=2);
SHOW CREATE TABLE [t_parent];

set system parameters 'deduplicate_key_level=4';
DROP TABLE IF EXISTS [t_parent];
CREATE TABLE [t_parent] (
[id] INTEGER NOT NULL PRIMARY KEY, 
[val] CHARACTER VARYING(1) DEFAULT 'N',  
INDEX [ix_val_de04] ([val]));
SHOW CREATE TABLE [t_parent];

set system parameters 'deduplicate_key_level=6';
DROP TABLE IF EXISTS [t_parent];
CREATE TABLE [t_parent] (
[id] INTEGER NOT NULL PRIMARY KEY, 
[val] CHARACTER VARYING(1) DEFAULT 'N',  
UNIQUE INDEX [ux_val] ([val]));
SHOW CREATE TABLE [t_parent];

SHOW CREATE TABLE [t_parent];

DROP TABLE IF EXISTS [t_parent2];
CREATE TABLE [t_parent2] LIKE [t_parent];
SHOW CREATE TABLE [t_parent2];

DROP TABLE IF EXISTS [t_parent2],[t_parent];
set system parameters 'deduplicate_key_level=-1';
