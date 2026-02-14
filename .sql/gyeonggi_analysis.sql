--analysis queries are here

--With this query, I could find out the top 5 city that have high population and among that cities, have low density.
SELECT
	region,
	pop_2059,
	num_academy,
	aca_den_10k
from gyeonggi_en_density_pop
order by pop_2059 desc, aca_den_10k ASC
limit 5;


--find the density average. After then, find out the distance between average density and density per 10k population
--And then, multiply with the population, figure out the opportunity score
with avg_density as (
	SELECT
		round(avg(aca_den_10k),2) as average_density
	from gyeonggi_en_density_pop
)
SELECT
	g.region,
	g.pop_2059,
	g.num_academy,
	g.aca_den_10k,
	round(a.average_density,2) as avg_den_10k,
	round(a.average_density - g.aca_den_10k,2) as density_gap,
	round(g.pop_2059 * (a.average_density - g.aca_den_10k) / 10000.0 ,2) as opportunity_score
from gyeonggi_en_density_pop g
cross join avg_density as a
where a.average_density > g.aca_den_10k
order by g.pop_2059 DESC
limit 10;
