--analysis queries are here


--Density per 10k comes out from divide(academy number / total adults)
--To find out top 5 regions that have high density per 10k adults
SELECT
	*
from academy_density_10k
group by region
order by academy_per_10k desc
limit 5;

--Find out bottom 5 regions that have fewer denstiy
SELECT
	*
from academy_density_10k
group by region
order by academy_per_10k asc
limit 5;

--top 7 large market share
SELECT
	region,
	total_2059
from academy_density_10k
group by region
order by total_2059 desc
limit 7;

--Large market but low density 
with kpi as (
SELECT
	region,
	total_2059,
	academy_num,
	(academy_num * 10000.00 / nullif(total_2059,0)) as density_per_10k
from academy_density_10k
),
average as (
SELECT
	avg(total_2059) as avg_market,
	avg(density_per_10k) as avg_density
from kpi
)
SELECT
	k.region,
	k.total_2059,
	k.academy_num,
	round(k.density_per_10k,2) as density_per_10k
from kpi as k
cross join average as a
where k.total_2059 >= a.avg_market
	and k.density_per_10k <= a.avg_density
order by k.total_2059 desc,
	density_per_10k asc;

--To identify the supply gap - how many academies are in excess or in shortage relative to demand
with kpi as(
SELECT
	region,
	total_2059,
	academy_num
from academy_density_10k
),
academy as (
SELECT
	(sum(academy_num) * 1.0 / nullif(sum(total_2059),0)) as aca_per
from kpi
)
SELECT
	k.region,
	k.total_2059,
	k.academy_num,
	round(k.total_2059 * a.aca_per,2) as expected_aca_num,
	round((k.total_2059*a.aca_per)-k.academy_num,2) as supply_gap
from kpi as k
cross join academy as a
order by supply_gap desc;
	
