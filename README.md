# 📰 Newschannel – iOS Application

Newschannel is an iOS application developed as a technical assignment. It is designed to fetch, display, and manage news articles with role-based functionality for Authors and Reviewers. The app uses SwiftUI, MVVM architecture, Core Data for offline storage, and supports seamless API integration.

---

## 🚀 Features

### ✅ Role-Based Login
- User can log in as **Author** or **Reviewer** by selecting their role and entering a username.
- Author login is restricted to `Robert` (as per assignment specification).

### ✅ Sync Articles from API
- Fetches articles from a mock or live API.
- Stores articles in Core Data for offline access.
- Syncs automatically:
  - On app launch if the internet is available.
  - In the background every 15 minutes.
  - When network connectivity is restored.

### ✅ Reviewer Features
- Displays a grouped list of articles by authors.
- Allows reviewers to **select articles** and **mark them as approved**.
- Prevents duplicate approvals for the same article.
- Visual feedback for already approved articles (grayed out with disabled checkboxes).

### ✅ Author Features
- Displays the author’s own articles.
- Shows a short description and the number of reviewers who have approved each article.
- Authors can view detailed content for their articles.

### ✅ Offline Support
- Core Data stores articles locally.
- Users can view articles even without an internet connection.

### ✅ Clean UI
- SwiftUI interface with reusable components.
- Gradient backgrounds, checkboxes, and sectioned lists for improved UX.

---

## 🛠 Technical Stack

| Technology        | Purpose                        |
|--------------------|----------------------------------|
| SwiftUI            | UI Development                 |
| MVVM Architecture  | Clean separation of concerns   |
| Core Data          | Local storage of articles      |
| URLSession         | API Networking                 |
| Combine            | Reactive updates for UI        |
| Network Framework  | Monitor internet connectivity  |

---

## 📦 Requirements

- Xcode 15 or later
- iOS 16.0+
- Swift 5.8

---

## ⚙️ Setup Instructions

1. Clone this repository.
2. Open `Newschannel.xcodeproj` in Xcode.
3. Go to **Product > Scheme > Edit Scheme** and set the build target to `iPhone 14` (or your preferred simulator).
4. Run the app on a simulator or a physical device.

---

## 🔑 Usage Notes

- **Login as Author**
  - Username: `Robert`
  - Role: `Author`
- **Login as Reviewer**
  - Username: any name
  - Role: `Reviewer`
- **Sync**
  - Tap the **Sync** button on the login screen to fetch articles from the API.

---

## 📌 Additional Notes

- Articles are fetched from the mock API endpoint:
