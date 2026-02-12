--modeling gyeonggi-do dataset

--make a table to import the population data
drop table if exists gyunggi_2059;

create table gyunggi_2059 (
	region text,
	population INTEGER
);

--make a table to filter the academy in Gyeonggi-do
drop view if exists gyunggi_en_academy;

create view gyunggi_en_acadmey as
	SELECT
		v.*
	from vw_en_academy_v2 as v
	where v.시도교육청명 = '경기도교육청';

--count the entire columns
SELECT
	count(*)
from gyunggi_2059

--to figure out how many academies each city
SELECT
	행정구역명,
	count(*)
from gyunggi_en_academy
group by 행정구역명

--before join, check the values
SELECT DISTINCT
	행정구역명
from gyunggi_en_academy

SELECT DISTINCT
	region
from gyunggi_2059

