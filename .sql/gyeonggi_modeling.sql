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


--made a view merged two dataset
drop view if exists gyeonggi_en_density_pop;

create view gyeonggi_en_density_pop as
	with academy_cnt as (
		SELECT
			trim(행정구역명) as si,
			count(*) as num_aca
		from gyunggi_en_academy
		group by trim(행정구역명)
)
SELECT
	g.region,
	coalesce(num_aca,0) as num_academy,
	g.population as pop_2059,
	round(coalesce(a.num_aca,0) * 10000 / nullif(g.population,0),2) as aca_den_10k
from gyunggi_2059 as g
left join academy_cnt as a
	on g.region = a.si;
where g.region <> '합계'

