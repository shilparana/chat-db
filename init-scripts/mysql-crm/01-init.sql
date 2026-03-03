-- CONTACTS TABLE: Stores customer relationship management contact information
-- Use this table for queries about: contact names, emails, phone numbers, companies, job titles, contact addresses, contact sources, contact status, last contacted dates
CREATE TABLE contacts (
    contact_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique identifier for each contact
    first_name VARCHAR(100) NOT NULL,                    -- Contact's first name
    last_name VARCHAR(100) NOT NULL,                     -- Contact's last name
    email VARCHAR(255) UNIQUE NOT NULL,                  -- Contact's email address (unique)
    phone VARCHAR(20),                                   -- Contact's phone number
    company VARCHAR(255),                                -- Company the contact works for
    job_title VARCHAR(100),                              -- Contact's job title/position
    address TEXT,                                        -- Street address
    city VARCHAR(100),                                   -- City
    state VARCHAR(50),                                   -- State/province
    country VARCHAR(100),                                -- Country
    postal_code VARCHAR(20),                             -- Postal/ZIP code
    source VARCHAR(50),                                  -- How contact was acquired (referral, website, cold_call, linkedin, etc.)
    status VARCHAR(20) DEFAULT 'active',                 -- Contact status (active, inactive)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- When contact was created
    last_contacted TIMESTAMP NULL                        -- Last time contact was reached
);

-- COMPANIES TABLE: Stores company/organization information for B2B relationships
-- Use this table for queries about: company names, industries, websites, company contact info, employee counts, annual revenue, company locations
CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique identifier for each company
    company_name VARCHAR(255) NOT NULL,                  -- Company/organization name
    industry VARCHAR(100),                               -- Industry sector (Technology, Manufacturing, Healthcare, etc.)
    website VARCHAR(255),                                -- Company website URL
    phone VARCHAR(20),                                   -- Company main phone number
    email VARCHAR(255),                                  -- Company general email
    address TEXT,                                        -- Company street address
    city VARCHAR(100),                                   -- City
    state VARCHAR(50),                                   -- State/province
    country VARCHAR(100),                                -- Country
    postal_code VARCHAR(20),                             -- Postal/ZIP code
    employee_count INT,                                  -- Number of employees
    annual_revenue DECIMAL(15, 2),                       -- Annual revenue in dollars
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP       -- When company record was created
);

-- OPPORTUNITIES TABLE: Stores sales opportunities and deals in the pipeline
-- Use this table for queries about: opportunity names, deal values, sales stages, probabilities, close dates, opportunity status, sales pipeline
CREATE TABLE opportunities (
    opportunity_id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique identifier for each opportunity
    contact_id INT,                                      -- Primary contact for this opportunity
    company_id INT,                                      -- Company associated with opportunity
    opportunity_name VARCHAR(255) NOT NULL,              -- Name/title of the opportunity
    description TEXT,                                    -- Detailed description of the opportunity
    value DECIMAL(12, 2),                                -- Potential deal value in dollars
    stage VARCHAR(50) DEFAULT 'prospecting',             -- Sales stage (prospecting, qualification, proposal, negotiation, closed_won, closed_lost)
    probability INT,                                     -- Win probability percentage (0-100)
    expected_close_date DATE,                            -- Expected date to close the deal
    actual_close_date DATE,                              -- Actual date deal was closed
    status VARCHAR(20) DEFAULT 'open',                   -- Opportunity status (open, closed)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- When opportunity was created
    FOREIGN KEY (contact_id) REFERENCES contacts(contact_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

-- ACTIVITIES TABLE: Tracks sales activities and interactions with contacts
-- Use this table for queries about: activity types, meetings, calls, emails, activity dates, activity duration, activity status, contact interactions
CREATE TABLE activities (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each activity
    contact_id INT,                                      -- Contact involved in activity
    opportunity_id INT,                                  -- Related opportunity (if any)
    activity_type VARCHAR(50) NOT NULL,                  -- Type of activity (meeting, call, email, demo, etc.)
    subject VARCHAR(255),                                -- Activity subject/title
    description TEXT,                                    -- Detailed description of activity
    activity_date TIMESTAMP,                             -- When activity occurred/scheduled
    duration_minutes INT,                                -- Duration in minutes
    status VARCHAR(20) DEFAULT 'scheduled',              -- Activity status (scheduled, completed, cancelled)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- When activity was logged
    FOREIGN KEY (contact_id) REFERENCES contacts(contact_id),
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id)
);

-- NOTES TABLE: Stores notes and comments about contacts and opportunities
-- Use this table for queries about: contact notes, opportunity notes, note text, note authors, note dates
CREATE TABLE notes (
    note_id INT AUTO_INCREMENT PRIMARY KEY,              -- Unique identifier for each note
    contact_id INT,                                      -- Contact the note is about
    opportunity_id INT,                                  -- Opportunity the note is about
    note_text TEXT,                                      -- Note content/text
    created_by VARCHAR(100),                             -- User who created the note
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- When note was created
    FOREIGN KEY (contact_id) REFERENCES contacts(contact_id),
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id)
);

-- TASKS TABLE: Stores tasks and to-do items for sales team
-- Use this table for queries about: task names, due dates, task priorities, task status, assigned tasks, pending tasks, completed tasks
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,              -- Unique identifier for each task
    contact_id INT,                                      -- Related contact (if any)
    opportunity_id INT,                                  -- Related opportunity (if any)
    task_name VARCHAR(255) NOT NULL,                     -- Task name/title
    description TEXT,                                    -- Task description/details
    due_date DATE,                                       -- Task due date
    priority VARCHAR(20) DEFAULT 'medium',               -- Task priority (low, medium, high)
    status VARCHAR(20) DEFAULT 'pending',                -- Task status (pending, in_progress, completed)
    assigned_to VARCHAR(100),                            -- User assigned to task
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,      -- When task was created
    FOREIGN KEY (contact_id) REFERENCES contacts(contact_id),
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id)
);







CREATE INDEX idx_contacts_email ON contacts(email);
CREATE INDEX idx_contacts_company ON contacts(company);
CREATE INDEX idx_opportunities_contact ON opportunities(contact_id);
CREATE INDEX idx_opportunities_stage ON opportunities(stage);
CREATE INDEX idx_activities_contact ON activities(contact_id);
CREATE INDEX idx_tasks_status ON tasks(status);
