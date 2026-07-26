-- Q1: Create all tables based on the dataset and load the data to your local mysql database.
-- This script creates the complete database schema for the Retail & Customer Analytics system

USE retail_analytics;

-- ====================================================================
-- TABLE 1: CUSTOMERS
-- Stores demographic information, physical addresses, contact details, and account registration dates
-- ====================================================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY COMMENT 'Unique customer identifier (UUID)',
    full_name VARCHAR(255) NOT NULL COMMENT 'Customer full name',
    age DECIMAL(5, 1) COMMENT 'Customer age',
    gender VARCHAR(20) COMMENT 'Customer gender',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'Customer email address',
    phone VARCHAR(50) COMMENT 'Customer phone number',
    street_address VARCHAR(255) COMMENT 'Street address',
    city VARCHAR(100) COMMENT 'City of residence',
    state VARCHAR(100) COMMENT 'State of residence',
    zip_code VARCHAR(20) COMMENT 'Postal code',
    registration_date DATE COMMENT 'Account registration date',
    preferred_channel VARCHAR(50) COMMENT 'Preferred communication channel (online, in-store, both, etc.)',
    INDEX idx_state (state),
    INDEX idx_registration_date (registration_date),
    INDEX idx_preferred_channel (preferred_channel)
) ENGINE=InnoDB COMMENT='Customer master data table';

-- ====================================================================
-- TABLE 2: TRANSACTIONS
-- Tracks purchase history, including products bought, quantities, unit prices, store locations, and payment methods
-- ====================================================================
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id VARCHAR(50) PRIMARY KEY COMMENT 'Unique transaction identifier (UUID)',
    customer_id VARCHAR(50) NOT NULL COMMENT 'Reference to customer',
    product_name VARCHAR(255) COMMENT 'Product purchased',
    product_category VARCHAR(100) COMMENT 'Product category',
    quantity DECIMAL(10, 2) COMMENT 'Quantity purchased',
    price DECIMAL(10, 2) COMMENT 'Unit price',
    transaction_date DATE COMMENT 'Date of transaction',
    store_location VARCHAR(100) COMMENT 'Store location (Online, City names, etc.)',
    payment_method VARCHAR(50) COMMENT 'Payment method used',
    discount_applied DECIMAL(5, 2) COMMENT 'Discount percentage applied',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_store_location (store_location),
    INDEX idx_transaction_date (transaction_date)
) ENGINE=InnoDB COMMENT='Customer transaction/purchase history';

-- ====================================================================
-- TABLE 3: INTERACTIONS
-- Captures digital behavior and activity logs, such as product views, cart additions, session durations, and channel usage
-- ====================================================================
CREATE TABLE IF NOT EXISTS interactions (
    interaction_id VARCHAR(50) PRIMARY KEY COMMENT 'Unique interaction identifier (UUID)',
    customer_id VARCHAR(50) COMMENT 'Reference to customer',
    channel VARCHAR(50) COMMENT 'Channel of interaction (web, mobile app, in-store, etc.)',
    interaction_type VARCHAR(100) COMMENT 'Type of interaction (page_view, product_view, add_to_cart, review, wishlist_add, search, etc.)',
    interaction_date DATETIME COMMENT 'Date and time of interaction',
    duration DECIMAL(10, 2) COMMENT 'Duration of interaction in seconds',
    page_or_product VARCHAR(255) COMMENT 'Page or product name',
    session_id VARCHAR(100) COMMENT 'Session identifier',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_interaction_type (interaction_type),
    INDEX idx_interaction_date (interaction_date)
) ENGINE=InnoDB COMMENT='Customer digital behavior and activity logs';

-- ====================================================================
-- TABLE 4: CAMPAIGNS
-- Details marketing and advertising campaign performance metrics, including budgets, impressions, clicks, and conversions
-- ====================================================================
CREATE TABLE IF NOT EXISTS campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique campaign identifier',
    campaign_name VARCHAR(255) COMMENT 'Name of campaign',
    budget DECIMAL(12, 2) COMMENT 'Campaign budget amount',
    impressions INT COMMENT 'Number of impressions',
    clicks INT COMMENT 'Number of clicks',
    conversions INT COMMENT 'Number of conversions',
    start_date DATETIME COMMENT 'Campaign start date',
    end_date DATETIME COMMENT 'Campaign end date',
    INDEX idx_start_date (start_date)
) ENGINE=InnoDB COMMENT='Marketing campaign performance metrics';

-- ====================================================================
-- TABLE 5: CUSTOMER_REVIEWS_COMPLETE
-- Contains post-purchase product feedback, star ratings, and written review narratives submitted by customers
-- ====================================================================
CREATE TABLE IF NOT EXISTS customer_reviews_complete (
    review_id VARCHAR(50) PRIMARY KEY COMMENT 'Unique review identifier (UUID)',
    customer_id VARCHAR(50) COMMENT 'Reference to customer',
    product_name VARCHAR(255) COMMENT 'Product being reviewed',
    rating INT COMMENT 'Star rating (1-5)',
    review_text TEXT COMMENT 'Review narrative text',
    review_date DATETIME COMMENT 'Date of review submission',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_review_date (review_date)
) ENGINE=InnoDB COMMENT='Customer product reviews and ratings';

-- ====================================================================
-- TABLE 6: SUPPORT_TICKETS
-- Logs customer service inquiries, issue categories, priority levels, resolution statuses, and satisfaction scores
-- ====================================================================
CREATE TABLE IF NOT EXISTS support_tickets (
    ticket_id VARCHAR(50) PRIMARY KEY COMMENT 'Unique ticket identifier (UUID)',
    customer_id VARCHAR(50) COMMENT 'Reference to customer',
    issue_category VARCHAR(100) COMMENT 'Category of support issue',
    priority VARCHAR(50) COMMENT 'Priority level (High, Low, etc.)',
    submission_date DATETIME COMMENT 'Date ticket was submitted',
    resolution_date DATETIME COMMENT 'Date ticket was resolved',
    resolution_status VARCHAR(50) COMMENT 'Resolution status (Resolved, Pending, etc.)',
    resolution_time_hours DECIMAL(10, 2) COMMENT 'Time taken to resolve in hours',
    customer_satisfaction_score DECIMAL(5, 2) COMMENT 'Customer satisfaction score (1-5)',
    notes TEXT COMMENT 'Additional notes',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_priority (priority),
    INDEX idx_resolution_status (resolution_status),
    INDEX idx_submission_date (submission_date)
) ENGINE=InnoDB COMMENT='Customer support tickets and service inquiries';
