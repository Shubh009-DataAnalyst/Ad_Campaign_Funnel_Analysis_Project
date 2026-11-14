-- Project: Ad Campaign Funnel Analysis (simulated dataset)
-- Business problem: Where do users drop off in the funnel, where is ad budget wasted, and where should it be shifted?
-- Data: ad_campaign_funnel_clean_v2.csv (cleaned in Python), imported via MySQL Workbench Table Data Import Wizard

create database ad_funnel;

use ad_funnel;

create table ads (
date                DATE,
    campaign_id         VARCHAR(5),
    campaign_name       VARCHAR(50),
    platform            VARCHAR(20),
    campaign_type       VARCHAR(20),
    target_audience     VARCHAR(30),
    creative_type       VARCHAR(20),
    device              VARCHAR(10),
    impressions         INT,
    clicks              INT,
    landing_page_views  INT,
    add_to_cart         INT,
    purchases           INT,
    ad_spend_inr        DECIMAL(12,2),
    revenue_inr         DECIMAL(12,2),
    month_num           INT,
    festive             VARCHAR(5)
);

-- Check 0: Verify data import
-- Verify the import: rows and totals must match the Python notebook
SELECT COUNT(*) AS total_rows,
       ROUND(SUM(ad_spend_inr)) AS total_spend,
       ROUND(SUM(revenue_inr)) AS total_revenue
FROM ads;

-- Query 1: Overall picture
-- Overall campaign performance
SELECT
    ROUND(SUM(ad_spend_inr) / 100000, 2)             AS spend_lakh,
    ROUND(SUM(revenue_inr) / 100000, 2)              AS revenue_lakh,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_pct,
    ROUND(SUM(purchases) * 100.0 / SUM(clicks), 2)   AS cvr_pct,
    ROUND(SUM(ad_spend_inr) / SUM(purchases), 0)     AS cpa,
    ROUND(SUM(revenue_inr) / SUM(ad_spend_inr), 2)   AS roas
FROM ads;

-- Query 2: Funnel (H4)
-- Funnel: users at each stage, users lost, and stage-wise conversion
SELECT
    SUM(clicks)             AS clicks,
    SUM(landing_page_views) AS landing_views,
    SUM(add_to_cart)        AS carts,
    SUM(purchases)          AS purchases,
    SUM(clicks) - SUM(landing_page_views)      AS lost_at_landing,
    SUM(landing_page_views) - SUM(add_to_cart) AS lost_before_cart,
    SUM(add_to_cart) - SUM(purchases)          AS lost_at_checkout,
    ROUND(SUM(landing_page_views) * 100.0 / SUM(clicks), 1)      AS click_to_landing_pct,
    ROUND(SUM(add_to_cart) * 100.0 / SUM(landing_page_views), 1) AS landing_to_cart_pct,
    ROUND(SUM(purchases) * 100.0 / SUM(add_to_cart), 1)          AS cart_to_purchase_pct
FROM ads;

-- Query 3: Platform-wise (H1)
-- Platform performance, sorted from worst to best ROAS
SELECT
    platform,
    ROUND(SUM(ad_spend_inr) / 100000, 2)             AS spend_lakh,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_pct,
    ROUND(SUM(purchases) * 100.0 / SUM(clicks), 2)   AS cvr_pct,
    ROUND(SUM(revenue_inr) / SUM(ad_spend_inr), 2)   AS roas
FROM ads
GROUP BY platform
ORDER BY roas;

-- Query 4: Campaign-wise (H6)
-- Campaign performance with a simple performance label
SELECT
    campaign_name,
    ROUND(SUM(ad_spend_inr) / 100000, 2)           AS spend_lakh,
    ROUND(SUM(purchases) * 100.0 / SUM(clicks), 2) AS cvr_pct,
    ROUND(SUM(revenue_inr) / SUM(ad_spend_inr), 2) AS roas,
    CASE
        WHEN SUM(revenue_inr) / SUM(ad_spend_inr) < 1 THEN 'Loss'
        WHEN SUM(revenue_inr) / SUM(ad_spend_inr) < 3 THEN 'Low'
        ELSE 'Good'
    END AS performance
FROM ads
GROUP BY campaign_name
ORDER BY roas;

-- Query 5: Device-wise (H2)
-- Device performance: spend share, CTR, CVR, CPC, AOV and ROAS
SELECT
    device,
    ROUND(SUM(ad_spend_inr) * 100.0 / (SELECT SUM(ad_spend_inr) FROM ads), 1) AS spend_share_pct,
    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_pct,
    ROUND(SUM(purchases) * 100.0 / SUM(clicks), 2)   AS cvr_pct,
    ROUND(SUM(ad_spend_inr) / SUM(clicks), 2)        AS cpc,
    ROUND(SUM(revenue_inr) / SUM(purchases), 0)      AS aov,
    ROUND(SUM(revenue_inr) / SUM(ad_spend_inr), 2)   AS roas
FROM ads
GROUP BY device
ORDER BY roas;

-- Query 6: Audience-wise (H3)
-- Audience performance with spend share
SELECT
    target_audience,
    ROUND(SUM(ad_spend_inr) * 100.0 / (SELECT SUM(ad_spend_inr) FROM ads), 1) AS spend_share_pct,
    ROUND(SUM(purchases) * 100.0 / SUM(clicks), 2) AS cvr_pct,
    ROUND(SUM(revenue_inr) / SUM(ad_spend_inr), 2) AS roas
FROM ads
GROUP BY target_audience
ORDER BY roas;

-- Query 7: Festival, per-day (H5)
-- Festive vs normal period, compared per day (27 festive days vs 157 normal days)
SELECT
    festive,
    COUNT(DISTINCT date)                                            AS days,
    ROUND(SUM(revenue_inr) / COUNT(DISTINCT date) / 100000, 2)      AS revenue_per_day_lakh,
    ROUND(SUM(purchases) / COUNT(DISTINCT date), 1)                 AS purchases_per_day,
    ROUND(SUM(ad_spend_inr) * 1000 / SUM(impressions), 0)           AS cpm,
    ROUND(SUM(revenue_inr) / SUM(ad_spend_inr), 2)                  AS roas
FROM ads
GROUP BY festive;

-- Query 8: How much budget was wasted
-- Total spend and revenue of the two loss-making campaigns
SELECT
    campaign_name,
    ROUND(SUM(ad_spend_inr) / 100000, 2) AS spend_lakh,
    ROUND(SUM(revenue_inr) / 100000, 2)  AS revenue_lakh
FROM ads
WHERE campaign_name IN ('LinkedIn Sponsored', 'Facebook Prospecting')
GROUP BY campaign_name;

-- Query 9: Spend share vs revenue share
-- Compare each campaign's share of spend with its share of revenue
SELECT
    campaign_name,
    ROUND(SUM(ad_spend_inr) * 100.0 / (SELECT SUM(ad_spend_inr) FROM ads), 1) AS spend_share_pct,
    ROUND(SUM(revenue_inr) * 100.0 / (SELECT SUM(revenue_inr) FROM ads), 1)   AS revenue_share_pct
FROM ads
GROUP BY campaign_name
ORDER BY revenue_share_pct - spend_share_pct asc;


