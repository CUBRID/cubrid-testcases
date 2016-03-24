set timezone 'Asia/Seoul';

select (time'05:00:00 AM' - time'03:00:00 AM');   
select (timestamptz'2015-9-20 05:00:00 AM +9:00' - timestamptz'2015-9-20 03:00:00 AM +9:00'); 
select (timestampltz'2015-9-20 05:00:00 AM +9:00' - timestampltz'2015-9-20 03:00:00 AM +9:00');
 
select (time'05:00:00 PM' - time'03:00:00 AM');  
select (timestamptz'2015-9-20 05:00:00 PM +9:00' - timestamptz'2015-9-20 03:00:00 AM +9:00'); 
select (timestampltz'2015-9-20 05:00:00 PM +9:00' - timestampltz'2015-9-20 03:00:00 AM +9:00'); 

select (timestamptz'2015-9-20 05:00:00 PM +3:00' - timestamptz'2015-9-20 03:00:00 AM +9:00'); 
