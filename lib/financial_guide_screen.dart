import 'package:flutter/material.dart';

class FinancialGuideScreen extends StatefulWidget {
  const FinancialGuideScreen({super.key});

  @override
  State<FinancialGuideScreen> createState() => _FinancialGuideScreenState();
}

class _FinancialGuideScreenState extends State<FinancialGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Sample data for "Mẹo tài chính" tab
  final List<Map<String, String>> financialTips = [
    {
      'title': 'Tiết kiệm thông minh',
      'description': 'Học cách tiết kiệm tiền hiệu quả cho tương lai',
      'icon': '💰'
    },
    {
      'title': 'Đầu tư an toàn',
      'description': 'Hướng dẫn đầu tư tiền bạc một cách thông minh',
      'icon': '📈'
    },
    {
      'title': 'Quản lý chi tiêu',
      'description': 'Mẹo quản lý chi tiêu hàng tháng hiệu quả',
      'icon': '📊'
    },
    {
      'title': 'Lập kế hoạch tài chính',
      'description': 'Cách lập kế hoạch tài chính cá nhân',
      'icon': '📝'
    },
    {
      'title': 'Thu nhập thụ động',
      'description': 'Xây dựng nguồn thu nhập thụ động bền vững',
      'icon': '💵'
    },
    {
      'title': 'Tránh nợ nần',
      'description': 'Những nguyên tắc để tránh rơi vào nợ nần',
      'icon': '🚫'
    },
    {
      'title': 'Bảo hiểm tài chính',
      'description': 'Tầm quan trọng của bảo hiểm trong đời sống',
      'icon': '🛡️'
    },
    {
      'title': 'Đầu tư chứng khoán',
      'description': 'Kiến thức cơ bản về đầu tư chứng khoán',
      'icon': '📉'
    },
    {
      'title': 'Mua nhà thông minh',
      'description': 'Hướng dẫn mua nhà đất một cách thông minh',
      'icon': '🏠'
    },
    {
      'title': 'Tiết kiệm thuế',
      'description': 'Các cách hợp pháp để tiết kiệm thuế',
      'icon': '🧾'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.blue[700],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Cẩm Nang tài chính',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                searchController: _searchController,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                tabController: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // "Mẹo tài chính" tab
            _buildFinancialTipsTab(),
            // "Góc cảnh báo" tab
            _buildWarningTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialTipsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: financialTips.length,
      itemBuilder: (context, index) {
        final tip = financialTips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  tip['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(
              tip['title']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                tip['description']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
            onTap: () {
              // Handle tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã chọn: ${tip['title']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildWarningTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: Colors.orange[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Góc cảnh báo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nội dung sẽ được cập nhật',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Delegate for search bar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;

  _SearchBarDelegate({required this.searchController});

  @override
  double get minExtent => 70.0;

  @override
  double get maxExtent => 70.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}

// Delegate for tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  _TabBarDelegate({required this.tabController});

  @override
  double get minExtent => 50.0;

  @override
  double get maxExtent => 50.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[700],
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        tabs: const [
          Tab(text: 'Mẹo tài chính'),
          Tab(text: 'Góc cảnh báo'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
