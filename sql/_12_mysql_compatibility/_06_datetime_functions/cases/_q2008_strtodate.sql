SELECT STR_TO_DATE('04/30/1', '%m/%d/%Y');
SELECT STR_TO_DATE('04/30/-2004', '%m/%d/%Y');
SELECT STR_TO_DATE('04/30/2004', '%m/%d/%Y');
SELECT DATEDIFF(STR_TO_DATE('03/30/2004', '%m/%d/%Y'),STR_TO_DATE('04/30/2004', '%m/%d/%Y')) from db_root;
SELECT DATE_FORMAT(STR_TO_DATE('04/30/2004', '%m/%d/%Y'), '%Y %m %d') from db_root;
select STRCMP( STR_TO_DATE('04/30/2004', '%m/%d/%Y'),'04/30/2004') ;
select STRCMP(DATE_FORMAT( STR_TO_DATE('04/30/2004', '%m/%d/%Y'),'%m %d %Y'),'04/30/2004') ;
select STRCMP(DATE_FORMAT( STR_TO_DATE('04/30/2004', '%m/%d/%Y'),'%m %d %Y'),'04/30/2004') ;