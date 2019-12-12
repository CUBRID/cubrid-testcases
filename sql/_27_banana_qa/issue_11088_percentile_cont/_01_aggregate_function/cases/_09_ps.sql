--TEST: test with prepared statements with the function

drop table if exists p_cont;
create table p_cont(
	col1 int auto_increment primary key,
	col2 smallint,
	col3 char(30) default 'abc',
	col4 date default SYSDATE,
	col5 clob
);


insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', '1990-10-10', null);
insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', null, 'bello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(null, 'mysql', '1990-10-11', 'cello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(508, null, '1990-10-10', 'dello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(500, 'cubrid', '1991-10-10', 'eello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(501, 'oracle', '1990-10-10', 'fello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(501, 'cubrid', '1992-10-10', 'gello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(null, 'oracle', '1990-11-10', 'hello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(501, null, '1990-10-10', 'iello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(507, 'cubrid', '1990-10-10', null);
insert into p_cont(col2, col3, col4, col5) values(501, 'mysql', null, 'kello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(502, 'cubrid', '1990-10-10', 'lello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(502, 'mysql', '1990-10-10', 'mello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(null, 'mysql', '1992-10-10', 'nello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(503, 'mysql', '1992-10-10', 'oello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(503, 'cubrid', '1990-10-10', 'pello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(513, 'cubrid', '1990-10-10', null);
insert into p_cont(col2, col3, col4, col5) values(503, null, '1993-11-10', 'rello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(null, 'oracle', null, 'sello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(503, 'cubrid', '1993-11-10', 'tello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(522, 'cubrid', '1992-10-10', 'uello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(504, 'mysql', '1994-10-10', 'vello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(534, 'mysql', '1990-10-10', null);
insert into p_cont(col2, col3, col4, col5) values(null, 'cubrid', '1995-11-10', 'wello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(505, null, null, '');
insert into p_cont(col2, col3, col4, col5) values(505, 'cubrid', '1996-10-10', 'xello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(585, 'mysql', '1990-10-10', 'yello@domainname.com');
insert into p_cont(col2, col3, col4, col5) values(505, 'cubrid', '1995-10-10', null);
insert into p_cont(col2, col3, col4, col5) values(575, 'cubrid', '1990-10-10', 'zello@domainname.com');


--test: 
prepare st from 'select percentile_cont(?) within group (order by col1 asc) p_cont from p_cont order by 1';
execute st using 0;
execute st using 0.5;
execute st using 1;
execute st using 5;
execute st using -10;
deallocate prepare st;

prepare st from 'select col2, col3, percentile_cont(?) within group (order by col1 desc) p_cont from p_cont where col1 < ? group by col2, col3 order by 1, 2, 3';
execute st using 0.2, 20;
execute st using 0.99, 15;
execute st using 0.45, 10;
execute st using 10, 10;
deallocate prepare st;

prepare st from 'select col4, percentile_cont(?) within group (order by col2 desc) p_cont from p_cont group by col4 order by 1, 2 limit ?';
execute st using 0.8, 10;
execute st using 1, 1;
deallocate prepare st;

prepare st from 'select clob_to_char(col5), percentile_cont(?) within group (order by col3 asc) p_cont from p_cont group by clob_to_char(col5) having year(col4) > ? order by 1, 2';
execute st using 0.3, 1993;
execute st using 0, 1991;
deallocate prepare st;

prepare st from 'select col3, percentile_cont(?) within group (order by col4 desc) p_cont from p_cont group by col3 order by 1, 2 limit ?';
execute st using 0.77, 100;
deallocate prepare st;

prepare st from 'select col2, col3, col4, percentile_cont(round(?, ?)) within group (order by ? asc) p_cont from p_cont group by col2, col3, col4 order by 1, 2, 3, 4';
execute st using 0.999, 2, 2;
execute st using 1.333, 0, 2;
deallocate prepare st;

--test: [er] pass 2 arguments to both the first and the second param
prepare st from 'select percentile_cont(?, ?) within group (order by col1, col2 desc) p_cont from p_cont;';
execute st using 0.5, 0.5;
deallocate prepare st;


drop table p_cont;
