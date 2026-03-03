// Sample data for database
// This file is loaded after schema creation

db.authors.insertMany([
    {
        author_id: "author_001",
        name: "John Writer",
        email: "john.writer@content.com",
        bio: "Technology journalist with 10 years of experience covering AI and software development",
        avatar_url: "https://example.com/authors/john.jpg",
        social_links: {
            twitter: "@johnwriter",
            linkedin: "linkedin.com/in/johnwriter"
        },
        articles_count: 145,
        joined_date: new Date("2020-01-15T00:00:00Z")
    },
    {
        author_id: "author_002",
        name: "Sarah Blogger",
        email: "sarah.blogger@content.com",
        bio: "Lifestyle and wellness writer passionate about health and fitness",
        avatar_url: "https://example.com/authors/sarah.jpg",
        social_links: {
            twitter: "@sarahblogger",
            instagram: "@sarahwellness"
        },
        articles_count: 203,
        joined_date: new Date("2019-06-20T00:00:00Z")
    },
    {
        author_id: "author_003",
        name: "Mike Journalist",
        email: "mike.j@content.com",
        bio: "Business and finance reporter covering markets and economics",
        avatar_url: "https://example.com/authors/mike.jpg",
        social_links: {
            twitter: "@mikejournalist",
            linkedin: "linkedin.com/in/mikejournalist"
        },
        articles_count: 178,
        joined_date: new Date("2020-03-10T00:00:00Z")
    }
]);
db.categories.insertMany([
    {
        category_id: "cat_001",
        name: "Technology",
        slug: "technology",
        description: "Latest news and trends in technology",
        parent_category: null,
        articles_count: 450
    },
    {
        category_id: "cat_002",
        name: "Artificial Intelligence",
        slug: "artificial-intelligence",
        description: "AI and machine learning developments",
        parent_category: "cat_001",
        articles_count: 125
    },
    {
        category_id: "cat_003",
        name: "Health & Wellness",
        slug: "health-wellness",
        description: "Health, fitness, and wellness content",
        parent_category: null,
        articles_count: 320
    },
    {
        category_id: "cat_004",
        name: "Business",
        slug: "business",
        description: "Business news and insights",
        parent_category: null,
        articles_count: 280
    },
    {
        category_id: "cat_005",
        name: "Finance",
        slug: "finance",
        description: "Financial markets and investment",
        parent_category: "cat_004",
        articles_count: 95
    }
]);
db.tags.insertMany([
    { tag_id: "tag_001", name: "AI", slug: "ai", usage_count: 245 },
    { tag_id: "tag_002", name: "Machine Learning", slug: "machine-learning", usage_count: 198 },
    { tag_id: "tag_003", name: "Fitness", slug: "fitness", usage_count: 312 },
    { tag_id: "tag_004", name: "Nutrition", slug: "nutrition", usage_count: 267 },
    { tag_id: "tag_005", name: "Startups", slug: "startups", usage_count: 189 },
    { tag_id: "tag_006", name: "Investing", slug: "investing", usage_count: 156 }
]);
db.articles.insertMany([
    {
        article_id: "article_001",
        title: "The Future of Artificial Intelligence in 2024",
        slug: "future-of-ai-2024",
        author_id: "author_001",
        category_id: "cat_002",
        tags: ["tag_001", "tag_002"],
        excerpt: "Exploring the latest trends and developments in AI technology and what they mean for businesses and consumers.",
        content: "Artificial intelligence continues to evolve at a rapid pace. In 2024, we're seeing unprecedented advances in natural language processing, computer vision, and autonomous systems...",
        featured_image: {
            url: "https://example.com/images/ai-future.jpg",
            alt: "AI Future Concept",
            caption: "The future of AI is here"
        },
        status: "published",
        published_at: new Date("2024-03-15T10:00:00Z"),
        created_at: new Date("2024-03-14T15:00:00Z"),
        updated_at: new Date("2024-03-15T09:00:00Z"),
        views_count: 1250,
        likes_count: 89,
        comments_count: 23,
        reading_time_minutes: 8,
        seo: {
            meta_title: "The Future of AI in 2024 | Tech Insights",
            meta_description: "Discover the latest AI trends and what they mean for the future",
            keywords: ["AI", "artificial intelligence", "technology trends", "2024"]
        }
    },
    {
        article_id: "article_002",
        title: "10 Essential Fitness Tips for Beginners",
        slug: "fitness-tips-beginners",
        author_id: "author_002",
        category_id: "cat_003",
        tags: ["tag_003", "tag_004"],
        excerpt: "Starting your fitness journey? Here are 10 essential tips to help you succeed and stay motivated.",
        content: "Beginning a fitness routine can be challenging, but with the right approach, you can build sustainable habits. Here are our top 10 tips...",
        featured_image: {
            url: "https://example.com/images/fitness-tips.jpg",
            alt: "Fitness Training",
            caption: "Start your fitness journey today"
        },
        status: "published",
        published_at: new Date("2024-03-14T08:00:00Z"),
        created_at: new Date("2024-03-13T10:00:00Z"),
        updated_at: new Date("2024-03-14T07:00:00Z"),
        views_count: 2100,
        likes_count: 156,
        comments_count: 45,
        reading_time_minutes: 6,
        seo: {
            meta_title: "10 Fitness Tips for Beginners | Wellness Guide",
            meta_description: "Essential fitness tips to kickstart your health journey",
            keywords: ["fitness", "beginners", "health", "wellness", "exercise"]
        }
    },
    {
        article_id: "article_003",
        title: "Startup Funding Trends in 2024",
        slug: "startup-funding-trends-2024",
        author_id: "author_003",
        category_id: "cat_005",
        tags: ["tag_005", "tag_006"],
        excerpt: "An analysis of current venture capital trends and what startups need to know about raising funds in 2024.",
        content: "The startup funding landscape has evolved significantly. In 2024, investors are focusing on sustainable growth, profitability, and proven business models...",
        featured_image: {
            url: "https://example.com/images/startup-funding.jpg",
            alt: "Startup Funding",
            caption: "Understanding startup funding in 2024"
        },
        status: "published",
        published_at: new Date("2024-03-13T12:00:00Z"),
        created_at: new Date("2024-03-12T14:00:00Z"),
        updated_at: new Date("2024-03-13T11:00:00Z"),
        views_count: 1580,
        likes_count: 92,
        comments_count: 34,
        reading_time_minutes: 10,
        seo: {
            meta_title: "Startup Funding Trends 2024 | Business Insights",
            meta_description: "Latest trends in startup funding and venture capital",
            keywords: ["startups", "funding", "venture capital", "investment", "2024"]
        }
    },
    {
        article_id: "article_004",
        title: "Machine Learning Applications in Healthcare",
        slug: "ml-healthcare-applications",
        author_id: "author_001",
        category_id: "cat_002",
        tags: ["tag_001", "tag_002"],
        excerpt: "How machine learning is revolutionizing healthcare diagnosis and treatment.",
        content: "Machine learning is transforming healthcare in remarkable ways. From early disease detection to personalized treatment plans...",
        featured_image: {
            url: "https://example.com/images/ml-healthcare.jpg",
            alt: "ML in Healthcare",
            caption: "AI transforming healthcare"
        },
        status: "draft",
        published_at: null,
        created_at: new Date("2024-03-15T09:00:00Z"),
        updated_at: new Date("2024-03-15T11:00:00Z"),
        views_count: 0,
        likes_count: 0,
        comments_count: 0,
        reading_time_minutes: 12
    }
]);
db.comments.insertMany([
    {
        comment_id: "comment_001",
        article_id: "article_001",
        author_name: "Tech Reader",
        author_email: "reader@example.com",
        content: "Great article! Really insightful analysis of AI trends.",
        status: "approved",
        created_at: new Date("2024-03-15T11:00:00Z"),
        likes_count: 5,
        is_reply: false,
        parent_comment_id: null
    },
    {
        comment_id: "comment_002",
        article_id: "article_001",
        author_name: "AI Enthusiast",
        author_email: "ai@example.com",
        content: "Would love to see more content on neural networks!",
        status: "approved",
        created_at: new Date("2024-03-15T12:00:00Z"),
        likes_count: 3,
        is_reply: false,
        parent_comment_id: null
    },
    {
        comment_id: "comment_003",
        article_id: "article_002",
        author_name: "Fitness Newbie",
        author_email: "fitness@example.com",
        content: "These tips are exactly what I needed. Thank you!",
        status: "approved",
        created_at: new Date("2024-03-14T10:00:00Z"),
        likes_count: 8,
        is_reply: false,
        parent_comment_id: null
    }
]);
db.media.insertMany([
    {
        media_id: "media_001",
        filename: "ai-future.jpg",
        original_filename: "artificial-intelligence-concept.jpg",
        url: "https://example.com/images/ai-future.jpg",
        type: "image",
        mime_type: "image/jpeg",
        size_bytes: 245678,
        dimensions: {
            width: 1920,
            height: 1080
        },
        uploaded_by: "author_001",
        uploaded_at: new Date("2024-03-14T14:00:00Z"),
        alt_text: "AI Future Concept",
        usage_count: 1
    },
    {
        media_id: "media_002",
        filename: "fitness-tips.jpg",
        original_filename: "fitness-training.jpg",
        url: "https://example.com/images/fitness-tips.jpg",
        type: "image",
        mime_type: "image/jpeg",
        size_bytes: 198456,
        dimensions: {
            width: 1920,
            height: 1080
        },
        uploaded_by: "author_002",
        uploaded_at: new Date("2024-03-13T09:00:00Z"),
        alt_text: "Fitness Training",
        usage_count: 1
    }
]);
