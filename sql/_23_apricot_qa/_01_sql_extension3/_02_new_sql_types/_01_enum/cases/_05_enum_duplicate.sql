--duplicate values in definition


--TEST: error, duplicate values in definition
create table dup (
	col enum('aaa', 'bbb', 'ccc', 'ddd', 'aaa')
);


drop table if exists dup;
--TEST: duplicate values in definition, case sensitiveness
create table dup (
        col enum('aaa', 'bbb', 'ccc', 'ddd', 'AAA', 'BBB')
);


drop table if exists dup;
