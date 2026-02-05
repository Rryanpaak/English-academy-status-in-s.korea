--validation using SQL

--To know all the types of columns 
pragma table_info(academy_info);

--count the number of rows
SELECT
	count(*) as num_rows
from academy_info;

--find the null value in major columns
SELECT
	sum(case when 학원명 is null or trim(학원명) = '' then 1 else 0 end) as null_name,
	sum(case when 시도교육청명 is null or trim(시도교육청명) = '' then 1 else 0 end) as null_sido,
	sum(case when 등록상태명 is null or trim(등록상태명) = '' then 1 else 0 end) as null_enroll,
	sum(case when 분야명 is null or trim(분야명) = '' then 1 else 0 end) as null_subject
from academy_info;

--check currently not operates academy status
SELECT 
	count(*)
from academy_info
where 휴원시작일자 is not null
	and 휴원종료일자 is not NULL
	and 휴원시작일자 > 휴원종료일자;

-- To find out the number of current non-running academies
SELECT
	count(*) as num_휴원
from academy_info
WHERE 휴원시작일자 is not NULL
	and 휴원시작일자 <=20260202
	and (휴원종료일자 is null or 휴원종료일자 >= 20260202);

--Make a view organized with only the current active academies
drop view if exists vw_active_academy;

create view vw_active_academy as 
select *
from academy_info
where not (
	휴원시작일자 is not null
	and 휴원시작일자 <= 20260202
	and (휴원종료일자 is null or 휴원종료일자 >= 20260202)
	);

--Filter the academies to find out english-related
drop view if exists vw_en_academy_v1;

create view vw_en_academy_v1 as 
SELECT
	*
from vw_active_academy
WHERE (
	coalesce(학원명,'') like '%영어%'
	or coalesce(학원명,'') like '%어학%'
	or coalesce(학원명,'') like '%토익%'
	or coalesce(학원명,'') like '%TOEIC%'
	or coalesce(학원명,'') like '%토플%'
	or coalesce(학원명,'') like '%TOEFL%'
	or coalesce(학원명,'') like '%아이엘츠%'
	or coalesce(학원명,'') like '%IELTS%'
	or coalesce(학원명,'') like '%회화%'
	or coalesce(분야명,'') like '%영어%'
	or coalesce(분야명,'') like '%어학%'
	or coalesce(분야명,'') like '%외국어%'
	)
AND NOT (
	coalesce(학원명,'') LIKE '%중국어%'
	OR coalesce(학원명,'') LIKE '%일본어%'
	OR coalesce(학원명,'') LIKE '%국어%'
	OR coalesce(학원명,'') LIKE '%독일어%'
	OR coalesce(학원명,'') LIKE '%프랑스어%'
	OR coalesce(학원명,'') LIKE '%스페인어%'
	OR coalesce(학원명,'') LIKE '%러시아어%'
	OR coalesce(분야명,'') LIKE '%독일어%'
	OR coalesce(분야명,'') LIKE '%스페인어어%'
	OR coalesce(분야명,'') LIKE '%프랑스어%'
	OR coalesce(분야명,'') LIKE '%러시아어%'
	OR coalesce(분야명,'') LIKE '%중국어%'
	OR coalesce(분야명,'') LIKE '%일본어%'
	);


--Merge academy_info table and population views
drop view if exists vw_academy_pop;

create view vw_academy_pop as 
SELECT
	v.*,
	a.total_2059,
	a.total_male,
	a.total_female,
	a.domestic_2059,
	a.domestic_male,
	a.domestic_female
from vw_en_academy_v1 as v
left join adult_2059_by_region as a
	on v.'region_key:1' = a.region_key;

SELECT
	count(*),
	sum(case when total_2059 is null then 1 else 0 end) as unmached_rows
from vw_academy_pop;

