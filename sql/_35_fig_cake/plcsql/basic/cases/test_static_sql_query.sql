--+ server-message on

drop table if exists history;
create table history(event_code int, name varchar(40),host_year varchar(20),score int,unit varchar(20));

create or replace procedure create_history_data () as 
begin
    insert into history values(20263,'Phelps Michael', 2004,'51.25',   'time'              );
    insert into history values(20259,'Peirsol Aaron',2004 , '53.45',   'time'              );
    insert into history values(20267,'Hackett Grant',2004  , '14.43', 'time'              );
    insert into history values(20284,'Thorpe Ian',   2000 , '03.41', 'time'              );
    insert into history values(20274,'Thorpe Ian',   2004 , '01.45', 'time'              );
    insert into history values(20288,'Popov Alexander',1992,'21.91',   'time'              );
    insert into history values(20035,'Sebrle Roman', 2004 , '8893',    'score'             );
    insert into history values(20043,'Zelezny Jan',  2000 , '90.17',   'meter'             );
    insert into history values(20038,'Litvinov Sergey',1988,'84.8',    'meter'             );
    insert into history values(20036,'Alekna Virgilijus',        2004 , '69.89',   'meter' );
    insert into history values(20051,'Timmermann Ulf', 1988,'22.47',   'meter'             );
    insert into history values(20053,'Harrison Kenny', 1996,'18.09',   'meter'             );
    insert into history values(20049,'Mack Tim',     2004 , '5.95',    'meter'             );
    insert into history values(20045,'Bob Beamon',   1968 , '8.9',     'meter'             );
    insert into history values(20041,'Austin Charles', 1996, '2.39',    'meter'             );
    insert into history values(20031,'Ivanenko Viacheslav',       1988 , '3', 'time'  );
    insert into history values(20017,'Korzeniowski Robert',       2000 , '1.', 'time'  );
    insert into history values(20023,'Lewis Steve',  1992 , '2.56', 'time'              );
    insert into history values(20023,'Johnson Michael',1992,'2.56', 'time'              );
    insert into history values(20023,'Watts Quincy', 1992 , '2.56', 'time'              );
    insert into history values(20023,'Valmon Andrew',1992,  '2.56', 'time'              );
    insert into history values(20021,'Lewis Carl',   1992 , '37.4',    'time'              );
    insert into history values(20021,'Mitchell Dennis',1992,'37.4',    'time'              );
    insert into history values(20021,'Burrell Leroy',1992,  '37.4',    'time'              );
    insert into history values(20021,'Marsh Michael',1992,  '37.4',    'time'              );
    insert into history values(20020,'Kariuki Julius', 1988,'08.06', 'time'              );
    insert into history values(20027,'Young Kevin',  1992,  '46.78',   'time'              );
    insert into history values(20010,'Liu Xiang',   2004,  '12.91',   'time'              );
    insert into history values(20047,'Lopes Carlos', 1984,  '2', 'time'              );
    insert into history values(20006,'Bekele Kenenisa',2004,'27.05', 'time'              );
    insert into history values(20029,'Aouita Said',  1984,  '13.06', 'time'              );
    insert into history values(20012,'Ngeny Noah',   2000,  '03.32', 'time'              );
    insert into history values(20032,'Rodal Vebjorn',1996,  '01.43', 'time'              );
    insert into history values(20025,'Johnson Michael',1996,'43.49',   'time'              );
    insert into history values(20015,'Johnson Michael',1996,'19.32',   'time'              );
    insert into history values(20008,'Bailey Donovan', 1996,'9.84',    'time'              );
    insert into history values(20024,'Bryzgina Olga',1988,  '03.15', 'time'              );
    insert into history values(20024,'Pinigina Mariya',1988,'03.15', 'time'              );
    insert into history values(20024,'Nazarova Olga',1988,  '03.15', 'time'              );
    insert into history values(20024,'Ledovskaya Tatyana',       1988,  '03.15', 'time'  );
    insert into history values(20022,'Gohr Marlies', 1980,  '41.6',    'time'              );
    insert into history values(20022,'Wokel Barbel', 1980,  '41.6',    'time'              );
    insert into history values(20022,'Muller Romy',  1980,  '41.6',    'time'              );
    insert into history values(20028,'Halkia Fani',  2004,  '52.77',   'time'              );
    insert into history values(20005,'Hayes Joanna', 2004,  '12.37',   'time'              );
    insert into history values(20048,'Takahashi Naoko',2000,'2.23', 'time'    );
end;

CALL create_history_data ();

create or replace function test_query_single_row_const(s int) return int as 
    c int;
    m varchar;
begin
    select event_code, name INTO c, m from history where unit = 'meter' and score > s;
    return c;
exception
when no_data_found then
    return 0;
when too_many_rows then
    return -1;
when others then
    return -999;
end;

SELECT test_query_single_row_const (1);
SELECT test_query_single_row_const (90);
SELECT test_query_single_row_const ('90');
SELECT test_query_single_row_const ('abc');

create or replace function test_query_single_row() return string as
    u char(5) := 'meter';
    n int := 18.09;

    m varchar;
begin
    select name INTO m from history where unit = u and score = n;
    return m;
exception
when no_data_found then
    return 'no_data_found';
when too_many_rows then
    return 'too_many_rows';
when others then
    return 'others';
end;

SELECT test_query_single_row ();

create or replace function test_query_cursor_simple_nocond() return int as
i int;
begin
    i := 0;
    for r in (select event_code, name from history) loop
        i := r.event_code;
        EXIT;
    end loop;

    return i;
end;

create or replace function test_query_cursor_simple() return int as
i int;
begin
    i := 0;
    for r in (select event_code, name from history where unit = 'time' and score = '03.15') loop
        i := r.event_code;
        EXIT;
    end loop;

    return i;
end;

select test_query_cursor_simple_nocond ();
select test_query_cursor_simple ();

create or replace function test_query_cursor_hostvar() return varchar as
    g char(4) := 'time';
    s char(4) := '10';

    i int;
    m varchar;
begin
    i := 0;
    for r in (select event_code, name from history where unit = g and score > s) loop
        i := r.event_code;
        m := r.name;
        DBMS_OUTPUT.put_line('code = ' || i || ' name = ' || m);
    end loop;

    return m;
exception
when no_data_found then
    return 'no_data';
when too_many_rows then
    return 'too_many';
when others then
    return 'others';
end;

select test_query_cursor_hostvar ();

DROP TABLE history;
DROP FUNCTION 
test_query_cursor_hostvar, 
test_query_cursor_simple, 
test_query_cursor_simple_nocond, 
test_query_single_row, 
test_query_single_row_const;

DROP PROCEDURE create_history_data;
