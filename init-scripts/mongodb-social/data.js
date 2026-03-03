// Sample data for database
// This file is loaded after schema creation

db.users.insertMany([
    {
        user_id: "social_user_001",
        username: "tech_enthusiast",
        display_name: "Tech Enthusiast",
        email: "tech@social.com",
        bio: "Passionate about technology and innovation",
        avatar_url: "https://example.com/avatars/user001.jpg",
        created_at: new Date("2023-01-15T00:00:00Z"),
        followers_count: 1250,
        following_count: 380,
        posts_count: 156,
        verified: true,
        location: "San Francisco, CA",
        website: "https://techblog.example.com"
    },
    {
        user_id: "social_user_002",
        username: "creative_designer",
        display_name: "Creative Designer",
        email: "design@social.com",
        bio: "UI/UX Designer | Creating beautiful experiences",
        avatar_url: "https://example.com/avatars/user002.jpg",
        created_at: new Date("2023-03-20T00:00:00Z"),
        followers_count: 2100,
        following_count: 450,
        posts_count: 203,
        verified: true,
        location: "New York, NY",
        website: "https://designportfolio.example.com"
    },
    {
        user_id: "social_user_003",
        username: "fitness_guru",
        display_name: "Fitness Guru",
        email: "fitness@social.com",
        bio: "Certified personal trainer | Health & Wellness",
        avatar_url: "https://example.com/avatars/user003.jpg",
        created_at: new Date("2023-06-10T00:00:00Z"),
        followers_count: 3500,
        following_count: 280,
        posts_count: 412,
        verified: false,
        location: "Los Angeles, CA"
    }
]);
db.posts.insertMany([
    {
        post_id: "post_001",
        user_id: "social_user_001",
        content: "Just launched my new tech blog! Check it out for the latest in AI and machine learning. #TechNews #AI",
        media: [
            {
                type: "image",
                url: "https://example.com/posts/post001_img1.jpg"
            }
        ],
        created_at: new Date("2024-03-15T10:00:00Z"),
        likes_count: 245,
        comments_count: 32,
        shares_count: 18,
        hashtags: ["TechNews", "AI"],
        mentions: [],
        visibility: "public"
    },
    {
        post_id: "post_002",
        user_id: "social_user_002",
        content: "New design system released! Featuring modern components and accessibility-first approach. What do you think?",
        media: [
            {
                type: "image",
                url: "https://example.com/posts/post002_img1.jpg"
            },
            {
                type: "image",
                url: "https://example.com/posts/post002_img2.jpg"
            }
        ],
        created_at: new Date("2024-03-15T11:30:00Z"),
        likes_count: 412,
        comments_count: 56,
        shares_count: 34,
        hashtags: ["Design", "UX", "UI"],
        mentions: ["social_user_001"],
        visibility: "public"
    },
    {
        post_id: "post_003",
        user_id: "social_user_003",
        content: "Morning workout complete! 💪 Remember, consistency is key to achieving your fitness goals. #FitnessMotivation",
        media: [
            {
                type: "video",
                url: "https://example.com/posts/post003_video.mp4",
                thumbnail: "https://example.com/posts/post003_thumb.jpg"
            }
        ],
        created_at: new Date("2024-03-15T07:00:00Z"),
        likes_count: 892,
        comments_count: 78,
        shares_count: 45,
        hashtags: ["FitnessMotivation", "Workout"],
        mentions: [],
        visibility: "public"
    }
]);
db.comments.insertMany([
    {
        comment_id: "comment_001",
        post_id: "post_001",
        user_id: "social_user_002",
        content: "Great article! Really enjoyed the section on neural networks.",
        created_at: new Date("2024-03-15T10:30:00Z"),
        likes_count: 12,
        replies_count: 2
    },
    {
        comment_id: "comment_002",
        post_id: "post_001",
        user_id: "social_user_003",
        content: "This is exactly what I was looking for. Thanks for sharing!",
        created_at: new Date("2024-03-15T11:00:00Z"),
        likes_count: 8,
        replies_count: 0
    },
    {
        comment_id: "comment_003",
        post_id: "post_002",
        user_id: "social_user_001",
        content: "Love the color palette! Very modern and clean.",
        created_at: new Date("2024-03-15T12:00:00Z"),
        likes_count: 25,
        replies_count: 1
    },
    {
        comment_id: "comment_004",
        post_id: "post_003",
        user_id: "social_user_001",
        content: "Inspiring! What's your workout routine?",
        created_at: new Date("2024-03-15T07:30:00Z"),
        likes_count: 15,
        replies_count: 1
    }
]);
db.likes.insertMany([
    {
        like_id: "like_001",
        user_id: "social_user_002",
        target_type: "post",
        target_id: "post_001",
        created_at: new Date("2024-03-15T10:15:00Z")
    },
    {
        like_id: "like_002",
        user_id: "social_user_003",
        target_type: "post",
        target_id: "post_001",
        created_at: new Date("2024-03-15T10:20:00Z")
    },
    {
        like_id: "like_003",
        user_id: "social_user_001",
        target_type: "post",
        target_id: "post_002",
        created_at: new Date("2024-03-15T11:45:00Z")
    },
    {
        like_id: "like_004",
        user_id: "social_user_001",
        target_type: "comment",
        target_id: "comment_003",
        created_at: new Date("2024-03-15T12:05:00Z")
    }
]);
db.follows.insertMany([
    {
        follow_id: "follow_001",
        follower_id: "social_user_001",
        following_id: "social_user_002",
        created_at: new Date("2023-04-01T00:00:00Z")
    },
    {
        follow_id: "follow_002",
        follower_id: "social_user_001",
        following_id: "social_user_003",
        created_at: new Date("2023-07-15T00:00:00Z")
    },
    {
        follow_id: "follow_003",
        follower_id: "social_user_002",
        following_id: "social_user_001",
        created_at: new Date("2023-04-05T00:00:00Z")
    },
    {
        follow_id: "follow_004",
        follower_id: "social_user_003",
        following_id: "social_user_001",
        created_at: new Date("2023-08-20T00:00:00Z")
    }
]);
db.messages.insertMany([
    {
        message_id: "msg_001",
        conversation_id: "conv_001",
        sender_id: "social_user_001",
        recipient_id: "social_user_002",
        content: "Hey! Loved your latest design work. Would you be interested in collaborating?",
        created_at: new Date("2024-03-14T15:00:00Z"),
        read: true,
        read_at: new Date("2024-03-14T15:30:00Z")
    },
    {
        message_id: "msg_002",
        conversation_id: "conv_001",
        sender_id: "social_user_002",
        recipient_id: "social_user_001",
        content: "Thanks! I'd love to collaborate. What did you have in mind?",
        created_at: new Date("2024-03-14T15:35:00Z"),
        read: true,
        read_at: new Date("2024-03-14T16:00:00Z")
    },
    {
        message_id: "msg_003",
        conversation_id: "conv_002",
        sender_id: "social_user_003",
        recipient_id: "social_user_001",
        content: "Great post about AI! Can you recommend some resources for beginners?",
        created_at: new Date("2024-03-15T12:00:00Z"),
        read: false
    }
]);
