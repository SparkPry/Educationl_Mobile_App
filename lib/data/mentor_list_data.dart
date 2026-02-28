import '../models/mentor_model.dart';
import '../models/user_model.dart'; // Assuming MentorReview might use UserModel in future, or just for consistency

final List<Mentor> allMentors = [
  Mentor(
    name: "Alice",
    profileImage: "assets/images/Alice.jpg",
    title: "Senior Product Designer",
    about: "Experienced mentor with a passion for teaching and helping students achieve their goals in the field of design and technology. I have over 10 years of experience in the industry and have worked with several top-tier companies.",
    courses: ["UI/UX Design", "Graphic Design", "Web Design"],
    students: "1,250",
    rating: "4.8",
    reviewsCount: "450",
    reviews: [
      MentorReview(
        userName: "Alex Johnson",
        comment: "Amazing mentor! Really helped me understand the core concepts of UI/UX.",
        rating: 5.0,
        date: "2 days ago",
      ),
      MentorReview(
        userName: "Sarah Williams",
        comment: "The courses are well-structured and easy to follow.",
        rating: 4.5,
        date: "1 week ago",
      ),
    ],
  ),
  Mentor(
    name: "Bob",
    profileImage: "assets/images/Bob.jpg",
    title: "Lead Software Engineer",
    about: "A seasoned software engineer specializing in mobile and web development. I love to guide aspiring developers to build robust and scalable applications. My focus areas include Flutter, Node.js, and cloud platforms.",
    courses: ["Flutter App Development", "Node.js REST APIs", "Cloud Fundamentals"],
    students: "980",
    rating: "4.9",
    reviewsCount: "380",
    reviews: [
      MentorReview(
        userName: "Michael Brown",
        comment: "Bob's Flutter course was a game-changer for me!",
        rating: 5.0,
        date: "3 days ago",
      ),
      MentorReview(
        userName: "Emily Davis",
        comment: "Very clear explanations and practical examples.",
        rating: 4.8,
        date: "2 weeks ago",
      ),
    ],
  ),
  Mentor(
    name: "Charlie",
    profileImage: "assets/images/Charlie.jpg",
    title: "Data Scientist",
    about: "Passionate about data and its power to drive insights. I mentor students in machine learning, statistical analysis, and Python programming for data science. My goal is to make complex concepts easy to understand.",
    courses: ["Machine Learning with Python", "Data Visualization", "Statistical Analysis"],
    students: "1,100",
    rating: "4.7",
    reviewsCount: "420",
    reviews: [
      MentorReview(
        userName: "David Garcia",
        comment: "Charlie's teaching style is excellent, highly recommend!",
        rating: 4.9,
        date: "5 days ago",
      ),
      MentorReview(
        userName: "Jessica Rodriguez",
        comment: "Learned so much about Python for data science.",
        rating: 4.7,
        date: "1 month ago",
      ),
    ],
  ),
  Mentor(
    name: "Diana",
    profileImage: "assets/images/Diana.jpg",
    title: "Digital Marketing Strategist",
    about: "Expert in crafting and executing digital marketing strategies that deliver results. I help students master SEO, social media marketing, content creation, and analytics to build strong online presences.",
    courses: ["SEO Fundamentals", "Social Media Marketing", "Content Strategy"],
    students: "750",
    rating: "4.6",
    reviewsCount: "310",
    reviews: [
      MentorReview(
        userName: "Chris Wilson",
        comment: "Practical advice and real-world examples, very useful.",
        rating: 4.8,
        date: "1 week ago",
      ),
      MentorReview(
        userName: "Laura Martinez",
        comment: "Improved my company's SEO significantly after this course.",
        rating: 4.6,
        date: "3 weeks ago",
      ),
    ],
  ),
  Mentor(
    name: "Eve",
    profileImage: "assets/images/Eve.jpg",
    title: "UI/UX Designer",
    about: "Dedicated to creating intuitive and aesthetically pleasing user experiences. I guide students through the entire UI/UX design process, from user research to prototyping and testing, using industry-standard tools.",
    courses: ["UI/UX Design Principles", "Figma for UI/UX", "User Research Methods"],
    students: "1,500",
    rating: "4.9",
    reviewsCount: "500",
    reviews: [
      MentorReview(
        userName: "Sophia Lee",
        comment: "Eve's insights into user psychology are amazing!",
        rating: 5.0,
        date: "2 days ago",
      ),
      MentorReview(
        userName: "Daniel Taylor",
        comment: "My design portfolio improved drastically with her guidance.",
        rating: 4.9,
        date: "1 month ago",
      ),
    ],
  ),
];
