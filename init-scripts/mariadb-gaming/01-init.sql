-- PLAYERS TABLE: Stores information about game players, user accounts, and their progression
-- Use this table for queries about: player accounts, user profiles, player levels, experience, currency (coins/gems), registration, login activity, player status
CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each player
    username VARCHAR(100) UNIQUE NOT NULL,      -- Player's unique login username
    email VARCHAR(255) UNIQUE NOT NULL,         -- Player's email address for account
    password_hash VARCHAR(255),                 -- Encrypted password
    display_name VARCHAR(100),                  -- Public display name shown in game
    level INT DEFAULT 1,                        -- Player's current level (progression metric)
    experience_points INT DEFAULT 0,            -- Total XP earned (used for leveling up)
    coins INT DEFAULT 1000,                     -- In-game currency (earned through gameplay)
    gems INT DEFAULT 50,                        -- Premium currency (purchased or rare rewards)
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- When player created account
    last_login TIMESTAMP NULL,                  -- Last time player logged in
    is_active BOOLEAN DEFAULT TRUE,             -- Whether account is active
    is_banned BOOLEAN DEFAULT FALSE,            -- Whether player is banned
    country VARCHAR(100),                       -- Player's country/region
    avatar_url VARCHAR(500)                     -- URL to player's avatar image
);

-- CHARACTERS TABLE: Stores player's in-game characters with their stats and attributes
-- Use this table for queries about: character names, classes, character levels, stats (health/mana/strength/agility/intelligence), character creation, active characters
CREATE TABLE characters (
    character_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each character
    player_id INT,                                 -- Links to player who owns this character
    character_name VARCHAR(100) NOT NULL,          -- Character's name in the game
    character_class VARCHAR(50),                   -- Character class (Warrior, Mage, Rogue, Paladin, Cleric, Warlock)
    level INT DEFAULT 1,                           -- Character's current level
    health_points INT,                             -- HP - determines survivability
    mana_points INT,                               -- MP - used for casting spells/abilities
    strength INT,                                  -- STR stat - affects physical damage
    agility INT,                                   -- AGI stat - affects speed and dodge
    intelligence INT,                              -- INT stat - affects magical power
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- When character was created
    last_played TIMESTAMP NULL,                    -- Last time character was used
    is_active BOOLEAN DEFAULT TRUE,                -- Whether character is currently active
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- ITEMS TABLE: Stores all available items in the game (weapons, armor, consumables, accessories)
-- Use this table for queries about: item names, item types, rarity levels, item descriptions, item values, level requirements, tradeable items
CREATE TABLE items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each item
    item_name VARCHAR(255) NOT NULL,         -- Name of the item
    item_type VARCHAR(50),                   -- Type: weapon, armor, consumable, accessory
    rarity VARCHAR(20),                      -- Rarity: common, uncommon, rare, epic, legendary
    description TEXT,                        -- Detailed description of item and its effects
    base_value INT,                          -- Base price/value in coins
    level_requirement INT,                   -- Minimum level required to use item
    stats JSON,                              -- Additional stats/bonuses provided by item
    is_tradeable BOOLEAN DEFAULT TRUE        -- Whether item can be traded between players
);

-- PLAYER_INVENTORY TABLE: Tracks which items each player owns and their equipped status
-- Use this table for queries about: player items, inventory contents, equipped items, item quantities, when items were acquired
CREATE TABLE player_inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for inventory entry
    player_id INT,                                 -- Which player owns this item
    item_id INT,                                   -- Which item is in inventory
    quantity INT DEFAULT 1,                        -- How many of this item player has
    acquired_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- When item was obtained
    is_equipped BOOLEAN DEFAULT FALSE,             -- Whether item is currently equipped/in use
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- QUESTS TABLE: Stores all available quests/missions in the game
-- Use this table for queries about: quest names, quest descriptions, quest types, level requirements, rewards (experience/coins/items), active quests
CREATE TABLE quests (
    quest_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each quest
    quest_name VARCHAR(255) NOT NULL,         -- Name of the quest/mission
    description TEXT,                         -- Detailed quest description and objectives
    quest_type VARCHAR(50),                   -- Type: main, side, daily, weekly
    level_requirement INT,                    -- Minimum level required to start quest
    experience_reward INT,                    -- XP awarded upon completion
    coin_reward INT,                          -- Coins awarded upon completion
    item_rewards JSON,                        -- Items awarded upon completion
    is_active BOOLEAN DEFAULT TRUE            -- Whether quest is currently available
);

-- PLAYER_QUESTS TABLE: Tracks each player's quest progress and completion status
-- Use this table for queries about: quest progress, completed quests, active quests, quest status, quest completion times
CREATE TABLE player_quests (
    player_quest_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for player's quest instance
    player_id INT,                                    -- Which player is doing this quest
    quest_id INT,                                     -- Which quest is being tracked
    status VARCHAR(20) DEFAULT 'in_progress',        -- Status: in_progress, completed, failed, abandoned
    progress INT DEFAULT 0,                           -- Progress percentage (0-100)
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- When player started the quest
    completed_at TIMESTAMP NULL,                      -- When player completed the quest (NULL if not completed)
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (quest_id) REFERENCES quests(quest_id)
);

-- ACHIEVEMENTS TABLE: Stores all available achievements/trophies that players can unlock
-- Use this table for queries about: achievement names, achievement descriptions, achievement categories, achievement points, hidden achievements
CREATE TABLE achievements (
    achievement_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each achievement
    achievement_name VARCHAR(255) NOT NULL,         -- Name of the achievement/trophy
    description TEXT,                               -- Description of how to unlock achievement
    category VARCHAR(50),                           -- Category: combat, progression, exploration, crafting, wealth
    points INT,                                     -- Achievement points awarded
    icon_url VARCHAR(500),                          -- URL to achievement icon/badge
    is_hidden BOOLEAN DEFAULT FALSE                 -- Whether achievement is hidden until unlocked
);

-- PLAYER_ACHIEVEMENTS TABLE: Tracks which achievements each player has unlocked
-- Use this table for queries about: unlocked achievements, achievement counts, when achievements were earned, player achievement progress
CREATE TABLE player_achievements (
    player_achievement_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for player's achievement unlock
    player_id INT,                                          -- Which player unlocked the achievement
    achievement_id INT,                                     -- Which achievement was unlocked
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,        -- When the achievement was unlocked
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id)
);

-- GAME_SESSIONS TABLE: Tracks player gaming sessions and activity
-- Use this table for queries about: play time, session duration, experience gained per session, coins earned per session, player activity
CREATE TABLE game_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each gaming session
    player_id INT,                               -- Which player this session belongs to
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- When session started
    end_time TIMESTAMP NULL,                     -- When session ended (NULL if still active)
    duration_minutes INT,                        -- Total session length in minutes
    experience_gained INT DEFAULT 0,             -- XP earned during this session
    coins_earned INT DEFAULT 0,                  -- Coins earned during this session
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

-- LEADERBOARDS TABLE: Stores player rankings across different competitive categories
-- Use this table for queries about: player rankings, leaderboard positions, top players, scores, competitive seasons, leaderboard categories
CREATE TABLE leaderboards (
    leaderboard_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for leaderboard entry
    player_id INT,                                   -- Which player this ranking is for
    category VARCHAR(50),                            -- Leaderboard category: experience, pvp_wins, achievements, etc.
    score INT,                                       -- Player's score in this category
    rank_position INT,                               -- Player's rank/position (1 = first place)
    season VARCHAR(50),                              -- Which competitive season this ranking is for
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Last time ranking was updated
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);











CREATE INDEX idx_players_username ON players(username);
CREATE INDEX idx_characters_player ON characters(player_id);
CREATE INDEX idx_inventory_player ON player_inventory(player_id);
CREATE INDEX idx_player_quests_player ON player_quests(player_id);
CREATE INDEX idx_player_achievements_player ON player_achievements(player_id);
CREATE INDEX idx_sessions_player ON game_sessions(player_id);
CREATE INDEX idx_leaderboards_category ON leaderboards(category);
