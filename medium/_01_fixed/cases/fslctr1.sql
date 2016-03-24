autocommit off;
create class z (zi int);
create class y (yi int);
create class suby as subclass of y (yz z);
create class x (xy y);
select xy{ycorr}.yz.zi from x, suby ycorr;
rollback;
