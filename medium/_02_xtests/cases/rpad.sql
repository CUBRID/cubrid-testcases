autocommit off;
set names utf8;
create table test_rpad(
			rpad_1_1_k varchar(50) charset utf8,
			rpad_1_1_e varchar(50) charset utf8,
			rpad_1_6 varchar(50) charset utf8
);
insert into test_rpad (rpad_1_1_k,rpad_1_1_e,rpad_1_6) values ('얼렐레','ebebe ',' ')
			select rpad('얼렐레',-1) from test_rpad;
			select rpad('ebebe ',-1) from test_rpad;
			select rpad(rpad_1_1_k,-1) from test_rpad;
			select rpad(rpad_1_1_e,-1) from test_rpad;
			select rpad('얼렐레',0) from test_rpad;
			select rpad('ebebe ',0) from test_rpad;
			select rpad(rpad_1_1_k,0) from test_rpad;
			select rpad(rpad_1_1_e,0) from test_rpad;
			select rpad('얼렐레',3) from test_rpad;
			select rpad('ebebe ',3) from test_rpad;
			select rpad(rpad_1_1_k,3) from test_rpad;
			select rpad(rpad_1_1_e,3) from test_rpad;
			select rpad('얼렐레',6) from test_rpad;
			select rpad('ebebe ',6) from test_rpad;
			select rpad(rpad_1_1_k,6) from test_rpad;
			select rpad(rpad_1_1_e,6) from test_rpad;
			select rpad('얼렐레',10) from test_rpad;
			select rpad('ebebe ',10) from test_rpad;
			select rpad(rpad_1_1_k,10) from test_rpad;
			select rpad(rpad_1_1_e,10) from test_rpad;
			select rpad(' ',-1) from test_rpad;
			select rpad(' ',0) from test_rpad;
			select rpad(' ',1) from test_rpad;
			select rpad(' ',2) from test_rpad;
			select rpad(rpad_1_6,-1) from test_rpad;
			select rpad(rpad_1_6,0) from test_rpad;
			select rpad(rpad_1_6,1) from test_rpad;
			select rpad(rpad_1_6,2) from test_rpad;
			select rpad('얼렐레',-1,'요') from test_rpad;
			select rpad('ebebe ',-1,'y') from test_rpad;
			select rpad(rpad_1_1_k,-1,'요') from test_rpad;
			select rpad(rpad_1_1_e,-1,'y') from test_rpad;
			select rpad('얼렐레',-1,'이요') from test_rpad;
			select rpad('ebebe ',-1,'ya') from test_rpad;
			select rpad(rpad_1_1_k,-1,'이요') from test_rpad;
			select rpad(rpad_1_1_e,-1,'ya') from test_rpad;
			select rpad('얼렐레',0,'요') from test_rpad;
			select rpad('ebebe ',0,'y') from test_rpad;
			select rpad(rpad_1_1_k,0,'요') from test_rpad;
			select rpad(rpad_1_1_e,0,'y') from test_rpad;
			select rpad('얼렐레',0,'이요') from test_rpad;
			select rpad('ebebe ',0,'ya') from test_rpad;
			select rpad(rpad_1_1_k,0,'이요') from test_rpad;
			select rpad(rpad_1_1_e,0,'ya') from test_rpad;
			select rpad('얼렐레',3,'요') from test_rpad;
			select rpad('ebebe ',3,'y') from test_rpad;
			select rpad(rpad_1_1_k,3,'요') from test_rpad;
			select rpad(rpad_1_1_e,3,'y') from test_rpad;
			select rpad('얼렐레',3,'이요') from test_rpad;
			select rpad('ebebe ',3,'ya') from test_rpad;
			select rpad(rpad_1_1_k,3,'이요') from test_rpad;
			select rpad(rpad_1_1_e,3,'ya') from test_rpad;
			select rpad('얼렐레',6,'요') from test_rpad;
			select rpad('ebebe ',6,'y') from test_rpad;
			select rpad(rpad_1_1_k,6,'요') from test_rpad;
			select rpad(rpad_1_1_e,6,'y') from test_rpad;
			select rpad('얼렐레',6,'이요') from test_rpad;
			select rpad('ebebe ',6,'ya') from test_rpad;
			select rpad(rpad_1_1_k,6,'이요') from test_rpad;
			select rpad(rpad_1_1_e,6,'ya') from test_rpad;
			select rpad('얼렐레',10,'요') from test_rpad;
			select rpad('ebebe ',10,'y') from test_rpad;
			select rpad(rpad_1_1_k,10,'요') from test_rpad;
			select rpad(rpad_1_1_e,10,'y') from test_rpad;
			select rpad('얼렐레',10,'이요') from test_rpad;
			select rpad('ebebe ',10,'ya') from test_rpad;
			select rpad(rpad_1_1_k,10,'이요') from test_rpad;
			select rpad(rpad_1_1_e,10,'ya') from test_rpad;
create table test_rpad_table(
    c1 varchar(50) charset utf8,
    i2 integer,
    c3 varchar(50) charset utf8,
    i4 integer,
    c5 varchar(50) charset utf8
);
insert into test_rpad_table (c1,i2,c3) values('Choikonghun',24,'최');
			SELECT c1, 24, rpad(c1,24) FROM test_rpad_table;
			SELECT 'Choikonghun',i2, rpad('Choikonghun',i2) FROM test_rpad_table;
			SELECT c1, i2, rpad(c1,i2) FROM test_rpad_table;
			SELECT c1, 24, c3, rpad(c1,24,c3) FROM test_rpad_table;
			SELECT 'Choikonghun',i2, c3, rpad('Choikonghun',i2,c3) FROM test_rpad_table;
			SELECT c1, i2, '최', rpad(c1,i2,'최') FROM test_rpad_table;
			SELECT 'Choikonghun',24,c3, rpad('Choikonghun',24,c3) FROM test_rpad_table;
			SELECT 'Choikonghun',i2,'최', rpad('Choikonghun',i2,'최') FROM test_rpad_table;
			SELECT c1,24,'최', rpad(c1,24,'최') FROM test_rpad_table;
			select rpad('',2,'') FROM test_rpad;
			select rpad('',2,'c') FROM test_rpad;
			select rpad('c',2,'') FROM test_rpad;
			SELECT c5,24, rpad(c5,24) FROM test_rpad_table;
			SELECT 'Choikonghun',i4, rpad('Choikonghun',i4) FROM test_rpad_table;
			SELECT c5, i4, rpad(c5,i4) FROM test_rpad_table;
			SELECT c5,24,c5, rpad(c5,24,c5) FROM test_rpad_table;
			SELECT 'Choikonghun',i4,c5, rpad('Choikonghun',i4,c5) FROM test_rpad_table;
			SELECT c5,i4,'최', rpad(c5,i4,'최') FROM test_rpad_table;
			SELECT 'Choikonghun',24,c5, rpad('Choikonghun',24,c5) FROM test_rpad_table;
			SELECT 'Choikonghun',i4,'최', rpad('Choikonghun',i4,'최') FROM test_rpad_table;
			SELECT c5,24,'최', rpad(c5,24,'최') FROM test_rpad_table;
			select rpad(NULL,NULL) from test_rpad;
			select rpad(NULL,NULL,NULL) from test_rpad;
drop table test_rpad;
drop table test_rpad_table;
set names iso88591;
rollback;
