use mavenfuzzyfactory;
/*
Bounce rate analysis is an important aspect of understanding user behavior on a website. 
Bounce rate refers to the percentage of visitors who leave a website after viewing only a single page,
without interacting further or navigating to other pages within the site.
*/ 

-- STEP 1: finding the first website_pageview_id for relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session, to identify "bounces"
-- Step 4: summarizing by counting total sessions and bounced sessions

CREATE temporary table first_pageviews
select
	website_session_id, 
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
group by 
	website_session_id;

CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	first_pageviews.website_session_id, 
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews
	LEFT JOIN website_pageviews
		ON website_pageview_id = first_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url = '/home';

CREATE TEMPORARY TABLE bounced_sessions 
SELECT
	sessions_w_home_landing_page.website_session_id, 
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
    
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
    
GROUP BY 
	sessions_w_home_landing_page.website_session_id, 
    sessions_w_home_landing_page.landing_page
    
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1;
    
-- we'll do this first just to show whats in this query, then we will count them after:

SELECT
	COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions, 
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_session,
    COUNT(DISTINCT bounced_sessions.website_session_id) / COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate    
FROM sessions_w_home_landing_page
	LEFT JOIN bounced_sessions
		ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id
ORDER BY 
	sessions_w_home_landing_page.website_session_id;
    
/*
Analyzing data seasonally is important because many businesses experience fluctuations in their performance, 
customer behavior, and market trends throughout different times of the year. 
*/ 

SELECT 
	website_session_id, 
    created_at,
    HOUR(created_at) AS hr,
    WEEKDAY(created_at) AS wkday, -- 0= Mon, 1 = Tues, etc
    CASE 
		WHEN weekday(created_at) = 0 THEN 'Monday'
		WHEN weekday(created_at) = 1 THEN 'Tuesday'
		WHEN weekday(created_at) = 2 THEN 'Wednesday'
		WHEN weekday(created_at) = 3 THEN 'Thursday'
		WHEN weekday(created_at) = 4 THEN 'Friday'   
        ELSE 'other_day'
	END AS clean_weekday,
    QUARTER(created_at) AS qtr,
    MONTH(created_at) AS mo, 
    DATE(created_at) AS date, 
    WEEK(created_at) AS wk
FROM website_sessions
	
/*
Date functions are used in SQL to manipulate and extract information 
from date and time values stored in a database. 
*/ 

SELECT 
	YEAR(website_sessions.created_at) AS yr,
    WEEK(website_sessions.created_at) AS wk,
    MIN(DATE(website_sessions.created_at)) AS week_start, 
	COUNT(website_sessions.website_session_id) AS sessions,
    COUNT(orders.order_id) AS orders
    
	
FROM website_sessions
	LEFT JOIN orders 
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1,2

/*
Calcule conversion rate from session to order
*/ 

SELECT 	
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    -- agora é para calcular o CVR - Conversion Rate 
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS CVR
FROM 
	website_sessions	
LEFT JOIN Orders 
	ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-04-14' 
	AND utm_source = 'gsearch' 
    AND utm_campaign = 'nonbrand'
    
    # Trending one source week start / sessions

SELECT 
	-- YEAR(created_at) AS YEAR,
	-- WEEK(created_at) AS WEEK,
    MIN(DATE(created_at)) AS week_started_at,
    Count(website_session_id) AS sessions
    
FROM website_sessions 
WHERE created_at < '2012-05-10'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'

GROUP BY
	YEAR(created_at),
	WEEK(created_at)