--+ holdcas on;
create table tree(id int, parentid int, text1 varchar(32), text2 varchar(64), text3 varchar(128), text4 varchar(256), text5 varchar(512), text6 varchar(1024), text7 varchar(2048), text8 varchar(16), text9 varchar(32), text10 varchar(64), text11 varchar(128), text12 varchar(256), text13 varchar(512), text14 varchar(1024), text15 varchar(2048));

create table leafs(text varchar(32));

insert into leafs values('A');
insert into leafs values('B');
insert into leafs values('C');
insert into leafs values('D');
insert into leafs values('E');

insert into tree values(1,null,'A','A','A','A','A','A','A','A','A','A','A','A','A','A','A');
insert into tree values(2,null,'B','B','B','B','B','B','B','B','B','B','B','B','B','B','B');
insert into tree values(3,null,'C','C','C','C','C','C','C','C','C','C','C','C','C','C','C');
insert into tree values(4,null,'D','D','D','D','D','D','D','D','D','D','D','D','D','D','D');
insert into tree values(5,null,'E','E','E','E','E','E','E','E','E','E','E','E','E','E','E');

insert into tree
	select 5+inst_num(),t.id,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text,t.text1+l.text
		from tree t,leafs l;

drop table leafs;

create table res(t1 time,t2 time,t3 time,t4 time);

create table tree2(id int,parentid int,text1 varchar(4096),text2 varchar(4096),text3 varchar(4096),text4 varchar(4096));

insert into res(t1) values(systime);

insert into tree2
	select id,parentid,text1,text2,text10,text6
		from tree
		start with text1 in ('AAA','BBB')
		connect by prior id=parentid;

update res set t2=systime;

drop table tree2;

create table tree3(id1 int,parentid1 int,text11 varchar(4096),text12 varchar(4096),text13 varchar(4096),text14 varchar(4096),id2 int,parentid2 int,text21 varchar(4096),text22 varchar(4096),text23 varchar(4096),text24 varchar(4096),id3 int,parentid3 int,text31 varchar(4096),text32 varchar(4096),text33 varchar(4096),text34 varchar(4096),id4 int,parentid4 int,text41 varchar(4096),text42 varchar(4096),text43 varchar(4096),text44 varchar(4096),id5 int,parentid5 int,text51 varchar(4096),text52 varchar(4096),text53 varchar(4096),text54 varchar(4096),id6 int,parentid6 int,text61 varchar(4096),text62 varchar(4096),text63 varchar(4096),text64 varchar(4096));

update res set t3=systime;

insert into tree3
	select t1.id,t1.parentid,t1.text1,t1.text2,t1.text10,t1.text6,
			t2.id,t2.parentid,t2.text1,t2.text2,t2.text10,t2.text6,
			t3.id,t3.parentid,t3.text1,t3.text2,t3.text10,t3.text6,
			t4.id,t4.parentid,t4.text1,t4.text2,t4.text10,t4.text6,
			t5.id,t5.parentid,t5.text1,t5.text2,t5.text10,t5.text6,
			t6.id,t6.parentid,t6.text1,t6.text2,t6.text10,t6.text6
		from tree t1
			left join tree t2 on t1.id=t2.parentid
			left join tree t3 on t2.id=t3.parentid
			left join tree t4 on t3.id=t4.parentid
			left join tree t5 on t4.id=t5.parentid
			left join tree t6 on t5.id=t6.parentid
		where t1.text1 in ('AAA','BBB');

update res set t4=systime;

drop table tree3;

drop table tree;

select '1111111111111111111111111111111' as performance from db_root;  
set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';
select '1111111111111111111111111111111' as performance from db_root;
set system parameters 'ansi_quotes=no';    
set system parameters 'compat_mode=cubrid';


--select case when (t4-t3)-(t2-t1)<0 then 'RUNS SLOWER' || (t4-t3) || ' ' || (t2-t1)
--                    when (t4-t3)=0 then '1111111111111111111111111111111'
--		else
--			case ((t4-t3)-(t2-t1))*100/(t4-t3) 
--				when 0 then '0000000000000000000000000000000'
--				when 1 then '1000000000000000000000000000000'
--				when 2 then '1100000000000000000000000000000'
--				when 3 then '1110000000000000000000000000000'
--				when 4 then '1111000000000000000000000000000'
--				when 5 then '1111100000000000000000000000000'
--				when 6 then '111110000000000000000000000000'
--				when 7 then '1111111000000000000000000000000'
--				when 8 then '1111111100000000000000000000000'
--				when 9 then '1111111110000000000000000000000'
--				when 10 then '1111111111000000000000000000000'
--				when 11 then '1111111111100000000000000000000'
--				when 12 then '1111111111110000000000000000000'
--				when 13 then '1111111111111000000000000000000'
--				when 14 then '1111111111111100000000000000000'
--				when 15 then '1111111111111110000000000000000'
--				when 16 then '1111111111111111000000000000000'
--				when 17 then '1111111111111111100000000000000'
--				when 18 then '1111111111111111110000000000000'
--				when 19 then '1111111111111111111000000000000'
--				when 20 then '1111111111111111111100000000000'
--				when 21 then '1111111111111111111110000000000'
--				when 22 then '1111111111111111111111000000000'
--				when 23 then '1111111111111111111111100000000'
--				when 24 then '1111111111111111111111110000000'
--				when 25 then '1111111111111111111111111000000'
--				when 26 then '1111111111111111111111111100000'
--				when 27 then '1111111111111111111111111110000'
--				when 28 then '1111111111111111111111111111000'
--				when 29 then '1111111111111111111111111111100'
--				when 30 then '1111111111111111111111111111110'
--				else '1111111111111111111111111111111'
--				end
--		end "performance"
--	from res;
--
--set system parameters 'compat_mode=mysql';
--set system parameters 'ansi_quotes=yes';
--
--select case when (t4-t3)-(t2-t1)<0 then concat('RUNS SLOWER', (t4-t3), ' ', (t2-t1))
--                    when (t4-t3)=0 then '1111111111111111111111111111111'
--		else
--			case ((t4-t3)-(t2-t1))*100/(t4-t3) 
--				when 0 then '0000000000000000000000000000000'
--				when 1 then '1000000000000000000000000000000'
--				when 2 then '1100000000000000000000000000000'
--				when 3 then '1110000000000000000000000000000'
--				when 4 then '1111000000000000000000000000000'
--				when 5 then '1111100000000000000000000000000'
--				when 6 then '111110000000000000000000000000'
--				when 7 then '1111111000000000000000000000000'
--				when 8 then '1111111100000000000000000000000'
--				when 9 then '1111111110000000000000000000000'
--				when 10 then '1111111111000000000000000000000'
--				when 11 then '1111111111100000000000000000000'
--				when 12 then '1111111111110000000000000000000'
--				when 13 then '1111111111111000000000000000000'
--				when 14 then '1111111111111100000000000000000'
--				when 15 then '1111111111111110000000000000000'
--				when 16 then '1111111111111111000000000000000'
--				when 17 then '1111111111111111100000000000000'
--				when 18 then '1111111111111111110000000000000'
--				when 19 then '1111111111111111111000000000000'
--				when 20 then '1111111111111111111100000000000'
--				when 21 then '1111111111111111111110000000000'
--				when 22 then '1111111111111111111111000000000'
--				when 23 then '1111111111111111111111100000000'
--				when 24 then '1111111111111111111111110000000'
--				when 25 then '1111111111111111111111111000000'
--				when 26 then '1111111111111111111111111100000'
--				when 27 then '1111111111111111111111111110000'
--				when 28 then '1111111111111111111111111111000'
--				when 29 then '1111111111111111111111111111100'
--				when 30 then '1111111111111111111111111111110'
--				else '1111111111111111111111111111111'
--				end
--		end "performance"
--	from res;
--
--set system parameters 'ansi_quotes=no';
--set system parameters 'compat_mode=cubrid';

drop table res;
commit;
--+ holdcas off;
