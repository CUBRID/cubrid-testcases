/*
 * This is a test case to verify the CBRD-24388 issue.
 *
 * Verify the error message change when generating foreign keys,
 * such as datatype, charset, collation, charset & collation.
 *
 */

/* data type */
drop table if exists tf1;
drop table if exists tf2;
drop table if exists tf3;
drop table if exists tf4;
drop table if exists tbl;

create table tbl (id char(3) not null  PRIMARY KEY); 
-- table_constraint
create table tf1 (f_id varchar(3), foreign key (f_id) references tbl(id) on delete cascade ); 
create table tf2 (f_id int, foreign key (f_id) references tbl(id) on delete cascade ); 
-- column_constraint
create table tf3 (f_id varchar(3) references tbl on delete cascade ); 
create table tf4 (f_id int references tbl on delete cascade ); 

drop table tf1;
drop table tf2;
drop table tf3;
drop table tf4;
drop table tbl;


/* charset */ 
create table tbl (id char(3) not null  PRIMARY KEY) charset euckr;
-- table_constraint
create table tf1 (f_id char(3), foreign key (f_id) references tbl(id) on delete cascade ) charset utf8;
-- column_constraint
create table tf2 (f_id char(3) references tbl) charset utf8;

drop table tf1;
drop table tf2;
drop table tbl;


/* collation  */
create table tbl (id char(3) not null  PRIMARY KEY) collate utf8_en_cs;
-- table_constraint
create table tf1 (f_id char(3), foreign key (f_id) references tbl(id) on delete cascade ) collate euckr_bin;
create table tf2 (f_id char(3), foreign key (f_id) references tbl(id) on delete cascade ) collate utf8_bin;
-- column_constraint
create table tf3 (f_id char(3) references tbl) collate utf8_en_ci;

drop table tf1;
drop table tf2;
drop table tf3;
drop table tbl;


/* charset & collation  */
drop table if exists tf1, tf2, tf3, tf4, tbl;
create table tbl (id char(3) not null  PRIMARY KEY) charset utf8 collate utf8_en_cs;
-- table_constraint
create table tf1 (f_id char(3), foreign key (f_id) references tbl(id) on delete cascade ) charset utf8 collate utf8_bin;
create table tf2 (f_id char(3), foreign key (f_id) references tbl(id) on delete cascade ) charset utf8 collate utf8_en_ci;
-- column_constraint
create table tf3 (f_id char(3) references tbl) charset iso88591 collate iso88591_bin;

drop table tf1;
drop table tf2;
drop table tf3;
drop table tf4;
drop table tbl;
