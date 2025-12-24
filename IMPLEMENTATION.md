# Implementation Details

## Overview
This Flutter application implements a financial guide ("Cẩm Nang tài chính") with a sophisticated scrolling behavior and tab navigation system.

## Key Components

### 1. Main App (main.dart)
- Entry point of the application
- Sets up MaterialApp with theme and routing
- Configures the app title as "Cẩm Nang tài chính"

### 2. Financial Guide Screen (financial_guide_screen.dart)
The main screen implementation uses several advanced Flutter widgets:

#### NestedScrollView
- Enables coordinated scrolling between the header and body
- Allows the AppBar, search field, and tabs to scroll up together with the content

#### SliverAppBar
- Expandable app bar with the title "Cẩm Nang tài chính"
- Collapses and expands based on scroll position
- Uses FlexibleSpaceBar for smooth transitions

#### Custom SliverPersistentHeader Delegates

**_SearchBarDelegate**
- Maintains a fixed height of 70 pixels
- Displays a search TextField with rounded corners
- Pinned to stay visible while scrolling
- Includes search icon and placeholder text "Tìm kiếm..."

**_TabBarDelegate**
- Maintains a fixed height of 50 pixels
- Displays two tabs: "Mẹo tài chính" and "Góc cảnh báo"
- Pinned to stay visible while scrolling
- Active tab indicated with blue color and underline

#### TabBarView
Two tabs with different content:

**Tab 1: Mẹo tài chính (Financial Tips)**
- Scrollable ListView with 10 sample financial tips
- Each item displayed as a Card with:
  - Icon (emoji)
  - Title
  - Description
  - Arrow indicator
- Cards have rounded corners and elevation for depth
- Tap handler shows a SnackBar

**Tab 2: Góc cảnh báo (Warning Corner)**
- Placeholder screen with centered content
- Warning icon
- Title and "coming soon" message

## Design Patterns

### State Management
- Uses StatefulWidget for managing tab controller and search controller
- SingleTickerProviderStateMixin for animation support

### UI/UX Features
1. **Coordinated Scrolling**: All header elements (title, search, tabs) scroll together
2. **Pinned Elements**: Search bar and tabs remain visible after scrolling
3. **Material Design**: Uses Cards, elevation, and proper spacing
4. **Color Scheme**: Blue primary color with grey accents
5. **Vietnamese Language**: All text in Vietnamese for target audience

### Sample Data
The app includes 10 predefined financial tips covering:
- Savings strategies
- Investment guidance
- Expense management
- Financial planning
- Passive income
- Debt avoidance
- Insurance
- Stock market
- Real estate
- Tax optimization

## Testing
Widget tests verify:
- App initialization
- Presence of key UI elements (title, search, tabs)
- Tab switching functionality
- Content display in the financial tips list

## Future Enhancements
Potential improvements could include:
- Search functionality implementation
- Real data integration
- Detailed view for each financial tip
- Content for "Góc cảnh báo" tab
- Favorites/bookmarking system
- Sharing functionality
- Local storage for offline access
