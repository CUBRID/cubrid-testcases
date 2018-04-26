-- error
-- constraints, primary key on blob/clob column.
create class pk1 (a int, b blob primary key, c string); 
create class pk2 (a int, b clob primary key, c string); 
drop pk1;
drop pk2;

-- ok
-- constraints, primary key not on blob/clob column.
create class pk3 (a int primary key, b blob , c string); 
create class pk4 (a int primary key, b clob, c string); 
insert into pk3 values (1,bit_to_blob(X'aaabbb'),'abc');
insert into pk4 values (1,char_to_clob('aaabbb'),'abc');
select a,blob_to_bit(b),c from pk3 order by 1,2,3;
select a,clob_to_char(b),c from pk4 order by 1,2,3;
delete from  pk3;
delete from  pk4;
drop pk3;
drop pk4;



-- error
-- constraints, foreign key on blob/clob column.
create class fp1 (id blob primary key, title varchar(100), artist varchar(100));
create class ff1 (albumn blob, song varchar(255), foreign key (albumn) references fp1(id));
drop fp1;
drop ff1;

create class fp2 (id clob primary key, title varchar(100), artist varchar(100));
create class ff2 (albumn clob, song varchar(255), foreign key (albumn) references fp2(id));
drop fp2;
drop ff2;

-- ok
-- constraints, foreign key not on blob/clob column.
create class fp3 (id char(10) primary key, title varchar(100), artist blob);
create class ff3 (albumn char(10), dsk clob, song varchar(255), foreign key (albumn) references fp3(id));
insert into fp3 values ('1','title',bit_to_blob(X'111aaa'));
insert into ff3 values ('1',char_to_clob('dddeeesss'),'song');
select id,title,blob_to_bit(artist),albumn, clob_to_char(dsk), song from fp3,ff3 where fp3.id=ff3.albumn;
delete from ff3;
delete from fp3;
drop ff3;
drop fp3;

create class fp4 (id char(10) primary key, title varchar(100), artist clob);
create class ff4 (albumn char(10), dsk clob, song varchar(255), foreign key (albumn) references fp4(id));
insert into fp4 values ('1','title',char_to_clob('ccccaaaa'));
insert into ff4 values ('2',char_to_clob('xxxxxx'),'sssooonnnggg');
insert into ff4 values ('1',char_to_clob('xxxxxx'),'sssooonnnggg');
select id,title,blob_to_bit(artist),albumn, clob_to_char(dsk), song from fp4,ff4 where fp4.id=ff4.albumn;
delete from fp4;
delete from ff4;
delete from fp4;
drop ff4;
drop fp4;



-- error
-- constraints, shared on blob/clob column.
create class sh1 (name varchar(10), photo blob shared bit_to_blob(X'1020abc'));
create class sh2 (name varchar(10), photo clob shared char_to_clob('aaaaaaaaabbb'));
drop sh1;
drop sh2;

-- ok
-- constraints, shared not on blob/clob column.
create class sh3 (name varchar(10), photo blob,gender char(1) shared 'M');
create class sh4 (name varchar(10), photo clob,gender char(1) shared 'M');
insert into sh3(name,photo) values ('Joe',bit_to_blob(X'111aaaccc'));
insert into sh3 values ('Joe',bit_to_blob(X'111aaaccc'),'W');
insert into sh4(name,photo) values ('Joe',char_to_clob('zzz111aaaccc'));
insert into sh4 values ('Joe',char_to_clob('zzz111aaaccc'),'W');
select name, blob_to_bit(photo),gender from sh3 order by 1,2,3;
select name, clob_to_char(photo),gender from sh4 order by 1,2,3;
delete from sh3;
delete from sh4;
drop sh3;
drop sh4;



-- error
-- constraints, default on blob/clob column.
create class df1 (name varchar(10), photo blob default bit_to_blob(X'1020abc'));
create class df2 (name varchar(10), photo clob default char_to_clob('aaaaaaaaabbb'));
drop df1;
drop df2;

-- ok
-- constraints, default not on blob/clob column.
create class df3 (name varchar(10), photo blob,gender char(1) default 'M');
create class df4 (name varchar(10), photo clob,gender char(1) default 'M');
insert into df3 values ('Lucy',bit_to_blob(X'aaabbbccc'),'W');
insert into df3(name,photo) values ('Lily',bit_to_blob(X'1aaabbbccc'));
insert into df4 values ('Lucy',char_to_clob('aaabbbccc'),'W');
insert into df4(name,photo) values ('Lily',char_to_clob('1aaabbbccc'));
select name,blob_to_bit(photo),gender from df3 order by 1 desc;
select name,clob_to_char(photo),gender from df4 order by 1 desc;
delete from df3;
delete from df4;
drop df3;
drop df4;



-- error
-- constraints, 'not null' on blob/clob column.
create class nn1 (name varchar(10), photo blob not null);
create class nn2 (name varchar(10), photo clob not null);
drop nn1;
drop nn2;

-- ok
-- constraints, 'not null' not on blob/clob column.
create class nn3 (name varchar(10), photo blob, gender char(1) not null);
create class nn4 (name varchar(10), photo clob, gender char(1) not null);
insert into nn3 values ('nn', bit_to_blob(X'aabbcc'),'M');
insert into nn3(name,photo,gender) values ('nn',bit_to_blob(X'aaccbb'),null);
insert into nn3(name,photo) values ('nn',bit_to_blob(X'aaccbb'));
insert into nn4 values ('nn', char_to_clob('aabbcc'),'M');
insert into nn4(name,photo,gender) values ('nn',char_to_clob('aaccbb'),null);
insert into nn4(name,photo) values ('nn',char_to_clob('aaccbb'));
select name, blob_to_bit(photo),gender from nn3 order by 1,2,3;
select name, clob_to_char(photo),gender from nn4 order by 1,2,3;
delete from nn3;
delete from nn4;
drop nn3;
drop nn4;



-- error 
-- constraints, unique on blob/clob column.
create class un1 (name varchar(10), photo blob, gender char(1), unique(name,photo));
create class un2 (name varchar(10), photo clob, gender char(1), unique(name,photo));
drop un1;
drop un2;

-- ok
-- constraints, unique not on blob/clob column.
create class un3 (name varchar(10), photo blob, gender char(1), unique(name,gender));
create class un4 (name varchar(10), photo clob, gender char(1), unique(name,gender));
insert into un3 values ('un3',bit_to_blob(X'bbbddd'),'M');
insert into un3 values ('un3',bit_to_blob(X'bbbddd'),'M');
insert into un4 values ('un4',char_to_clob('bbbddd'),'M');
insert into un4 values ('un4',char_to_clob('bbbddd'),'M');
select name, blob_to_bit(photo),gender from un3 order by 1,2,3;
select name, clob_to_char(photo),gender from un4 order by 1,2,3;
delete from un3;
delete from un4;
drop un3;
drop un4;


-- error
-- constraints, auto_increment on blob/clob column.
create class ai1 (id int, name varchar(10), photo blob auto_increment, gender char(1));
create class ai2 (id int, name varchar(10), photo clob auto_increment, gender char(1));
drop ai1;
drop ai2;

-- ok
-- constraints, auto_increment not on blob/clob column.
create class ai3 (id int auto_increment, name varchar(10), photo blob, gender char(1));
create class ai4 (id int auto_increment, name varchar(10), photo clob, gender char(1));
insert into ai3 values (null,'name',bit_to_blob(X'bbbccc'),'M');
insert into ai3 values (null,'name',bit_to_blob(X'bbbccc'),'M');
insert into ai3 values (null,'name',bit_to_blob(X'bbbccc'),'M');
insert into ai4 values (null,'name',char_to_clob('bbbccc'),'M');
insert into ai4 values (null,'name',char_to_clob('bbbccc'),'M');
insert into ai4 values (null,'name',char_to_clob('bbbccc'),'M');
select id,name,blob_to_bit(photo),gender from ai3 order by 1,2,3;
select id,name,clob_to_char(photo),gender from ai4 order by 1,2,3;
delete from ai3;
delete from ai4;
drop ai3;
drop ai4;


  
