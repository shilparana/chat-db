db = db.getSiblingDB('content_db');

// ARTICLES COLLECTION: Stores blog articles and content
// Use this collection for queries about: article titles, article slugs, article content, excerpts, authors, categories, tags, publication status, published dates, view counts, likes counts, comments counts, reading time, SEO metadata, featured images
db.createCollection('articles');

// AUTHORS COLLECTION: Stores content author information
// Use this collection for queries about: author names, author emails, author bios, avatars, social links, article counts, joined dates
db.createCollection('authors');

// CATEGORIES COLLECTION: Stores content categories and hierarchical structure
// Use this collection for queries about: category names, category slugs, category descriptions, parent categories, article counts per category
db.createCollection('categories');

// TAGS COLLECTION: Stores content tags for organization
// Use this collection for queries about: tag names, tag slugs, tag usage counts
db.createCollection('tags');

// COMMENTS COLLECTION: Stores reader comments on articles
// Use this collection for queries about: comment content, comment authors, article comments, comment status, comment timestamps, comment likes, replies
db.createCollection('comments');

// MEDIA COLLECTION: Stores uploaded media files and images
// Use this collection for queries about: media files, images, filenames, URLs, file types, file sizes, dimensions, upload dates, alt text, media usage
db.createCollection('media');







db.articles.createIndex({ slug: 1 }, { unique: true });
db.articles.createIndex({ author_id: 1 });
db.articles.createIndex({ category_id: 1 });
db.articles.createIndex({ status: 1 });
db.articles.createIndex({ published_at: -1 });
db.articles.createIndex({ tags: 1 });
db.authors.createIndex({ email: 1 }, { unique: true });
db.categories.createIndex({ slug: 1 }, { unique: true });
db.tags.createIndex({ slug: 1 }, { unique: true });
db.comments.createIndex({ article_id: 1 });
db.comments.createIndex({ status: 1 });
db.media.createIndex({ uploaded_by: 1 });
