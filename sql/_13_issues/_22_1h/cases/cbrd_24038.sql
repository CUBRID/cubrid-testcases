DROP TABLE IF EXISTS alter_t;
CREATE TABLE alter_t (
	col1 int not null default 1,
	col2 varchar(10) comment 'alter comment',
	col3 int auto_increment,
	col4 date on update sys_date,
	col5 date not null
);

INSERT INTO alter_t(col2, col5) VALUES ('First', '2022-03-01');
SELECT * FROM alter_t;
UPDATE alter_t SET col4 = '2022-03-01';
SELECT * FROM alter_t;
SHOW COLUMNS FROM alter_t;

-- case 1: default property not changed
ALTER TABLE alter_t MODIFY col1 INTEGER comment 'Key Field';
-- DEFAULT property is not changed for ALTER TABLE MODIFY command
SHOW COLUMNS FROM alter_t;

-- case 2: comment property is not changed by ALTER MODIFY ... DEFAULT
ALTER TABLE alter_t MODIFY col2 varchar(12) DEFAULT 'value';
SHOW COLUMNS FROM alter_t;
ALTER TABLE alter_t CHANGE col2 col_def VARCHAR(12);
-- the default property is not changed by the ALTER CHANGE column def
SHOW COLUMNS FROM alter_t;

-- case 3: default property can be dropped by ALTER MODIFY/CHANGE DEFAULT NULL
ALTER TABLE alter_t CHANGE col_def col2 VARCHAR(16) DEFAULT NULL;
-- the default value property is dropped
SHOW COLUMNS FROM alter_t;

-- case 4: auto_increment property can be dropped by any ALTER command
ALTER TABLE alter_t CHANGE col3 col_big BIGINT COMMENT 'auto inc';
-- the auto_increment property is not dropped
SHOW COLUMNS FROM alter_t;

ALTER TABLE alter_t CHANGE col_big col3 INTEGER COMMENT '';
-- the auto_increment property is not dropped
SHOW COLUMNS FROM alter_t;

-- case 5: NOT NULL property can be dropped by ALTER ... NULL
ALTER TABLE alter_t MODIFY col4 DATE NOT NULL;
-- NOT NULL property is added but ON UPDATE property is not dropped
SHOW COLUMNS FROM alter_t;
ALTER TABLE alter_t MODIFY col4 DATE NULL;
-- NOT NULL property is dropped but ON UPDATE property is not dropped
SHOW COLUMNS FROM alter_t;
	
DROP TABLE alter_t;
