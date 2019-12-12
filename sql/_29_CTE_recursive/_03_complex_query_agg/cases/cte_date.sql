drop if exists site;
create table site
(
contractor varchar(20),
startDate datetime,
endDate datetime
);
INSERT INTO Site 
 SELECT 'Ritesh','2009-02-01','2009-02-07' union all
 SELECT 'Ritesh','2009-02-15','2009-03-15' union all
 SELECT 'Ritesh','2009-01-01','2009-01-14' union all
 SELECT 'Rajan','2009-02-25','2009-03-05' union all
 SELECT 'Rajan','2009-03-11','2009-04-01';

WITH recursive CTE AS
(
 select contractor,startDate, endDate, startdate totDate ,1  l from site f
 union all
 select s.contractor,s.startDate, s.endDate, s.totDate+1,l+1 from cte s
 where s.totdate+1<s.enddate and l<10
)
select contractor,year(totdate) as year_t,month(totdate) as month_t,count(*) as TotalDays_t from cte
group by contractor,year(totdate),month(totdate);
drop if exists site;
