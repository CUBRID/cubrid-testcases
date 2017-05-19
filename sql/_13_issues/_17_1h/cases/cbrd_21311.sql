--+ holdcas on;

drop if exists tri_check_userid, [TRIGGER], [GRANT], [ALTER], [SELECT] ;
drop if exists [USER], t1, [ALL], [DESC], [SELECT] ;

create table [USER] (id int);
create trigger tri_check_userid before insert on [USER] if new.id < 0 execute REJECT;

create table t1 ( [USER] char ); 
create trigger [TRIGGER] before insert on t1 if new.USER < 0 execute REJECT;
create trigger [TRIGGER] before insert on t1 if new.USER < 0 execute REJECT;

create table [ALL] ( [COLUMN] CHAR ); 
CREATE TRIGGER [GRANT] BEFORE UPDATE ON [ALL] IF new.COLUMN < 0 EXECUTE REJECT;

ALTER TRIGGER tri_check_userid COMMENT '[USER]';

create table [DESC] ( [CHAR] CHAR ); 
create trigger [ALTER] before insert on [DESC] if new.CHAR < 0 execute REJECT;

RENAME TRIGGER tri_check_userid AS [SELECT];

select name,condition,action_type,action_definition,comment from db_trigger order by name;

drop if exists tri_check_userid, [TRIGGER], [GRANT], [ALTER], [SELECT] ;
drop if exists [USER], t1, [ALL], [DESC], [SELECT] ;


drop if exists [TABLE], [CLASS] ;
drop if exists [INSERT], [UPDATE], [DELETE] ;

CREATE TABLE [TABLE] ([COLUMN] INT UNIQUE);
INSERT INTO [TABLE] VALUES (11);

CREATE TABLE [CLASS] ([ATTRIBUTE] INT);

CREATE TRIGGER [INSERT] BEFORE INSERT ON [TABLE] EXECUTE INSERT INTO [CLASS] VALUES (1);
CREATE TRIGGER [UPDATE] BEFORE UPDATE ON [TABLE] EXECUTE INSERT INTO [CLASS] VALUES (2);
CREATE TRIGGER [DELETE] BEFORE DELETE ON [TABLE] EXECUTE INSERT INTO [CLASS] VALUES (3);

INSERT INTO [TABLE] VALUES (11) ON DUPLICATE KEY UPDATE [COLUMN]=22;
SELECT * FROM [CLASS];

REPLACE INTO [TABLE] VALUES (22);
SELECT * FROM [CLASS] order by 1;

select name,condition,action_type,action_definition,comment from db_trigger order by name;

drop if exists [TABLE], [CLASS] ;
drop if exists [INSERT], [UPDATE], [DELETE] ;



--+ holdcas off;
