# Cẩm Nang tài chính (Financial Guide)

A Flutter application providing financial tips and warnings for users.

## Features

- 📱 Modern Flutter UI with Material Design
- 🔍 Search functionality to find financial tips
- 📑 Two tabs:
  - **Mẹo tài chính** (Financial Tips): Scrollable list of financial advice
  - **Góc cảnh báo** (Warning Corner): Financial warnings section
- 🎯 Smooth scrolling experience with NestedScrollView
- 💡 Vietnamese language support

## Project Structure

```
lib/
├── main.dart                      # App entry point
└── financial_guide_screen.dart    # Main screen with tabs and content
```

## How to Run

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/nguyenducdong/base_bloc.git
cd base_bloc
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Testing

Run tests with:
```bash
flutter test
```

## Design Features

- **Collapsible AppBar**: The title "Cẩm Nang tài chính" collapses when scrolling
- **Sticky Search Bar**: Search field remains accessible while scrolling
- **Persistent TabBar**: Tabs stay at the top when scrolling through content
- **Card-based List**: Financial tips displayed in attractive cards with icons
- **Responsive Design**: Works on various screen sizes

## Sample Content

The app includes 10 sample financial tips covering topics like:
- Smart saving
- Safe investing
- Expense management
- Financial planning
- Passive income
- Avoiding debt
- Insurance
- Stock investment
- Smart home buying
- Tax savings