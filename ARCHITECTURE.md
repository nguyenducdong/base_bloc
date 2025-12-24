# App Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      FinancialGuideApp                       │
│                       (MaterialApp)                          │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   FinancialGuideScreen                       │
│                      (Scaffold)                              │
│                                                              │
│  ┌────────────────── NestedScrollView ──────────────────┐  │
│  │                                                        │  │
│  │  ┌─────────── Header Slivers ────────────────┐       │  │
│  │  │                                            │       │  │
│  │  │  1. SliverAppBar (Collapsible)           │       │  │
│  │  │     • Title: "Cẩm Nang tài chính"        │       │  │
│  │  │     • Background: Blue                    │       │  │
│  │  │     • Expandable/Collapsible              │       │  │
│  │  │                                            │       │  │
│  │  │  2. SliverPersistentHeader (Search)      │       │  │
│  │  │     • TextField with search icon          │       │  │
│  │  │     • Placeholder: "Tìm kiếm..."         │       │  │
│  │  │     • Pinned: Yes                         │       │  │
│  │  │                                            │       │  │
│  │  │  3. SliverPersistentHeader (Tabs)        │       │  │
│  │  │     • Tab 1: "Mẹo tài chính"             │       │  │
│  │  │     • Tab 2: "Góc cảnh báo"              │       │  │
│  │  │     • Pinned: Yes                         │       │  │
│  │  │                                            │       │  │
│  │  └────────────────────────────────────────────       │  │
│  │                                                        │  │
│  │  ┌──────────── TabBarView ────────────────┐          │  │
│  │  │                                          │          │  │
│  │  │  Tab 1: Financial Tips                 │          │  │
│  │  │  ┌──────────────────────────────┐      │          │  │
│  │  │  │ ListView.builder             │      │          │  │
│  │  │  │                               │      │          │  │
│  │  │  │ ┌─────────────────────────┐  │      │          │  │
│  │  │  │ │ Card 1                  │  │      │          │  │
│  │  │  │ │ • Icon: 💰              │  │      │          │  │
│  │  │  │ │ • Title                 │  │      │          │  │
│  │  │  │ │ • Description           │  │      │          │  │
│  │  │  │ └─────────────────────────┘  │      │          │  │
│  │  │  │                               │      │          │  │
│  │  │  │ ┌─────────────────────────┐  │      │          │  │
│  │  │  │ │ Card 2                  │  │      │          │  │
│  │  │  │ │ • Icon: 📈              │  │      │          │  │
│  │  │  │ │ • Title                 │  │      │          │  │
│  │  │  │ │ • Description           │  │      │          │  │
│  │  │  │ └─────────────────────────┘  │      │          │  │
│  │  │  │                               │      │          │  │
│  │  │  │ ... (10 cards total)          │      │          │  │
│  │  │  │                               │      │          │  │
│  │  │  └──────────────────────────────┘      │          │  │
│  │  │                                          │          │  │
│  │  │  Tab 2: Warning Corner                 │          │  │
│  │  │  ┌──────────────────────────────┐      │          │  │
│  │  │  │ Center Widget                │      │          │  │
│  │  │  │ • Warning Icon: ⚠️          │      │          │  │
│  │  │  │ • Title: "Góc cảnh báo"      │      │          │  │
│  │  │  │ • Message: Coming soon       │      │          │  │
│  │  │  └──────────────────────────────┘      │          │  │
│  │  │                                          │          │  │
│  │  └──────────────────────────────────────────          │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Scrolling Behavior

```
Initial State (Top of Page):
┌────────────────────────┐
│  [Large Title Area]    │ ← SliverAppBar (Expanded)
│  Cẩm Nang tài chính    │
└────────────────────────┘
┌────────────────────────┐
│  [Search Bar]          │ ← Pinned
│  🔍 Tìm kiếm...        │
└────────────────────────┘
┌────────────────────────┐
│  Mẹo tài chính | Góc   │ ← Pinned
│  cảnh báo              │
└────────────────────────┘
┌────────────────────────┐
│  💰 Card 1             │
│  📈 Card 2             │
│  📊 Card 3             │
│  ...                   │

Scrolled State (User scrolls down):
┌────────────────────────┐
│  Cẩm Nang tài chính    │ ← SliverAppBar (Collapsed)
└────────────────────────┘
┌────────────────────────┐
│  [Search Bar]          │ ← Still visible (Pinned)
│  🔍 Tìm kiếm...        │
└────────────────────────┘
┌────────────────────────┐
│  Mẹo tài chính | Góc   │ ← Still visible (Pinned)
│  cảnh báo              │
└────────────────────────┘
┌────────────────────────┐
│  🛡️ Card 7             │
│  📉 Card 8             │
│  🏠 Card 9             │
│  ...                   │
```

## Component Hierarchy

```
main.dart
└── FinancialGuideApp (StatelessWidget)
    └── MaterialApp
        └── FinancialGuideScreen (StatefulWidget)

financial_guide_screen.dart
└── FinancialGuideScreen
    ├── State: _FinancialGuideScreenState
    │   ├── TabController _tabController
    │   └── TextEditingController _searchController
    │
    ├── Scaffold
    │   └── NestedScrollView
    │       ├── headerSliverBuilder
    │       │   ├── SliverAppBar (title)
    │       │   ├── SliverPersistentHeader (_SearchBarDelegate)
    │       │   └── SliverPersistentHeader (_TabBarDelegate)
    │       │
    │       └── body: TabBarView
    │           ├── _buildFinancialTipsTab()
    │           │   └── ListView.builder
    │           │       └── Card (x10)
    │           │
    │           └── _buildWarningTab()
    │               └── Center
    │
    ├── _SearchBarDelegate (SliverPersistentHeaderDelegate)
    └── _TabBarDelegate (SliverPersistentHeaderDelegate)
```

## Data Flow

```
┌─────────────────┐
│  financialTips  │ ← Static list of 10 tips
│  (List<Map>)    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│  _buildFinancialTipsTab │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  ListView.builder       │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Card Widget (x10)      │
│  • Icon                 │
│  • Title                │
│  • Description          │
│  • onTap handler        │
└─────────────────────────┘
```

## State Management

```
StatefulWidget: FinancialGuideScreen
    │
    ├── initState()
    │   └── Create TabController (length: 2)
    │
    ├── dispose()
    │   ├── Dispose TabController
    │   └── Dispose SearchController
    │
    └── build()
        └── Render UI with current state
```

## Key Technologies Used

- **Flutter SDK**: >=3.0.0
- **Material Design 3**: Modern UI components
- **NestedScrollView**: Coordinated scrolling
- **SliverAppBar**: Collapsible app bar
- **TabController**: Tab state management
- **ListView.builder**: Efficient list rendering
- **SingleTickerProviderStateMixin**: Animation support

## Files Overview

1. **lib/main.dart** (24 lines)
   - App entry point
   - MaterialApp configuration

2. **lib/financial_guide_screen.dart** (308 lines)
   - Main screen with all UI components
   - Custom sliver delegates
   - Tab content builders

3. **test/widget_test.dart** (44 lines)
   - Widget tests
   - UI verification
   - Interaction tests

4. **Documentation**
   - README.md: User guide
   - IMPLEMENTATION.md: Technical details
   - SUMMARY.md: Implementation summary
   - ARCHITECTURE.md: This file
