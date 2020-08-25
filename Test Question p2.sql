SELECT investor_state_code AS State,
       count(distinct investor_permalink) AS All_Investors,
       count(distinct case when investor_permalink like '%company%' then investor_permalink else null end) as Company_Investors,
       count(distinct case when investor_permalink like '%financial%' then investor_permalink else null end) as Financial_Investors,
       count(distinct case when investor_permalink like '%person%' then investor_permalink else null end) as Person_Investors,
       sum(raised_amount_usd) AS raised_amount_USD
FROM tutorial.crunchbase_investments
WHERE funding_round_type ='series-a'
  AND company_category_code ='software'
  AND investor_state_code is not null
  AND Investor_country_code = 'USA'
GROUP BY 1
HAVING sum(raised_amount_usd) is not null
ORDER BY 6 DESC;

SELECT investor_country_code AS Country,
       count(distinct investor_permalink) AS All_Investors,
       count(distinct case when investor_permalink like '%company%' then investor_permalink else null end) as Company_Investors,
       count(distinct case when investor_permalink like '%financial%' then investor_permalink else null end) as Financial_Investors,
       count(distinct case when investor_permalink like '%person%' then investor_permalink else null end) as Person_Investors,
       sum(raised_amount_usd) AS raised_amount_USD
FROM tutorial.crunchbase_investments
WHERE funding_round_type ='series-a'
  AND company_category_code ='software'
  AND investor_country_code is not null
GROUP BY 1
HAVING sum(raised_amount_usd) is not null
ORDER BY 6 DESC;

SELECT investor_city AS City,
       count(distinct investor_permalink) AS All_Investors,
       count(distinct case when investor_permalink like '%company%' then investor_permalink else null end) as Company_Investors,
       count(distinct case when investor_permalink like '%financial%' then investor_permalink else null end) as Financial_Investors,
       count(distinct case when investor_permalink like '%person%' then investor_permalink else null end) as Person_Investors,
       sum(raised_amount_usd) AS raised_amount_USD
FROM tutorial.crunchbase_investments
WHERE funding_round_type ='series-a'
  AND company_category_code ='software'
  AND investor_city is not null
  AND Investor_country_code = 'USA'
  AND investor_state_code='CA'
GROUP BY 1
HAVING sum(raised_amount_usd) is not null
ORDER BY 6 DESC;

SELECT investor_permalink,
       investor_name,
       investor_country_code,
       investor_state_code,
       investor_city,
       sum(raised_amount_usd) AS raised_amount_USD,
       sum(case when funding_round_type ='series-a' and company_category_code ='software' then raised_amount_usd else null end) AS series_A_software_raised_amount_USD,
       sum(case when funding_round_type ='series-a' and company_category_code ='software' then raised_amount_usd else null end)/sum(raised_amount_usd) AS series_A_software_raised_amount_percentage
FROM tutorial.crunchbase_investments
where investor_country_code ='USA'
GROUP BY 1,2,3,4,5
HAVING sum(raised_amount_usd) >= 10000000
and sum(case when funding_round_type ='series-a' and company_category_code ='software' then raised_amount_usd else null end)/sum(raised_amount_usd) >= 0.15
ORDER BY 8 desc;

select a.investor_state_code,
        a.investor_city,
       count(a.investor_permalink) as quality_investors
FROM
(
SELECT investor_permalink,
       investor_name,
       investor_country_code,
       investor_state_code,
       investor_city,
       sum(raised_amount_usd) AS raised_amount_USD,
       sum(case when funding_round_type ='series-a' and company_category_code ='software' then raised_amount_usd else null end) AS series_A_software_raised_amount_USD,
       sum(case when funding_round_type ='series-a' and company_category_code ='software' then raised_amount_usd else null end)/sum(raised_amount_usd) AS series_A_software_raised_amount_percentage
FROM tutorial.crunchbase_investments
where investor_country_code ='USA'
GROUP BY 1,2,3,4,5
HAVING sum(raised_amount_usd) >= 10000000
and sum(case when funding_round_type ='series-a' and company_category_code ='software' then raised_amount_usd else null end)/sum(raised_amount_usd) >= 0.15
and investor_state_code is not null
)a
group by 1,2
order by 3 desc
;
