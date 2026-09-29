-- ============================================================
-- Customer Churn & Retention Analytics
-- Overall Churn KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    COUNT(*) FILTER (WHERE churn_flag = 0) AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charge,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges
FROM churn.customers;

-- ============================================================
-- Churn by Contract Type
-- ============================================================

SELECT
    contract,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- Churn by Tenure Group
-- ============================================================

SELECT
    tenure_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY tenure_group
ORDER BY
    CASE tenure_group
        WHEN '0-6 months' THEN 1
        WHEN '7-12 months' THEN 2
        WHEN '13-24 months' THEN 3
        WHEN '25-48 months' THEN 4
        WHEN '49-72 months' THEN 5
    END;

-- ============================================================
-- Churn by Internet Service
-- ============================================================

SELECT
    internet_service,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY internet_service
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- Churn by Payment Method
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- Churn by Monthly Charge Band
-- ============================================================

SELECT
    monthly_charge_band,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY monthly_charge_band
ORDER BY
    CASE monthly_charge_band
        WHEN '<=$30' THEN 1
        WHEN '$31-$60' THEN 2
        WHEN '$61-$90' THEN 3
        WHEN '>$90' THEN 4
    END;

-- ============================================================
-- Churn by Number of Services
-- ============================================================

SELECT
    total_services,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY total_services
ORDER BY total_services;

-- ============================================================
-- Churn by Contract and Tenure Group
-- ============================================================

SELECT
    contract,
    tenure_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges
FROM churn.customers
GROUP BY contract, tenure_group
ORDER BY
    CASE contract
        WHEN 'Month-to-month' THEN 1
        WHEN 'One year' THEN 2
        WHEN 'Two year' THEN 3
    END,
    CASE tenure_group
        WHEN '0-6 months' THEN 1
        WHEN '7-12 months' THEN 2
        WHEN '13-24 months' THEN 3
        WHEN '25-48 months' THEN 4
        WHEN '49-72 months' THEN 5
    END;

-- ============================================================
-- Churned Customers with Highest Monthly Charges
-- ============================================================

SELECT
    customer_id,
    tenure,
    contract,
    internet_service,
    payment_method,
    total_services,
    monthly_charges,
    estimated_annual_charges,
    churn
FROM churn.customers
WHERE churn_flag = 1
ORDER BY monthly_charges DESC
LIMIT 20;

-- ============================================================
-- Monthly Charge Exposure from Churned Customers
-- ============================================================

SELECT
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges,
    ROUND(
        100.0
        * SUM(monthly_charges) FILTER (WHERE churn_flag = 1)
        / SUM(monthly_charges),
        2
    ) AS churned_charge_pct
FROM churn.customers;

-- ============================================================
-- Executive Churn Summary
-- ============================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE churn_flag = 1) AS churned_customers,
    COUNT(*) FILTER (WHERE churn_flag = 0) AS retained_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_flag = 1) / COUNT(*),
        2
    ) AS churn_rate_pct,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_charges,
    ROUND(
        SUM(monthly_charges) FILTER (WHERE churn_flag = 1),
        2
    ) AS churned_monthly_charges,
    ROUND(
        100.0
        * SUM(monthly_charges) FILTER (WHERE churn_flag = 1)
        / SUM(monthly_charges),
        2
    ) AS churned_charge_pct
FROM churn.customers;
