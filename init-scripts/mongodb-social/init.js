db = db.getSiblingDB('social_db');

// USERS COLLECTION: Stores social media user profiles and account information
// Use this collection for queries about: usernames, display names, emails, bios, avatars, follower counts, following counts, post counts, verified users, locations, websites
db.createCollection('users');

// POSTS COLLECTION: Stores user posts and social media content
// Use this collection for queries about: post content, media attachments, images, videos, post timestamps, likes counts, comments counts, shares counts, hashtags, mentions, visibility
db.createCollection('posts');

// COMMENTS COLLECTION: Stores comments on posts
// Use this collection for queries about: comment text, comment authors, post comments, comment timestamps, comment likes, replies counts
db.createCollection('comments');

// LIKES COLLECTION: Stores likes on posts and comments
// Use this collection for queries about: user likes, post likes, comment likes, like timestamps, target types
db.createCollection('likes');

// FOLLOWS COLLECTION: Stores follower/following relationships
// Use this collection for queries about: followers, following, follow relationships, follow dates
db.createCollection('follows');

// MESSAGES COLLECTION: Stores direct messages between users
// Use this collection for queries about: message content, senders, recipients, conversations, read status, message timestamps
db.createCollection('messages');







db.users.createIndex({ username: 1 }, { unique: true });
db.users.createIndex({ email: 1 }, { unique: true });
db.posts.createIndex({ user_id: 1 });
db.posts.createIndex({ created_at: -1 });
db.posts.createIndex({ hashtags: 1 });
db.comments.createIndex({ post_id: 1 });
db.comments.createIndex({ user_id: 1 });
db.likes.createIndex({ user_id: 1, target_type: 1, target_id: 1 });
db.follows.createIndex({ follower_id: 1 });
db.follows.createIndex({ following_id: 1 });
db.messages.createIndex({ conversation_id: 1 });
db.messages.createIndex({ sender_id: 1 });
db.messages.createIndex({ recipient_id: 1 });
