-- SUPPORT_AGENTS TABLE: Stores customer support agent information
-- Use this table for queries about: agent names, departments, skill levels, tickets resolved, customer satisfaction
CREATE TABLE support_agents (
    agent_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each agent
    first_name VARCHAR(100) NOT NULL,                   -- Agent's first name
    last_name VARCHAR(100) NOT NULL,                    -- Agent's last name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Agent email address (unique)
    phone VARCHAR(20),                                  -- Agent phone number
    department VARCHAR(50),                             -- Department (Technical, Billing, General)
    skill_level VARCHAR(20),                            -- Skill level (junior, intermediate, senior)
    is_available BOOLEAN DEFAULT TRUE,                  -- Whether agent is available
    hire_date DATE,                                     -- Date agent was hired
    total_tickets_resolved INT DEFAULT 0,               -- Total tickets resolved
    avg_resolution_time INT,                            -- Average resolution time in minutes
    customer_satisfaction DECIMAL(3, 2)                 -- Customer satisfaction rating (0-5)
);

-- CUSTOMERS TABLE: Stores customer account information and contact details
-- Use this table for queries about: customer names, emails, addresses, registration dates, loyalty points, active customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each customer
    customer_name VARCHAR(255) NOT NULL,                -- Customer name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Customer email address (unique)
    phone VARCHAR(20),                                  -- Customer phone number
    company VARCHAR(255),                               -- Company name
    account_type VARCHAR(50),                           -- Account type (premium, standard, enterprise)
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When customer registered
    is_active BOOLEAN DEFAULT TRUE                      -- Whether customer account is active
);

-- SUPPORT_TICKETS TABLE: Stores customer support tickets and issues
-- Use this table for queries about: ticket status, ticket priorities, ticket subjects, assigned agents, resolution times
CREATE TABLE support_tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique identifier for each ticket
    ticket_number VARCHAR(50) UNIQUE NOT NULL,          -- Ticket number (unique)
    customer_id INT,                                    -- Customer who created the ticket
    assigned_agent_id INT,                              -- Agent assigned to the ticket
    subject VARCHAR(255) NOT NULL,                      -- Ticket subject/title
    description TEXT,                                   -- Detailed description of issue
    priority VARCHAR(20) DEFAULT 'medium',              -- Priority (low, medium, high, critical)
    status VARCHAR(20) DEFAULT 'open',                  -- Status (open, in_progress, resolved, closed)
    category VARCHAR(100),                              -- Category (Technical, Billing, General, etc.)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- When ticket was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    resolved_at TIMESTAMP NULL,                         -- When ticket was resolved
    resolution_time_minutes INT,                        -- Time to resolve in minutes
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (assigned_agent_id) REFERENCES support_agents(agent_id)
);

-- TICKET_COMMENTS TABLE: Stores comments and conversation history for support tickets
-- Use this table for queries about: ticket conversations, comment text, comment authors, internal notes, comment dates
CREATE TABLE ticket_comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each comment
    ticket_id INT,                                     -- Ticket this comment belongs to
    commenter_type VARCHAR(20) NOT NULL,               -- Type of commenter (agent, customer)
    commenter_id INT,                                  -- ID of person who commented
    comment_text TEXT,                                 -- Comment content
    is_internal BOOLEAN DEFAULT FALSE,                 -- Whether comment is internal (not visible to customer)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When comment was created
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id)
);

-- TICKET_ATTACHMENTS TABLE: Stores file attachments for support tickets
-- Use this table for queries about: attached files, file names, file sizes, upload dates, ticket files
CREATE TABLE ticket_attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each attachment
    ticket_id INT,                                     -- Ticket this file is attached to
    file_name VARCHAR(255),                            -- Original file name
    file_path VARCHAR(500),                            -- Path to stored file
    file_size INT,                                     -- File size in bytes
    uploaded_by INT,                                   -- User who uploaded the file
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- When file was uploaded
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id)
);

-- KNOWLEDGE_BASE TABLE: Stores help articles and documentation
-- Use this table for queries about: article titles, article content, categories, tags, view counts, helpful ratings, published articles
CREATE TABLE knowledge_base (
    article_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each article
    title VARCHAR(255) NOT NULL,                       -- Article title
    content TEXT,                                      -- Article content/body
    category VARCHAR(100),                             -- Article category
    tags VARCHAR(500),                                 -- Comma-separated tags
    author_id INT,                                     -- Agent who wrote the article
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When article was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Last update time
    view_count INT DEFAULT 0,                          -- Number of views
    helpful_count INT DEFAULT 0,                       -- Number of "helpful" votes
    is_published BOOLEAN DEFAULT FALSE,                -- Whether article is published
    FOREIGN KEY (author_id) REFERENCES support_agents(agent_id)
);

-- CUSTOMER_FEEDBACK TABLE: Stores customer satisfaction ratings and feedback
-- Use this table for queries about: customer ratings, feedback text, satisfaction scores, agent performance
CREATE TABLE customer_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each feedback
    ticket_id INT,                                     -- Ticket being rated
    customer_id INT,                                   -- Customer providing feedback
    agent_id INT,                                      -- Agent being rated
    rating INT CHECK (rating >= 1 AND rating <= 5),    -- Rating (1-5 stars)
    feedback_text TEXT,                                -- Feedback comments
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When feedback was submitted
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(ticket_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES support_agents(agent_id)
);

-- SLA_POLICIES TABLE: Stores Service Level Agreement policies and targets
-- Use this table for queries about: response times, resolution times, SLA targets, priority levels
CREATE TABLE sla_policies (
    sla_id INT AUTO_INCREMENT PRIMARY KEY,             -- Unique identifier for each SLA policy
    policy_name VARCHAR(255) NOT NULL,                 -- Policy name
    priority VARCHAR(20),                              -- Priority level (critical, high, medium, low)
    response_time_minutes INT,                         -- Target first response time in minutes
    resolution_time_minutes INT,                       -- Target resolution time in minutes
    is_active BOOLEAN DEFAULT TRUE                     -- Whether policy is active
);








CREATE INDEX idx_tickets_customer ON support_tickets(customer_id);
CREATE INDEX idx_tickets_agent ON support_tickets(assigned_agent_id);
CREATE INDEX idx_tickets_status ON support_tickets(status);
CREATE INDEX idx_tickets_priority ON support_tickets(priority);
CREATE INDEX idx_comments_ticket ON ticket_comments(ticket_id);
CREATE INDEX idx_feedback_ticket ON customer_feedback(ticket_id);
CREATE INDEX idx_kb_category ON knowledge_base(category);
