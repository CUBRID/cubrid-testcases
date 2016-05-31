--inet_aton_ntoa_prepare_execute_001.sql
prepare x from 'select inet_aton(?)';
prepare y from 'select inet_ntoa(?)';
execute x using '1.2.3.4';
execute y using 16909060;

prepare x from 'select (inet_ntoa(inet_aton(?)))';
prepare y from 'select (inet_aton(inet_ntoa(?)))';
execute x using '1.2.3.4';
execute y using 16909060;

prepare x from 'select (inet_ntoa(inet_aton(?))=?)';
prepare y from 'select (inet_aton(inet_ntoa(?))=?)';
execute x using '1.2.3.4','1.2.3.4';
execute y using 16909060,16909060;

deallocate prepare x;
deallocate prepare y;
