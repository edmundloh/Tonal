/* 
Question 1
*/

/*
Looking through company names
*/

select permalink 
from tutorial.crunchbase_companies
group by 1
order by 1 desc;

/*
Investigating weird ocmpany names
*/

select * from tutorial.crunchbase_companies
where name is null or name in ('____');

/*
Counting company names
*/
select count(distinct permalink) 
from tutorial.crunchbase_companies;

/*
Answer: 27326
*/

/* 
Question 2
*/

/*
Finding US country code
*/

select distinct company_country_code
from tutorial.crunchbase_investments;

/*
Calculating percentage
*/

select count(case when a.country_code ='USA' then 1 else null end) as USA_companies,
       count(a.*) as all_companies,
       cast(count(case when a.country_code ='USA' then 1 else null end) as decimal(38,10))/cast(count(a.*) as decimal(38,10)) as USA_percentage
from (select permalink, 
            country_code 
      from tutorial.crunchbase_companies
      group by 1,2
     )a;

/*
Answer- 62.41%
*/

/*
Question 3
*/

/*
Summing total funding by state and ordering desc
*/

select state_code,
       sum(funding_total_usd) as funding_total_usd_sum
from tutorial.crunchbase_companies
where country_code='USA'
group by 1
order by 2 desc;

/*
Answer: CA (California)
*/

/*
Question 4
*/

/*
Summing total funding for biotech in USA and ordering desc
*/

select investor_permalink,
       sum(raised_amount_usd) as raised_amount_usd_sum
from tutorial.crunchbase_investments
where company_category_code ='biotech' AND
      company_country_code ='USA'
GROUP BY 1
HAVING sum(raised_amount_usd) is not null
ORDER by 2 DESC;

/*
Answer: Domain Associates
*/

/*
Question 5
*/

/*
average total series a funding in California
*/

select AVG(c.series_a_funding_all) as average_series_a_funding
from
(
  select 
    b.company_name,
    sum(series_a_funding) as series_a_funding_all
  from
    (
      select company_name,
             funded_at,
             AVG(raised_amount_usd) as series_a_funding
      from tutorial.crunchbase_investments 
      where company_country_code='USA'
        and company_state_code='CA'
        and funding_round_type='series-a'
        and company_category_code='biotech'
      GROUP BY 1,2
      HAVING sum(raised_amount_usd) is not null
    )b
    GROUP by 1
)c
;

/*
Answer: $15436849.23
*/

/*
Question 6
*/

/*
Elegant way but not allowed in Mode
*/

select PERCENTILE_CONT (0.5)
       WITHIN GROUP(ORDER BY COUNT(c.series_a_funding_all)) as median_series_a_funding
from
(
select 
    b.company_name,
    sum(series_a_funding) as series_a_funding_all
  from
    (
      select company_name,
             funded_at,
             AVG(raised_amount_usd) as series_a_funding
      from tutorial.crunchbase_investments 
      where company_country_code='USA'
        and company_state_code='CA'
        and funding_round_type='series-a'
        and company_category_code='biotech'
      GROUP BY 1,2
      HAVING sum(raised_amount_usd) is not null
    )b
    GROUP by 1
)c
                    
/*
Brute force - finding number of companies with series A funding
*/

select count(c.*)
from 
(
 select 
      b.company_name,
      sum(series_a_funding) as series_a_funding_all
    from
      (
        select company_name,
               funded_at,
               AVG(raised_amount_usd) as series_a_funding
        from tutorial.crunchbase_investments 
        where company_country_code='USA'
          and company_state_code='CA'
          and funding_round_type='series-a'
          and company_category_code='biotech'
        GROUP BY 1,2
        HAVING sum(raised_amount_usd) is not null
      )b
      GROUP by 1
      Order by 2 desc
)c;

/*
Brute force - Avg between 61 and 62
*/
 select 
      b.company_name,
      sum(series_a_funding) as series_a_funding_all
    from
      (
        select company_name,
               funded_at,
               AVG(raised_amount_usd) as series_a_funding
        from tutorial.crunchbase_investments 
        where company_country_code='USA'
          and company_state_code='CA'
          and funding_round_type='series-a'
          and company_category_code='biotech'
        GROUP BY 1,2
        HAVING sum(raised_amount_usd) is not null
      )b
      GROUP by 1
      Order by 2 desc

/*
Answer: 10000000
*/

/*
Question 7
*/

select count(case when status ='operating' then 1 else null end) as operating_companies,
       count(*) as all_companies,
       cast(count(case when status ='operating' then 1 else null end) as decimal) / cast(count(*) as decimal) as operating_companies_percentage
from tutorial.crunchbase_companies
where permalink in (select distinct company_permalink
                    from tutorial.crunchbase_investments
                    where funding_round_type ='series-a')

/*
Answer: 78.81%
*/

/*
Question 8
*/

select count(case when permalink in (select company_permalink from tutorial.crunchbase_acquisitions) then 1 else null end) as acquired_companies,
       count(*) as all_companies,
       cast(count(case when permalink in (select company_permalink from tutorial.crunchbase_acquisitions) then 1 else null end) as decimal) / cast(count(*) as decimal) as acquired_companies_percentage
from tutorial.crunchbase_companies
where permalink in (select distinct company_permalink
                    from tutorial.crunchbase_investments
                    where funding_round_type ='series-a')
                    
/*
Answer: 10.12%
*/
