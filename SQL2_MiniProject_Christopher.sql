-- 1. Importing csv file to a database
-- creating the database test cricket
create database testcricket;

-- using the database
use testcricket;

select * from `icc test batting figures`;

-- 2. removing the player_profile column
alter table `icc test batting figures` drop column `Player Profile`;


-- 3. creating Player_name column and storing the player names from player column
alter table `icc test batting figures` add column Player_Name varchar(50);

Update `icc test batting figures` 
set Player_Name = substr(Player, 1,position('(' in Player)-1);

-- creating Country_name column and storing the player names from player column
alter table  `icc test batting figures` 
add column country_name varchar(20);
 
update `icc test batting figures` 
set country_name = substr(Player, position('(' in Player)+1, (length(player) - position('(' in player))-2);

--  Storing country name from player column
update `icc test batting figures` 
set country_name = substr(country_name, position('/' in country_name)+1, (length(country_name) - position('/' in country_name))-2)
where country_name like '%/%';

-- 4. extracting starting and end year from span column

alter table `icc test batting figures`
add column start_year int;

update `icc test batting figures`
set start_year = substr(span, 1,position('-' in span)-1);

alter table `icc test batting figures`
add column end_year int;

update `icc test batting figures`
set end_year = substr(span,position('-' in span)+1, (length(span) - position('-' in span))) ;

-- 5. storing high score with not out status 

alter table `icc test batting figures`
add column Out_Status varchar(10);


update `icc test batting figures`
set Out_Status = ( Case 
					when hs like '%*' then 'Not Out'
                    else 'Out'
                    end
				  )
;


alter table `icc test batting figures`
add column High_Score int;

update `icc test batting figures`
set High_Score = ( Case 
					when hs like '%*' then substr(hs,1,position('*' in hs)-1)
                    else hs
                    end
				  )
;

alter table `icc test batting figures`
modify column High_Score int after end_year;

-- 6. extracting player active in year 2019 with good avg score in india

select * from `icc test batting figures`
where end_year >= 2019 and country_name like '%INDIA%'
order by avg desc
limit 6;

-- 7. Extracting players active in 2019 and with the highest centuries in india

select * from `icc test batting figures`
where end_year >= 2019 and country_name like '%INDIA%' 
order by `100` desc
limit 6;

-- 8. Extracting players active in 2019 and with the highest half centuries with less ducks in india 

select * from `icc test batting figures`
where end_year >= 2019 and country_name like '%INDIA%' 
order by `50` desc, `0` asc
limit 6;

-- 9. creating view with batting order and good avg score for SA
CREATE VIEW ‘Batting_Order_GoodAvgScorers_SA’  AS 
(
select * from `icc test batting figures`
where end_year >= 2019 and country_name like '%SA%'
order by avg desc
limit 6);

-- 10. creating view with batting order and Higher centuries for SA

create view Batting_Order_HighestCenturyScorers_SA
as 
( 
select * from `icc test batting figures`
where end_year >= 2019 and country_name like '%sa%' 
order by `100` desc
limit 6);



