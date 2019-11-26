--+ holdcas on;
-- key word test
drop table if exists median;
create table median(id int, median int);

INSERT INTO MEDIAN(ID,MEDIAN) VALUES('1','111');
INSERT INTO MEDIAN(ID,MEDIAN) VALUES('2','222');
INSERT INTO MEDIAN(ID,MEDIAN) VALUES('3','333');
INSERT INTO MEDIAN(ID,MEDIAN) VALUES('4','444');
INSERT INTO MEDIAN(ID,MEDIAN) VALUES('5','555');
INSERT INTO MEDIAN(ID,MEDIAN) VALUES('6','666');

select median(median) as median from median order by 1; 

--CUBRIDSUS-11737
set @median=1;
select @median;
drop variable @median;
drop table if exists median;

--+ holdcas off;
