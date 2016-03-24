set system parameters 'unicode_output_normalization=yes';

set names utf8;

drop table if exists t1;


--success
create table t1 (
	i1 int auto_increment, 
	e1 enum('È', 'Ä', 'Ñ', 'Ö', 'Ü', 'ä', 'ñ', 'ö', 'ü'),
	e2 enum('È', 'Ä', 'Ñ', 'Ö', 'Ü', 'ä', 'ñ', 'ö', 'ü'),
	e3 enum('È', 'Ä', 'Ä', 'Ö', 'Ö', 'ñ', 'ñ', 'ü', 'ü'),
	s1 string
) collate utf8_bin;


insert into t1(e1, e2, e3, s1) values (1, 1, 1, 'È');
insert into t1(e1, e2, e3, s1) values (2, 2, 2, 'Ä');
insert into t1(e1, e2, e3, s1) values (3, 3, 3, 'Ñ');
insert into t1(e1, e2, e3, s1) values (4, 4, 4, 'Ö');
insert into t1(e1, e2, e3, s1) values (5, 5, 5, 'Ü');
insert into t1(e1, e2, e3, s1) values (6, 6, 6, 'ä');
insert into t1(e1, e2, e3, s1) values (7, 7, 7, 'ñ');
insert into t1(e1, e2, e3, s1) values (8, 8, 8, 'ö');
insert into t1(e1, e2, e3, s1) values (9, 9, 9, 'ü');


select * from t1 order by 1;



drop table t1;
set names iso88591;
set system parameters 'unicode_output_normalization=no';


