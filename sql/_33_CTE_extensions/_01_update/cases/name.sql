drop if exists #Vehicles;
CREATE TABLE #Vehicles
(
    VehicleID     VARCHAR(5)
    ,VehicleType  VARCHAR(5)
    ,Location     VARCHAR(3)
    ,PRIMARY KEY (VehicleID)
);

INSERT INTO #Vehicles
VALUES ('12211', 'TRUCK', 'BKK'),('12212', 'CAR', 'BKK'),('12213', 'TRUCK', 'CNX')
    ,('12214', 'CAR', 'CNX'),('12215', 'TRUCK', 'HDY'),('12216', 'CAR', 'HDY');
drop if exists t1,t2;
create table t1(i int auto_increment);
create table t2(VehicleID VARCHAR(5), VehicleType  VARCHAR(5), Location VARCHAR(3),rn int);
create trigger insert_t1 
after insert on t2
execute insert into t1 values(null);
insert into t2 
WITH BKKVehicles AS
(

    SELECT VehicleID, VehicleType, Location
        ,ROW_NUMBER() OVER (ORDER BY VehicleID) as rn
    FROM #Vehicles
    WHERE Location = 'BKK'
    union all
    select BKKVehicles.* from BKKVehicles,t1 where t1.i<10
)
SELECT VehicleID, VehicleType, Location,rn
FROM BKKVehicles;
select * from t2 order by 1,2,3,4;
select * from t1 order by 1;
drop if exists #Vehicles;
drop table if exists t1, t2;
