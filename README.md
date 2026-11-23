# Ad Campaign Funnel Analysis

**Where do users drop off in the ad funnel, where is the ad budget wasted, and where should it be shifted?**

An end-to-end data analytics project using **Python (Google Colab), MySQL and Power BI**.

> **Note:** The dataset used in this project is **simulated** (generated with the help of an AI assistant to look like real ad campaign data). Results are illustrative and are not real company findings. More on this in the [Limitations](#limitations) section.

![Dashboard](Power%20BI%20Dashboard/image.png)

---

## Table of Contents
1. [Quick Summary](#quick-summary)
2. [Why I Chose This Project](#why-i-chose-this-project)
3. [Business Problem](#business-problem)
4. [Dataset](#dataset)
5. [Tools Used](#tools-used)
6. [Project Workflow](#project-workflow)
7. [Hypotheses](#hypotheses)
8. [Data Cleaning](#data-cleaning)
9. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
10. [SQL Analysis](#sql-analysis)
11. [Power BI Dashboard](#power-bi-dashboard)
12. [Key Insights](#key-insights)
13. [Recommendations](#recommendations)
14. [Limitations](#limitations)
15. [Challenges and How I Solved Them](#challenges-and-how-i-solved-them)
16. [Learnings](#learnings)
17. [Repository Structure and How to Run](#repository-structure-and-how-to-run)
18. [Future Improvements](#future-improvements)

---

## Quick Summary

| Manager's question | Answer from the analysis |
|---|---|
| Where do users drop off? | By **volume**, the most users are lost between **Landing Page and Add to Cart** (406,861 users). By **percentage**, the weakest step is **Add to Cart to Purchase** (79.6% drop-off, only 20.4% purchase). |
| Where is budget wasted? | **Facebook Prospecting** (ROAS 0.67) and **LinkedIn Sponsored** (ROAS 0.64). Together they used about **30% of the budget (₹60.33 lakh)** but brought only about **6.6% of the revenue (₹39.85 lakh)**. |
| Where should budget be shifted? | Towards campaigns with high return: **Email Newsletter (ROAS 11.66), Google Search Brand (7.60), Facebook Retargeting (4.86), Google Shopping (4.50)**. This should be done gradually and tested, because these audiences are limited in size. |

**Overall numbers:** Spend ₹199.68 lakh | Revenue ₹604.60 lakh | ROAS 3.03 | CTR 2.15% | CVR 4.63% | CPA ₹596

---

## Why I Chose This Project

I wanted a project for a **data analyst fresher role** that feels like real business work and not just charts. I chose ad campaign funnel analysis because:

- Almost every company spends money on ads, so the problem is real and easy to understand.
- It uses all the core analyst tools: data cleaning, EDA, SQL and a dashboard.
- It uses real business metrics (CTR, CVR, CPA, ROAS), so it shows business thinking and not just tool knowledge.
- The result can lead to a clear action (move the budget), which is what analysis is for.

---

## Business Problem

### How I decided the problem
I used a simple 4-question check to decide whether a problem is a good analytics problem:

1. **Who is facing the problem?** A marketing manager.
2. **What is the problem?** Money is spent on ads, but it is not clear where it is wasted.
3. **Can the data answer it?** Yes. The data has spend, revenue and every funnel stage.
4. **What action will the answer lead to?** Moving budget from weak campaigns to strong ones.

### Problem statement
> An e-commerce company spent about **₹2 crore** on 10 ad campaigns across 6 platforms in 6 months (Jul-Dec 2025). The marketing manager wants to know **at which funnel stage users drop off, which campaigns waste money, and where the budget should be shifted** to improve ROAS and conversion.

### Who can use this analysis
| Stakeholder | How they use it |
|---|---|
| Marketing Manager | Decide budget allocation |
| Performance Marketing Team | Optimise campaigns |
| Website / Product Team | Look at the weak funnel steps |
| CMO / Business Head | Check overall return on ad spend |

---

## Dataset

- **File:** `Data/ad_campaign_funnel_raw_v2.csv` (raw) and `Data/ad_campaign_funnel_clean_v2.csv` (cleaned)
- **Type:** Simulated. Each row is one **campaign x device x day**.
- **Period:** 1 Jul 2025 to 31 Dec 2025
- **Size:** 5,295 raw rows and 15 columns. After cleaning: **5,254 rows and 17 columns**.
- **Coverage:** 10 campaigns, 6 platforms (Google Ads, Facebook, Instagram, YouTube, Email, LinkedIn), 3 devices (Mobile, Desktop, Tablet)

| Column | Meaning |
|---|---|
| date | Day of the campaign |
| campaign_id, campaign_name | Campaign identity |
| platform | Ad platform |
| campaign_type | Search, Shopping, Social, Video, Retargeting, Influencer, Email |
| target_audience | New Users, Existing Customers, Website Visitors, Lookalike, Professionals |
| creative_type | Text, Image, Video, Carousel |
| device | Mobile, Desktop, Tablet |
| impressions, clicks, landing_page_views, add_to_cart, purchases | The 5 funnel stages |
| ad_spend_inr, revenue_inr | Money spent and money earned (₹) |
| month_num, festive | Added during cleaning (month number and festive-period flag) |

### Dataset history (for transparency)
I first practised on an earlier simulated dataset. Because I already knew its patterns, I then used a **second dataset (v2) with different patterns** for the final analysis, so I could test the hypotheses without knowing the results in advance. The AI assistant that generated the data knows how it was built, so the results should still be treated as illustrative.

---

## Tools Used

| Tool | Purpose |
|---|---|
| Python (pandas) in Google Colab | Data cleaning and EDA |
| MySQL (Workbench) | SQL analysis, used to cross-check the Python results |
| Power BI Desktop | Dashboard and visual storytelling |
| Google and an AI assistant | Learning ad funnel concepts and metrics, and getting guidance while building |

I wrote and ran the code, built the dashboard, and checked that the numbers match across Python, SQL and Power BI.

---

## Project Workflow

```
Problem -> Hypotheses -> Raw data -> Cleaning (Python) -> EDA (Python) -> SQL (MySQL) -> Dashboard (Power BI) -> Insights
```

1. Decided the business problem and listed the questions to answer.
2. Researched ad funnel concepts and common campaign problems.
3. Wrote hypotheses, keeping only the ones my columns could test.
4. Inspected and cleaned the raw data.
5. Calculated metrics and tested each hypothesis in EDA.
6. Repeated the analysis in SQL to cross-check the numbers.
7. Built a one-page Power BI dashboard.
8. Wrote insights and recommendations.

---

## Hypotheses

### How I made them
After fixing the business problem, I used Google and an AI assistant to understand how ad funnels work and what usually goes wrong in campaigns. Then I checked which ideas my dataset could actually test. I kept a hypothesis only if:

1. It is **linked to the business problem**.
2. My dataset has the **columns needed** to test it.
3. The result can lead to an **action**.

### Hypotheses and results

| # | Hypothesis | Linked to business problem | Result |
|---|---|---|---|
| H1 | Platforms will have very different ROAS | Where is budget wasted | **Correct.** ROAS ranges from 0.64 (LinkedIn) to 11.66 (Email). |
| H2 | Mobile will have a lower conversion rate (CVR) than Desktop | Why the funnel leaks | **Rejected.** Mobile CVR 4.67% vs Desktop 4.62%, almost the same. |
| H3 | Existing customers will convert better than new users | Where to shift budget | **Correct.** CVR 6.78% vs 3.70%. |
| H4 | One funnel stage will lose the most users | Where users drop off | **Correct.** Volume: Landing to Cart. Percentage: Cart to Purchase. |
| H5 | Festival season will bring more sales | When to spend | **Partially correct.** Sales went up, but ROAS went down. |
| H6 | Some campaigns will have ROAS below 1 | Where budget is wasted | **Correct.** LinkedIn (0.64) and Facebook Prospecting (0.67). |

Not every hypothesis was correct, and that is expected. H2 was rejected and H5 was only partly right.

### Ideas I did not test (data not available)
| Idea | Why not tested |
|---|---|
| Which city or state converts best | No location column |
| Which age group buys most | No age column |
| Which product sells most | No product column |
| Which exact ad copy or image works best | No ad-level data (only creative type) |
| Which campaign gives the most profit | No product cost or margin (only revenue) |
| Do customers buy again | No customer-level data |

---

## Data Cleaning

**Why:** Wrong data gives wrong decisions. For example, `facebook` and `Facebook` would be counted as two platforms, and duplicate rows would count spend twice. I inspected first and changed things only after that.

| Problem found | How many | What I did |
|---|---|---|
| Duplicate rows | 18 | Removed |
| Wrong spelling of platform names (`facebook`, `instagram`, `linkedin`) | 7 rows | Replaced with the correct names |
| Missing `landing_page_views` | 14 | Removed rows |
| Missing `revenue_inr` | 9 | Removed rows |
| `date` stored as text | all rows | Converted to date type |
| `landing_page_views` stored as decimal | all rows | Converted to whole number (needed for MySQL import) |

**Other checks:**
- No negative values.
- Funnel logic check: clicks <= impressions, landing views <= clicks, add to cart <= landing views, purchases <= add to cart. No violations.
- `campaign_id` and `campaign_name` map one-to-one, so `campaign_id` is kept only as an ID.
- New columns: `month_num` (month number) and `festive` (True for 10 Oct to 5 Nov 2025, an assumed Diwali-season window of 27 days).

**Decision on missing values:** Only 23 rows (about 0.4%) had missing values, so I removed them instead of guessing the numbers.

**Result:** 5,295 raw rows became **5,254 clean rows**. Total spend after cleaning: ₹19,967,955. Total revenue: ₹60,460,025.

---

## Exploratory Data Analysis (EDA)

**Why EDA:** To ask questions of the clean data, test the hypotheses and find where the money is going.

### Metrics used
| Metric | Formula | Meaning |
|---|---|---|
| CTR | clicks / impressions | How many people who saw the ad clicked |
| CVR | purchases / clicks | How many people who clicked bought |
| CPA | spend / purchases | Cost to get one purchase |
| CPC | spend / clicks | Cost of one click |
| CPM | spend / impressions x 1000 | Cost of 1,000 ad views |
| AOV | revenue / purchases | Average order value |
| ROAS | revenue / spend | Revenue earned for every ₹1 spent |

**Rule followed:** totals are summed first, and ratios are calculated after that. I did not average row-level ratios, because that gives wrong results.

### Findings

**1. Funnel (H4)**

| Stage | Users | Conversion from previous stage | Users lost |
|---|---|---|---|
| Clicks | 723,783 | - | - |
| Landing page views | 571,104 | 78.9% | 152,679 |
| Add to cart | 164,243 | 28.8% | 406,861 |
| Purchase | 33,500 | 20.4% | 130,743 |

Landing to Cart loses the most users (58.9% of all losses after the click). Cart to Purchase has the highest drop-off rate (79.6%).

**2. Platforms (H1):** Email 11.66, Google Ads 4.96, Instagram 2.09, YouTube 1.51, Facebook 1.50, LinkedIn 0.64.

**3. Campaigns (H6):** LinkedIn Sponsored 0.64 and Facebook Prospecting 0.67 are below 1. YouTube Pre-roll (1.51) and Instagram Reels (1.75) are low. Email Newsletter (11.66) and Google Search Brand (7.60) are the strongest.

**4. Device (H2)**

| Device | Spend share | CTR | CVR | CPC | AOV | ROAS |
|---|---|---|---|---|---|---|
| Mobile | 57% | 2.00% | 4.67% | ₹29.65 | ₹1,739 | 2.74 |
| Tablet | 12% | 2.17% | 4.47% | ₹27.22 | ₹1,801 | 2.95 |
| Desktop | 31% | 2.41% | 4.62% | ₹24.57 | ₹1,907 | 3.58 |

Conversion is the same on all devices. Mobile has a lower ROAS because its clicks cost more and its orders are smaller, not because of checkout problems.

**5. Audience (H3)**

| Audience | Spend share | CVR | ROAS |
|---|---|---|---|
| New Users | 69.3% | 3.70% | 2.00 |
| Existing Customers | 13.2% | 6.78% | 8.59 |
| Website Visitors | 6.2% | 6.34% | 4.86 |
| Lookalike | 5.9% | 3.64% | 2.83 |
| Professionals | 5.4% | 2.87% | 0.64 |

**6. Festival season (H5)** (compared per day, because there are 27 festive days and 157 normal days)

| | Revenue per day | Purchases per day | CPM | ROAS |
|---|---|---|---|---|
| Normal days | ₹3.09 lakh | 170.9 | ₹570 | 3.16 |
| Festive days | ₹4.42 lakh | 246.9 | ₹689 | 2.59 |

Sales rose by about 43%, but ad costs (CPM) rose by about 21%, so ROAS fell.

---

## SQL Analysis

**Why SQL:** The same questions were asked again in MySQL as a **cross-check**. The SQL totals match Python (5,254 rows, ₹19,967,955 spend, ₹60,460,025 revenue). SQL is also the main tool analysts use to query company data.

File: `SQL/ad_campaign_funnel_analysis_queries.sql`

| Query | What it does | What it showed |
|---|---|---|
| Check 0 | Verifies the import (row count and totals) | Matches Python |
| Query 1 | Overall spend, revenue, CTR, CVR, CPA, ROAS | ROAS 3.03 is the baseline |
| Query 2 | Funnel users, users lost and conversion per stage | Biggest volume loss at Landing to Cart, weakest rate at Cart to Purchase |
| Query 3 | ROAS by platform | LinkedIn lowest, Email highest |
| Query 4 | ROAS by campaign with a `CASE WHEN` label (Loss / Low / Good) | 2 Loss, 3 Low, 5 Good campaigns |
| Query 5 | Device spend share, CTR, CVR, CPC, AOV, ROAS | Same CVR, different cost and order value |
| Query 6 | Audience spend share, CVR and ROAS | 69% of budget goes to New Users with ROAS 2.00 |
| Query 7 | Festive vs normal days, per day | Sales up, ROAS down |
| Query 8 | Spend and revenue of the two loss-making campaigns | ₹60.33 lakh spent, ₹39.85 lakh earned |
| Query 9 | Each campaign's share of spend vs share of revenue | Shows where to shift budget |

---

## Power BI Dashboard

File: `Power BI Dashboard/Ad_Campaign_Funnel_Dashboard.pbix`

The dashboard has one page. Each visual answers one question.

| Visual | Question it answers | Why this chart | Another option | What it shows |
|---|---|---|---|---|
| 4 KPI cards (Spend, Revenue, ROAS, CVR) | How are we doing overall? | One headline number each, quick to read | Gauge or KPI visual | ₹199.68L spent, ₹604.60L revenue, ROAS 3.03, CVR 4.63% |
| Funnel chart | Where do users drop off? | Shows the narrowing from stage to stage | Column chart or a table with conversion % | 723,783 clicks end as 33,500 purchases |
| Bar chart: ROAS by campaign (with ROAS = 1 line) | Which campaigns lose money? | Ranks 10 campaigns with long names. The red line makes losses easy to spot. | Column chart or table with colours | LinkedIn and Facebook Prospecting fall below the line |
| Clustered bar: Spend share vs Revenue share | Where should budget move? | Compares two measures side by side for each campaign | Scatter plot (spend vs ROAS) | Facebook Prospecting: 24.84% of spend but 5.46% of revenue. Google Brand: 10.02% of spend but 25.14% of revenue. |
| Column chart: CVR by device | Is mobile conversion weak? | Simple comparison of 3 devices | Table | CVR is about 4.5-4.7% on all devices |
| Column chart: ROAS by device | Which device earns more per rupee? | Same reason, kept as a separate chart because the scale is different | Combined chart with two axes | Desktop 3.58, Tablet 2.95, Mobile 2.74 |
| Table: Festival vs Normal days | Did festival season help? | Needs exact numbers in different units (₹, count, ratio) | Column chart or line chart over time | Sales up about 43%, ROAS down |
| Slicers (Platform, Device) | Can I filter the view? | Makes every visual interactive | Tiles or list | Filter by platform or device |

### Why I did not use pie or donut charts
Pie and donut charts work only for a share of one total with few slices. ROAS and CVR do not add up to 100%, and 10 campaigns would be too many slices to read. A bar chart is clearer for ranking.

### Power BI measures
Total Spend, Total Revenue, Spend (Lakh), Revenue (Lakh), ROAS, CVR, CTR, CPA, Spend Share %, Revenue Share %, Days, Revenue per Day (Lakh), Purchases per Day, CPM and Funnel Users. A small table `Funnel Stages` is used to draw the funnel.

---

## Key Insights

1. **The funnel leaks after the click.** Landing to Cart loses the most users (406,861). Even among users who add to cart, about 80% do not buy.
2. **About 30% of the budget produces about 6.6% of the revenue.** Facebook Prospecting and LinkedIn together spent ₹60.33 lakh and earned ₹39.85 lakh.
3. **Budget and return do not match.** Facebook Prospecting gets 24.84% of spend and returns 5.46% of revenue. Google Search Brand and Email get about 13% of spend and return about 37.6% of revenue.
4. **Mobile is not a conversion problem.** CVR is about the same on all devices. Mobile loses on click cost and order size.
5. **New users take 69% of the budget at ROAS 2.00,** while existing customers return ROAS 8.59 on only 13% of the budget.
6. **Festival season lifts sales but costs more.** Daily revenue is up about 43%, but CPM is up about 21% and ROAS falls from 3.16 to 2.59.

---

## Recommendations

1. **Reduce Facebook Prospecting and LinkedIn spend** and review their targeting and creatives before spending more.
2. **Move the budget gradually** (for example in small steps) to Email, Google Search Brand, Facebook Retargeting and Google Shopping, and watch ROAS after each step. These audiences are limited, so returns can fall if too much money is added at once.
3. **Do not stop new-user campaigns.** Improve them, because they bring future customers.
4. **Review the checkout step.** Only 20.4% of carts become purchases.
5. **Improve what happens after the click** (product page, price and offer clarity), because the biggest volume loss is at Landing to Cart.
6. **Plan festival budgets in advance** and expect ad costs to be higher.
7. **Treat mobile as a click-cost and order-value issue,** not a checkout issue.

---

## Limitations

- **The data is simulated.** Patterns were built into it, so results show the method and not real market facts.
- **ROAS is based on revenue, not profit.** The data has no product cost or margin, so real profit is unknown.
- **The festive window (10 Oct to 5 Nov) is an assumption.**
- **Comparisons are descriptive.** I compared groups using totals and ratios. I did not run statistical significance tests (such as a t-test or chi-square).
- **No attribution model.** Revenue is credited to the campaign shown in the data, and awareness campaigns (like YouTube) may influence sales indirectly.
- **Limited audiences.** Moving budget to high-ROAS campaigns will not give the same ROAS forever.
- **Only 23 rows (0.4%) were removed** for missing values. This is a small effect, but it is still a choice I made.
- **The Power BI file reads data from a local file path.** To refresh it on another computer, update the path in Transform data > Data source settings.

---

## Challenges and How I Solved Them

| Challenge | How I solved it |
|---|---|
| Not sure if cleaning or EDA comes first | Learned the order: inspect, clean, then EDA. Cleaning is fixing data and EDA is asking questions of it. |
| Confusion about when to use `groupby`, totals and ratios | Used one repeating pattern: group, sum, then calculate the ratio. |
| "Biggest drop-off" can mean volume or percentage | Reported both views and explained the difference. |
| Festival period has 27 days and normal period has 157 | Compared per day, and checked revenue, purchases, CPM and ROAS together. |
| Wrong number copied into a comment (0.87 instead of 0.67) | Re-checked every comment against the output. |
| `landing_page_views` became decimal and could break MySQL import | Converted it to whole numbers before saving. |
| Power BI formula showed a red underline | A measure must exist before another measure uses it. I created `Days` first. |
| Budget share chart hid 3 campaigns behind a scrollbar | Resized the chart and the page so all 10 campaigns are visible. |
| Python, SQL and Power BI should agree | Cross-checked totals, funnel counts and campaign ROAS in all three tools. |

---

## Learnings

- A good business problem comes first. Tools come after.
- Inspect data before changing it, and explain every cleaning decision.
- Ratios like CTR, CVR and ROAS must be calculated from totals.
- A hypothesis should be written before looking at results, and it can be wrong.
- Define what you are measuring: "biggest drop" can mean count or percentage.
- Compare periods of different length per day.
- Choose a chart because of the question it answers, not for variety.
- Cross-checking the same numbers in three tools builds trust in the analysis.
- Always state limitations. Simulated data and revenue-based ROAS affect how far the results can be trusted.

---

## Repository Structure and How to Run

```
Ad_Campaign_Funnel_Analysis_Project/
|-- Data/
|   |-- ad_campaign_funnel_raw_v2.csv
|   |-- ad_campaign_funnel_clean_v2.csv
|-- Notebook/
|   |-- Ad_funnel_cleaning_eda.ipynb
|-- SQL/
|   |-- ad_campaign_funnel_analysis_queries.sql
|-- Power BI Dashboard/
|   |-- Ad_Campaign_Funnel_Dashboard.pbix
|   |-- image.png
|-- README.md
```

**Python:** Open the notebook in Google Colab, upload `ad_campaign_funnel_raw_v2.csv`, and run all cells.
**SQL:** Run the table creation script at the top of the SQL file in MySQL Workbench, import `ad_campaign_funnel_clean_v2.csv` with the Table Data Import Wizard, then run the queries.
**Power BI:** Open the `.pbix` file in Power BI Desktop. If the data does not refresh, update the file path in Data source settings.

---

## Future Improvements

- Add product cost or margin data to measure profit, not only ROAS.
- Run statistical significance tests (such as a t-test or chi-square) to check that the differences between groups are not due to chance.
- Add a monthly trend view and checks for sudden drops in conversion.
- Repeat the same workflow on a real public ad campaign dataset.

---

## Author

**Shubham Bhatt** | Aspiring Data Analyst
GitHub: [Shubh009-DataAnalyst](https://github.com/Shubh009-DataAnalyst)
