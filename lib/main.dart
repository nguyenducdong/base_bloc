import 'package:flutter/material.dart';
import 'financial_guide_screen.dart';

void main() {
  runApp(const FinancialGuideApp());
}

class FinancialGuideApp extends StatelessWidget {
  const FinancialGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cẩm Nang tài chính',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FinancialGuideScreen(),
    );
  }
}
