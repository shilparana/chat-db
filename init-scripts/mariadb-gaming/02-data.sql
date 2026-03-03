-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO players (username, email, display_name, level, experience_points, coins, gems, country) VALUES
('DragonSlayer99', 'dragon@gamer.com', 'Dragon Slayer', 45, 125000, 50000, 1200, 'USA'),
('MagicMaster', 'magic@gamer.com', 'Magic Master', 38, 95000, 38000, 850, 'UK'),
('ShadowNinja', 'shadow@gamer.com', 'Shadow Ninja', 42, 110000, 45000, 1000, 'Canada'),
('FireWarrior', 'fire@gamer.com', 'Fire Warrior', 35, 82000, 32000, 720, 'Australia'),
('IceQueen', 'ice@gamer.com', 'Ice Queen', 40, 102000, 42000, 950, 'Germany'),
('ThunderKnight', 'thunder@gamer.com', 'Thunder Knight', 37, 88000, 35000, 800, 'France'),
('NatureHealer', 'nature@gamer.com', 'Nature Healer', 33, 75000, 28000, 650, 'Japan'),
('DarkSorcerer', 'dark@gamer.com', 'Dark Sorcerer', 41, 105000, 43000, 980, 'Brazil');
INSERT INTO characters (player_id, character_name, character_class, level, health_points, mana_points, strength, agility, intelligence) VALUES
(1, 'Dragonborn', 'Warrior', 45, 4500, 1000, 95, 70, 45),
(2, 'Merlin', 'Mage', 38, 2800, 4200, 40, 55, 98),
(3, 'Shadowblade', 'Rogue', 42, 3500, 1500, 75, 95, 60),
(4, 'Inferno', 'Warrior', 35, 3800, 900, 88, 65, 42),
(5, 'Frostbite', 'Mage', 40, 3000, 4000, 45, 60, 95),
(6, 'Stormbreaker', 'Paladin', 37, 4000, 2000, 80, 70, 65),
(7, 'Leafwhisper', 'Cleric', 33, 3200, 3500, 50, 60, 85),
(8, 'Voidwalker', 'Warlock', 41, 3100, 3900, 48, 62, 92);
INSERT INTO items (item_name, item_type, rarity, description, base_value, level_requirement, is_tradeable) VALUES
('Legendary Sword of Fire', 'weapon', 'legendary', 'A powerful sword imbued with fire magic', 10000, 40, TRUE),
('Dragon Scale Armor', 'armor', 'epic', 'Armor crafted from dragon scales', 7500, 35, TRUE),
('Staff of Wisdom', 'weapon', 'rare', 'Increases magical power significantly', 5000, 30, TRUE),
('Shadow Cloak', 'armor', 'epic', 'Grants invisibility for short periods', 6000, 38, TRUE),
('Health Potion', 'consumable', 'common', 'Restores 500 health points', 50, 1, TRUE),
('Mana Potion', 'consumable', 'common', 'Restores 300 mana points', 40, 1, TRUE),
('Ring of Strength', 'accessory', 'rare', 'Increases strength by 15', 3000, 25, TRUE),
('Amulet of Intelligence', 'accessory', 'rare', 'Increases intelligence by 20', 3500, 25, TRUE),
('Boots of Speed', 'armor', 'uncommon', 'Increases movement speed', 1500, 20, TRUE),
('Elixir of Experience', 'consumable', 'rare', 'Grants 5000 experience points', 2000, 1, TRUE);
INSERT INTO player_inventory (player_id, item_id, quantity, is_equipped) VALUES
(1, 1, 1, TRUE),
(1, 2, 1, TRUE),
(1, 5, 10, FALSE),
(2, 3, 1, TRUE),
(2, 8, 1, TRUE),
(2, 6, 15, FALSE),
(3, 4, 1, TRUE),
(3, 9, 1, TRUE),
(4, 1, 1, FALSE),
(5, 3, 1, TRUE);
INSERT INTO quests (quest_name, description, quest_type, level_requirement, experience_reward, coin_reward) VALUES
('Defeat the Dragon King', 'Slay the mighty Dragon King in his lair', 'main', 40, 50000, 10000),
('Collect Ancient Artifacts', 'Find 5 ancient artifacts scattered across the realm', 'side', 30, 25000, 5000),
('Rescue the Princess', 'Save the princess from the dark tower', 'main', 35, 35000, 7000),
('Hunt 100 Wolves', 'Defeat 100 wolves in the northern forest', 'daily', 20, 5000, 1000),
('Gather Rare Herbs', 'Collect 20 rare herbs for the alchemist', 'side', 25, 15000, 3000),
('Explore the Dungeon', 'Complete exploration of the ancient dungeon', 'main', 38, 40000, 8000);
INSERT INTO player_quests (player_id, quest_id, status, progress) VALUES
(1, 1, 'in_progress', 75),
(1, 4, 'completed', 100),
(2, 2, 'in_progress', 60),
(3, 3, 'completed', 100),
(4, 4, 'in_progress', 45),
(5, 6, 'in_progress', 80);
INSERT INTO achievements (achievement_name, description, category, points, is_hidden) VALUES
('First Blood', 'Defeat your first enemy', 'combat', 10, FALSE),
('Level 10 Reached', 'Reach character level 10', 'progression', 25, FALSE),
('Dragon Slayer', 'Defeat a dragon', 'combat', 100, FALSE),
('Treasure Hunter', 'Find 50 treasure chests', 'exploration', 50, FALSE),
('Master Craftsman', 'Craft 100 items', 'crafting', 75, FALSE),
('Legendary Hero', 'Complete all main quests', 'progression', 200, FALSE),
('Millionaire', 'Accumulate 1,000,000 coins', 'wealth', 150, FALSE),
('Secret Discovery', 'Find the hidden temple', 'exploration', 100, TRUE);
INSERT INTO player_achievements (player_id, achievement_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(3, 3);
INSERT INTO game_sessions (player_id, start_time, end_time, duration_minutes, experience_gained, coins_earned) VALUES
(1, '2024-03-14 18:00:00', '2024-03-14 20:30:00', 150, 5000, 2000),
(2, '2024-03-14 19:00:00', '2024-03-14 21:00:00', 120, 4000, 1500),
(3, '2024-03-15 14:00:00', '2024-03-15 16:45:00', 165, 5500, 2200),
(1, '2024-03-15 18:00:00', '2024-03-15 19:30:00', 90, 3000, 1200);
INSERT INTO leaderboards (player_id, category, score, rank_position, season) VALUES
(1, 'experience', 125000, 1, 'Season 3'),
(3, 'experience', 110000, 2, 'Season 3'),
(5, 'experience', 102000, 3, 'Season 3'),
(2, 'experience', 95000, 4, 'Season 3'),
(1, 'pvp_wins', 450, 1, 'Season 3'),
(3, 'pvp_wins', 380, 2, 'Season 3');
