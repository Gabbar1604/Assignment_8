import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final transactionNotifier = ref.read(transactionProvider.notifier);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: TextStyle(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6366F1),
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF6366F1)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 20,
            vertical: isTablet ? 24 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCards(transactionNotifier, isTablet),
              SizedBox(height: isTablet ? 32 : 24),
              _buildExpensePieChart(
                transactionNotifier.expensesByCategory,
                isTablet,
              ),
              SizedBox(height: isTablet ? 32 : 24),
              _buildMonthlyTrend(transactions, isTablet),
              SizedBox(height: isTablet ? 32 : 24),
              _buildTopCategories(
                transactionNotifier.expensesByCategory,
                isTablet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards(TransactionNotifier notifier, bool isTablet) {
    final currencyFormatter = NumberFormat.currency(symbol: 'Rs.');

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Income',
            currencyFormatter.format(notifier.totalIncome),
            Icons.trending_up,
            const Color(0xFF10B981),
            isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: _buildStatCard(
            'Total Expenses',
            currencyFormatter.format(notifier.totalExpenses),
            Icons.trending_down,
            const Color(0xFFEF4444),
            isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: isTablet ? 24 : 20),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 12 : 8,
                  vertical: isTablet ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title == 'Total Income' ? '+' : '-',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensePieChart(
    Map<String, double> expensesByCategory,
    bool isTablet,
  ) {
    if (expensesByCategory.isEmpty) {
      return Container(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Expenses by Category',
              style: TextStyle(
                fontSize: isTablet ? 22 : 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: isTablet ? 32 : 24),
            SizedBox(
              height: isTablet ? 300 : 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 24 : 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.pie_chart_outline,
                        size: isTablet ? 64 : 48,
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                    SizedBox(height: isTablet ? 20 : 16),
                    Text(
                      'No expense data available',
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 6),
                    Text(
                      'Start adding expenses to see analytics',
                      style: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final total = expensesByCategory.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFF14B8A6),
      const Color(0xFFEC4899),
      const Color(0xFF6366F1),
    ];

    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses by Category',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),
          SizedBox(
            height: isTablet ? 300 : 250,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: expensesByCategory.entries.map((entry) {
                        final index = expensesByCategory.keys.toList().indexOf(
                          entry.key,
                        );
                        final percentage = (entry.value / total) * 100;
                        return PieChartSectionData(
                          value: entry.value,
                          title: '${percentage.toStringAsFixed(1)}%',
                          color: colors[index % colors.length],
                          radius: isTablet ? 80 : 60,
                          titleStyle: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: isTablet ? 40 : 30,
                    ),
                  ),
                ),
                SizedBox(width: isTablet ? 32 : 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: expensesByCategory.entries.take(10).map((
                        entry,
                      ) {
                        final index = expensesByCategory.keys.toList().indexOf(
                          entry.key,
                        );
                        final percentage = (entry.value / total) * 100;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 6 : 4,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: isTablet ? 16 : 12,
                                height: isTablet ? 16 : 12,
                                decoration: BoxDecoration(
                                  color: colors[index % colors.length],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(width: isTablet ? 12 : 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : 12,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF374151),
                                      ),
                                    ),
                                    Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: isTablet ? 12 : 10,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrend(List transactions, bool isTablet) {
    final Map<String, double> monthlyIncome = {};
    final Map<String, double> monthlyExpenses = {};

    for (final transaction in transactions) {
      final monthKey = DateFormat('MMM yyyy').format(transaction.date);
      if (transaction.type.toString().contains('income')) {
        monthlyIncome[monthKey] =
            (monthlyIncome[monthKey] ?? 0) + transaction.amount;
      } else {
        monthlyExpenses[monthKey] =
            (monthlyExpenses[monthKey] ?? 0) + transaction.amount;
      }
    }

    final now = DateTime.now();
    final months = List.generate(6, (index) {
      final date = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM yyyy').format(date);
    }).reversed.toList();

    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Trend',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isTablet ? 32 : 24),
          SizedBox(
            height: isTablet ? 300 : 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: isTablet ? 80 : 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          NumberFormat.compact().format(value),
                          style: TextStyle(
                            fontSize: isTablet ? 12 : 10,
                            color: const Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < months.length) {
                          return Text(
                            months[index].split(' ')[0],
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 10,
                              color: const Color(0xFF6B7280),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: months.asMap().entries.map((entry) {
                      final index = entry.key;
                      final month = entry.value;
                      final income = monthlyIncome[month] ?? 0;
                      return FlSpot(index.toDouble(), income);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: isTablet ? 4 : 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: isTablet ? 6 : 4,
                          color: const Color(0xFF10B981),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF10B981).withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: months.asMap().entries.map((entry) {
                      final index = entry.key;
                      final month = entry.value;
                      final expenses = monthlyExpenses[month] ?? 0;
                      return FlSpot(index.toDouble(), expenses);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFFEF4444),
                    barWidth: isTablet ? 4 : 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: isTablet ? 6 : 4,
                          color: const Color(0xFFEF4444),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                    ),
                  ),
                ],
                minY: 0,
              ),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Income', const Color(0xFF10B981), isTablet),
              SizedBox(width: isTablet ? 32 : 24),
              _buildLegendItem('Expenses', const Color(0xFFEF4444), isTablet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isTablet) {
    return Row(
      children: [
        Container(
          width: isTablet ? 16 : 12,
          height: isTablet ? 16 : 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: isTablet ? 12 : 8),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategories(
    Map<String, double> expensesByCategory,
    bool isTablet,
  ) {
    if (expensesByCategory.isEmpty) {
      return Container(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                'Top Categories',
                style: TextStyle(
                  fontSize: isTablet ? 22 : 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: isTablet ? 32 : 24),
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.category_outlined,
                  size: isTablet ? 48 : 40,
                  color: const Color(0xFF6C63FF),
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),
              Text(
                'No category data available',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final sortedCategories = expensesByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final currencyFormatter = NumberFormat.currency(symbol: 'Rs.');

    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Categories',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 20),
          ...sortedCategories.take(5).map((entry) {
            final maxValue = sortedCategories.first.value;
            final percentage = (entry.value / maxValue);

            return Padding(
              padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      Text(
                        currencyFormatter.format(entry.value),
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 8 : 6),
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFEF4444),
                    ),
                    minHeight: isTablet ? 8 : 6,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
