autocommit off;
set names utf8;
create table test_lpad(
			lpad_1_1_k varchar(50) charset utf8,
			lpad_1_1_e varchar(50) charset utf8,
			lpad_1_6 varchar(50) charset utf8
);
insert into test_lpad (lpad_1_1_k,lpad_1_1_e,lpad_1_6) values ('얼렐레','ebebe ',' ')
			select lpad('얼렐레',-1) from test_lpad;
			select lpad('ebebe ',-1) from test_lpad;
			select lpad(lpad_1_1_k,-1) from test_lpad;
			select lpad(lpad_1_1_e,-1) from test_lpad;
			select lpad('얼렐레',0) from test_lpad; -- Return NULL.What about ''
			select lpad('ebebe ',0) from test_lpad;
			select lpad(lpad_1_1_k,0) from test_lpad;
			select lpad(lpad_1_1_e,0) from test_lpad;
			select lpad('얼렐레',3) from test_lpad;
			select lpad('ebebe ',3) from test_lpad;
			select lpad(lpad_1_1_k,3) from test_lpad;
			select lpad(lpad_1_1_e,3) from test_lpad;
			select lpad('얼렐레',6) from test_lpad;
			select lpad('ebebe ',6) from test_lpad;
			select lpad(lpad_1_1_k,6) from test_lpad;
			select lpad(lpad_1_1_e,6) from test_lpad;
			select lpad('얼렐레',10) from test_lpad;
			select lpad('ebebe ',10) from test_lpad;
			select lpad(lpad_1_1_k,10) from test_lpad;
			select lpad(lpad_1_1_e,10) from test_lpad;
			select lpad(' ',-1) from test_lpad;
			select lpad(' ',0) from test_lpad;
			select lpad(' ',1) from test_lpad;
			select lpad(' ',2) from test_lpad;
			select lpad(lpad_1_6,-1) from test_lpad;
			select lpad(lpad_1_6,0) from test_lpad;
			select lpad(lpad_1_6,1) from test_lpad;
			select lpad(lpad_1_6,2) from test_lpad;
			select lpad('얼렐레',-1,'요') from test_lpad;
			select lpad('ebebe ',-1,'y') from test_lpad;
			select lpad(lpad_1_1_k,-1,'요') from test_lpad;
			select lpad(lpad_1_1_e,-1,'y') from test_lpad;
			select lpad('얼렐레',-1,'이요') from test_lpad;
			select lpad('ebebe ',-1,'ya') from test_lpad;
			select lpad(lpad_1_1_k,-1,'이요') from test_lpad;
			select lpad(lpad_1_1_e,-1,'ya') from test_lpad;
			select lpad('얼렐레',0,'요') from test_lpad;
			select lpad('ebebe ',0,'y') from test_lpad;
			select lpad(lpad_1_1_k,0,'요') from test_lpad;
			select lpad(lpad_1_1_e,0,'y') from test_lpad;
			select lpad('얼렐레',0,'이요') from test_lpad;
			select lpad('ebebe ',0,'ya') from test_lpad;
			select lpad(lpad_1_1_k,0,'이요') from test_lpad;
			select lpad(lpad_1_1_e,0,'ya') from test_lpad;
			select lpad('얼렐레',3,'요') from test_lpad;
			select lpad('ebebe ',3,'y') from test_lpad;
			select lpad(lpad_1_1_k,3,'요') from test_lpad;
			select lpad(lpad_1_1_e,3,'y') from test_lpad;
			select lpad('얼렐레',3,'이요') from test_lpad;
			select lpad('ebebe ',3,'ya') from test_lpad;
			select lpad(lpad_1_1_k,3,'이요') from test_lpad;
			select lpad(lpad_1_1_e,3,'ya') from test_lpad;
			select lpad('얼렐레',6,'요') from test_lpad;
			select lpad('ebebe ',6,'y') from test_lpad;
			select lpad(lpad_1_1_k,6,'요') from test_lpad;
			select lpad(lpad_1_1_e,6,'y') from test_lpad;
			select lpad('얼렐레',6,'이요') from test_lpad;
			select lpad('ebebe ',6,'ya') from test_lpad;
			select lpad(lpad_1_1_k,6,'이요') from test_lpad;
			select lpad(lpad_1_1_e,6,'ya') from test_lpad;
			select lpad('얼렐레',10,'요') from test_lpad;
			select lpad('ebebe ',10,'y') from test_lpad;
			select lpad(lpad_1_1_k,10,'요') from test_lpad;
			select lpad(lpad_1_1_e,10,'y') from test_lpad;
			select lpad('얼렐레',10,'이요') from test_lpad;
			select lpad('ebebe ',10,'ya') from test_lpad;
			select lpad(lpad_1_1_k,10,'이요') from test_lpad;
			select lpad(lpad_1_1_e,10,'ya') from test_lpad;
create table test_lpad_table(
    c1 varchar(50) charset utf8,
    i2 integer,
    c3 varchar(50) charset utf8,
    i4 integer,
    c5 varchar(50) charset utf8
);
insert into test_lpad_table (c1,i2,c3) values('Choikonghun',24,'최');
			SELECT c1, 24, lpad(c1,24) FROM test_lpad_table;
			SELECT 'Choikonghun',i2, lpad('Choikonghun',i2) FROM test_lpad_table;
			SELECT c1, i2, lpad(c1,i2) FROM test_lpad_table;
			SELECT c1, 24, c3, lpad(c1,24,c3) FROM test_lpad_table;
			SELECT 'Choikonghun',i2, c3, lpad('Choikonghun',i2,c3) FROM test_lpad_table;
			SELECT c1, i2, '최', lpad(c1,i2,'최') FROM test_lpad_table;
			SELECT 'Choikonghun',24,c3, lpad('Choikonghun',24,c3) FROM test_lpad_table;
			SELECT 'Choikonghun',i2,'최', lpad('Choikonghun',i2,'최') FROM test_lpad_table;
			SELECT c1,24,'최', lpad(c1,24,'최') FROM test_lpad_table;
			select lpad('',2,'') FROM test_lpad;
			select lpad('',2,'c') FROM test_lpad;
			select lpad('c',2,'') FROM test_lpad;
			SELECT c5,24, lpad(c5,24) FROM test_lpad_table;
			SELECT 'Choikonghun',i4, lpad('Choikonghun',i4) FROM test_lpad_table;
			SELECT c5, i4, lpad(c5,i4) FROM test_lpad_table;
			SELECT c5,24,c5, lpad(c5,24,c5) FROM test_lpad_table;
			SELECT 'Choikonghun',i4,c5, lpad('Choikonghun',i4,c5) FROM test_lpad_table;
			SELECT c5,i4,'최', lpad(c5,i4,'최') FROM test_lpad_table;
			SELECT 'Choikonghun',24,c5, lpad('Choikonghun',24,c5) FROM test_lpad_table;
			SELECT 'Choikonghun',i4,'최', lpad('Choikonghun',i4,'최') FROM test_lpad_table;
			SELECT c5,24,'최', lpad(c5,24,'최') FROM test_lpad_table;
			select lpad(NULL,NULL) from test_lpad;
			select lpad(NULL,NULL,NULL) from test_lpad;
drop table test_lpad;
drop table test_lpad_table;
set names iso88591;
rollback;
