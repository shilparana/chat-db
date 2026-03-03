-- CAMPAIGNS TABLE: Stores marketing campaign information and budgets
-- Use this table for queries about: campaign names, campaign types, campaign budgets, campaign dates, campaign status, target audiences, campaign costs
CREATE TABLE campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each campaign
    campaign_name VARCHAR(255) NOT NULL,               -- Campaign name/title
    campaign_type VARCHAR(50),                         -- Type (promotional, product_launch, email, brand, seasonal)
    description TEXT,                                  -- Campaign description
    start_date DATE,                                   -- Campaign start date
    end_date DATE,                                     -- Campaign end date
    budget DECIMAL(12, 2),                             -- Allocated budget
    actual_cost DECIMAL(12, 2),                        -- Actual spend
    status VARCHAR(20) DEFAULT 'draft',                -- Status (draft, active, planned, completed)
    target_audience TEXT,                              -- Target audience description
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP     -- When campaign was created
);

-- EMAIL_LISTS TABLE: Stores email marketing lists and subscriber groups
-- Use this table for queries about: list names, subscriber counts, list descriptions, active lists
CREATE TABLE email_lists (
    list_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each email list
    list_name VARCHAR(255) NOT NULL,                   -- List name
    description TEXT,                                  -- List description/purpose
    subscriber_count INT DEFAULT 0,                    -- Number of subscribers
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When list was created
    is_active BOOLEAN DEFAULT TRUE                     -- Whether list is active
);

-- SUBSCRIBERS TABLE: Stores email subscriber contact information
-- Use this table for queries about: subscriber emails, names, companies, job titles, subscription dates, subscriber status, subscription sources
CREATE TABLE subscribers (
    subscriber_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each subscriber
    email VARCHAR(255) UNIQUE NOT NULL,                -- Subscriber email (unique)
    first_name VARCHAR(100),                           -- First name
    last_name VARCHAR(100),                            -- Last name
    phone VARCHAR(20),                                 -- Phone number
    company VARCHAR(255),                              -- Company name
    job_title VARCHAR(100),                            -- Job title
    subscription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When they subscribed
    status VARCHAR(20) DEFAULT 'active',               -- Status (active, unsubscribed, bounced)
    source VARCHAR(100)                                -- How they subscribed (website, conference, referral, etc.)
);

-- LIST_SUBSCRIPTIONS TABLE: Links subscribers to email lists they're subscribed to
-- Use this table for queries about: list memberships, subscription dates, unsubscribe dates, subscription status
CREATE TABLE list_subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique identifier for each subscription
    list_id INT,                                       -- Email list
    subscriber_id INT,                                 -- Subscriber
    subscribed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When they subscribed to this list
    unsubscribed_date TIMESTAMP NULL,                  -- When they unsubscribed (NULL if still subscribed)
    status VARCHAR(20) DEFAULT 'active',               -- Status (active, unsubscribed)
    FOREIGN KEY (list_id) REFERENCES email_lists(list_id),
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(subscriber_id)
);

-- EMAIL_CAMPAIGNS TABLE: Stores email campaign sends and performance metrics
-- Use this table for queries about: email subjects, send dates, open rates, click rates, bounce rates, email performance
CREATE TABLE email_campaigns (
    email_campaign_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each email campaign
    campaign_id INT,                                   -- Parent marketing campaign
    list_id INT,                                       -- Email list used
    subject_line VARCHAR(255) NOT NULL,                -- Email subject line
    email_content TEXT,                                -- Email body content
    scheduled_date TIMESTAMP,                          -- When email is scheduled to send
    sent_date TIMESTAMP NULL,                          -- When email was actually sent
    total_sent INT DEFAULT 0,                          -- Number of emails sent
    total_opened INT DEFAULT 0,                        -- Number of opens
    total_clicked INT DEFAULT 0,                       -- Number of clicks
    total_bounced INT DEFAULT 0,                       -- Number of bounces
    status VARCHAR(20) DEFAULT 'draft',                -- Status (draft, scheduled, sent)
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    FOREIGN KEY (list_id) REFERENCES email_lists(list_id)
);

-- SOCIAL_MEDIA_POSTS TABLE: Stores social media posts and engagement metrics
-- Use this table for queries about: social platforms, post content, impressions, engagements, clicks, shares, post performance
CREATE TABLE social_media_posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each post
    campaign_id INT,                                   -- Parent marketing campaign
    platform VARCHAR(50) NOT NULL,                     -- Platform (facebook, twitter, instagram, linkedin)
    post_content TEXT,                                 -- Post text/content
    scheduled_time TIMESTAMP,                          -- When post is scheduled
    published_time TIMESTAMP NULL,                     -- When post was published
    impressions INT DEFAULT 0,                         -- Number of impressions
    engagements INT DEFAULT 0,                         -- Number of engagements (likes, comments)
    clicks INT DEFAULT 0,                              -- Number of clicks
    shares INT DEFAULT 0,                              -- Number of shares/retweets
    status VARCHAR(20) DEFAULT 'draft',                -- Status (draft, scheduled, published)
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- AD_CAMPAIGNS TABLE: Stores paid advertising campaigns and performance
-- Use this table for queries about: ad platforms, ad budgets, ad spend, impressions, clicks, conversions, ad performance, ROI
CREATE TABLE ad_campaigns (
    ad_campaign_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique identifier for each ad campaign
    campaign_id INT,                                   -- Parent marketing campaign
    platform VARCHAR(50) NOT NULL,                     -- Ad platform (google_ads, facebook_ads, linkedin_ads, instagram_ads)
    ad_name VARCHAR(255),                              -- Ad name/title
    ad_type VARCHAR(50),                               -- Ad type (search, display, sponsored, video)
    budget DECIMAL(10, 2),                             -- Allocated budget
    spent DECIMAL(10, 2) DEFAULT 0,                    -- Amount spent
    impressions INT DEFAULT 0,                         -- Number of impressions
    clicks INT DEFAULT 0,                              -- Number of clicks
    conversions INT DEFAULT 0,                         -- Number of conversions
    start_date DATE,                                   -- Campaign start date
    end_date DATE,                                     -- Campaign end date
    status VARCHAR(20) DEFAULT 'active',               -- Status (active, paused, completed)
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- LANDING_PAGES TABLE: Stores landing page performance metrics
-- Use this table for queries about: page views, unique visitors, conversions, bounce rates, time on page, landing page performance
CREATE TABLE landing_pages (
    page_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each landing page
    campaign_id INT,                                   -- Parent marketing campaign
    page_name VARCHAR(255) NOT NULL,                   -- Page name/title
    url VARCHAR(500),                                  -- Page URL
    page_views INT DEFAULT 0,                          -- Total page views
    unique_visitors INT DEFAULT 0,                     -- Unique visitors
    conversions INT DEFAULT 0,                         -- Number of conversions
    bounce_rate DECIMAL(5, 2),                         -- Bounce rate percentage
    avg_time_on_page INT,                              -- Average time on page (seconds)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When page was created
    is_active BOOLEAN DEFAULT TRUE,                    -- Whether page is active
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);









CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_subscribers_email ON subscribers(email);
CREATE INDEX idx_email_campaigns_campaign ON email_campaigns(campaign_id);
CREATE INDEX idx_social_posts_campaign ON social_media_posts(campaign_id);
CREATE INDEX idx_ad_campaigns_campaign ON ad_campaigns(campaign_id);
