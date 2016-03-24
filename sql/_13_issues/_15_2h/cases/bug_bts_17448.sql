set timezone '+03:00';
select time '3:00:00 am +04:00' - '3:00:00 am';
select time '3:00:00 pm +04:00' - '3:00:00 pm';
select datetimeltz '2000-01-02 3:00:00 am +04:00'-'2000-01-01 3:00:00 am';


set timezone '+03:00';
select datetimetz '2015-9-17 3:00:00 am +04:00' - '3:00:00 am';
select datetimetz '2015-9-17 3:00:00 pm +04:00' - '3:00:00 pm'; 
select datetimeltz '2000-01-02 3:00:00 am +04:00'-'2000-01-01 3:00:00 am';
 

set timezone '+03:00';
select datetimeltz '2015-9-17 3:00:00 am +04:00' - time'3:00:00 am';
select datetimeltz '2015-9-17 3:00:00 pm +04:00' - time'3:00:00 pm'; 
select datetimeltz '2000-01-02 3:00:00 am +04:00'-'2000-01-01 3:00:00 am';


set timezone '+03:00';
select datetimeltz '2015-9-17 3:00:00 am +04:00' - datetimetz'2015-9-17 3:00:00 am +4';
select datetimeltz '2015-9-17 3:00:00 pm +04:00' - datetimetz'2015-9-17 3:00:00 pm +4'; 
select datetimeltz '2000-01-02 3:00:00 am +04:00'-'2000-01-01 3:00:00 am';

set timezone '+03:00';
select datetimeltz '2015-9-17 3:00:00 am +04:00' - time'3:00:00 am';
select datetimeltz '2015-9-17 3:00:00 pm +04:00' - time'3:00:00 pm'; 
select datetimeltz '2000-01-02 3:00:00 am +04:00'-'2000-01-01 3:00:00 am';
select datetimeltz '2000-01-02 3:00:00 am +04:00'-'3:00:00 am +04:00';

set timezone 'Asia/Seoul';
