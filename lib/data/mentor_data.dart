import '../models/mentor_model.dart';

final List<Mentor> mentorData = [
  Mentor(
    name: "Alice",
    profileImage: "assets/images/Alice.jpg",
    title: "Senior Product Designer",
    about:
        "Experienced mentor with a passion for teaching and helping students achieve their goals in the field of design and technology. I have over 10 years of experience in the industry and have worked with several top-tier companies.",
    courses: ["UI/UX Design", "Graphic Design", "Web Design"],
    students: "1,250",
    rating: "4.8",
    reviewsCount: "450",
    reviews: [
      MentorReview(
        userName: "Alex Johnson",
        comment:
            "Amazing mentor! Really helped me understand the core concepts of UI/UX.",
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
    title: "Full Stack Developer",
    about:
        "Expert in full-stack web development with specialization in React and Node.js. I have successfully developed numerous web applications and mentored over 500 students worldwide.",
    courses: ["React.js", "Node.js", "Web Development", "JavaScript"],
    students: "1,450",
    rating: "4.9",
    reviewsCount: "520",
    reviews: [
      MentorReview(
        userName: "David Brown",
        comment:
            "Bob's teaching style is excellent. Very clear explanations and practical examples.",
        rating: 5.0,
        date: "3 days ago",
      ),
      MentorReview(
        userName: "Emma Davis",
        comment:
            "Highly recommend! Bob helped me get my first web development job.",
        rating: 5.0,
        date: "2 weeks ago",
      ),
    ],
  ),
  Mentor(
    name: "Charlie",
    profileImage: "assets/images/Charlie.jpg",
    title: "Data Science Specialist",
    about:
        "Specialized in machine learning, data analysis, and artificial intelligence. I have worked with leading tech companies on cutting-edge AI projects.",
    courses: ["Machine Learning", "Data Analysis", "Python", "AI"],
    students: "900",
    rating: "4.7",
    reviewsCount: "380",
    reviews: [
      MentorReview(
        userName: "Michael Chen",
        comment:
            "Charlie made complex machine learning concepts easy to understand.",
        rating: 4.8,
        date: "1 week ago",
      ),
      MentorReview(
        userName: "Lisa Wang",
        comment:
            "Excellent mentor! Helped me transition to data science career.",
        rating: 4.6,
        date: "3 weeks ago",
      ),
    ],
  ),
  Mentor(
    name: "Diana",
    profileImage: "assets/images/Diana.jpg",
    title: "Mobile App Developer",
    about:
        "Passionate about mobile development with expertise in Flutter and native Android/iOS development. I have launched 20+ apps on app stores.",
    courses: ["Flutter", "Android", "iOS", "Cross-platform Development"],
    students: "1,100",
    rating: "4.6",
    reviewsCount: "410",
    reviews: [
      MentorReview(
        userName: "James Wilson",
        comment: "Diana is patient and thorough in teaching mobile development.",
        rating: 4.7,
        date: "4 days ago",
      ),
      MentorReview(
        userName: "Rachel Green",
        comment: "Great mentor! Helped me build my first mobile app.",
        rating: 4.5,
        date: "2 weeks ago",
      ),
    ],
  ),
  Mentor(
    name: "Eve",
    profileImage: "assets/images/Eve.jpg",
    title: "Cloud & DevOps Engineer",
    about:
        "Expert in cloud infrastructure, DevOps, and containerization technologies. I have managed cloud solutions for Fortune 500 companies.",
    courses: ["AWS", "Docker", "Kubernetes", "Cloud Architecture"],
    students: "800",
    rating: "4.8",
    reviewsCount: "360",
    reviews: [
      MentorReview(
        userName: "Kevin Lee",
        comment: "Eve's knowledge in AWS and DevOps is exceptional.",
        rating: 4.9,
        date: "5 days ago",
      ),
      MentorReview(
        userName: "Patricia Moore",
        comment: "Very helpful in understanding cloud architecture concepts.",
        rating: 4.7,
        date: "1 week ago",
      ),
    ],
  ),
];
