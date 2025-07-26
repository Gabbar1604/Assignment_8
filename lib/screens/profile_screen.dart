import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import '../models/transaction.dart' as transaction_model;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final transactionNotifier = ref.read(transactionProvider.notifier);
    final currencyFormatter = NumberFormat.currency(symbol: 'Rs.');
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    double totalIncome = transactions
        .where((t) => t.type == transaction_model.TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    double totalExpense = transactions
        .where((t) => t.type == transaction_model.TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    double balance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: isDesktop
                ? 28
                : isTablet
                ? 24
                : 20,
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
        child: isDesktop
            ? _buildDesktopLayout(
                totalIncome,
                totalExpense,
                balance,
                currencyFormatter,
                transactionNotifier,
              )
            : _buildMobileTabletLayout(
                totalIncome,
                totalExpense,
                balance,
                currencyFormatter,
                transactionNotifier,
                isTablet,
              ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    double totalIncome,
    double totalExpense,
    double balance,
    NumberFormat currencyFormatter,
    TransactionNotifier transactionNotifier,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildProfileHeader(context, true),
                const SizedBox(height: 32),
                _buildActionButtons(context, ref, true),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right Column
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildFinancialSummary(
                  context,
                  totalIncome,
                  totalExpense,
                  balance,
                  currencyFormatter,
                  true,
                ),
                const SizedBox(height: 32),
                _buildExpenseDetails(
                  context,
                  transactionNotifier,
                  currencyFormatter,
                  true,
                ),
                const SizedBox(height: 32),
                _buildSettingsSection(context, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabletLayout(
    double totalIncome,
    double totalExpense,
    double balance,
    NumberFormat currencyFormatter,
    TransactionNotifier transactionNotifier,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 20,
        vertical: isTablet ? 24 : 16,
      ),
      child: Column(
        children: [
          _buildProfileHeader(context, isTablet),
          SizedBox(height: isTablet ? 32 : 24),
          _buildFinancialSummary(
            context,
            totalIncome,
            totalExpense,
            balance,
            currencyFormatter,
            isTablet,
          ),
          SizedBox(height: isTablet ? 32 : 24),
          _buildExpenseDetails(
            context,
            transactionNotifier,
            currencyFormatter,
            isTablet,
          ),
          SizedBox(height: isTablet ? 32 : 24),
          _buildSettingsSection(context, isTablet),
          SizedBox(height: isTablet ? 32 : 24),
          _buildActionButtons(context, ref, isTablet),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isTablet) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User';
    final email = user?.email ?? 'No email';

    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isTablet ? 60 : 50),
            ),
            child: Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: isTablet ? 40 : 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Text(
            displayName,
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            email,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 12,
              vertical: isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: user?.emailVerified == true
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user?.emailVerified == true ? Icons.verified : Icons.warning,
                  color: Colors.white,
                  size: isTablet ? 18 : 16,
                ),
                SizedBox(width: isTablet ? 8 : 6),
                Text(
                  user?.emailVerified == true ? 'Verified' : 'Unverified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 24 : 20),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(
    BuildContext context,
    double totalIncome,
    double totalExpense,
    double balance,
    NumberFormat formatter,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Summary',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildSummaryRow(
            'Current Balance',
            formatter.format(balance),
            Icons.account_balance_wallet,
            balance >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            isTablet,
          ),
          Divider(
            height: isTablet ? 32 : 24,
            color: Colors.grey.withOpacity(0.2),
          ),
          _buildSummaryRow(
            'Total Income',
            formatter.format(totalIncome),
            Icons.trending_up,
            const Color(0xFF10B981),
            isTablet,
          ),
          Divider(
            height: isTablet ? 32 : 24,
            color: Colors.grey.withOpacity(0.2),
          ),
          _buildSummaryRow(
            'Total Expenses',
            formatter.format(totalExpense),
            Icons.trending_down,
            const Color(0xFFEF4444),
            isTablet,
          ),
          Divider(
            height: isTablet ? 32 : 24,
            color: Colors.grey.withOpacity(0.2),
          ),
          _buildSummaryRow(
            'Savings Rate',
            '${totalIncome > 0 ? (((totalIncome - totalExpense) / totalIncome) * 100).toStringAsFixed(1) : '0.0'}%',
            Icons.savings,
            const Color(0xFF6C63FF),
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Row(
      children: [
        Container(
          width: isTablet ? 48 : 40,
          height: isTablet ? 48 : 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: isTablet ? 24 : 20),
        ),
        SizedBox(width: isTablet ? 20 : 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseDetails(
    BuildContext context,
    TransactionNotifier notifier,
    NumberFormat formatter,
    bool isTablet,
  ) {
    final expensesByCategory = notifier.expensesByCategory;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;
    final isDesktop = screenWidth > 1200;

    return Container(
      padding: EdgeInsets.all(
        isDesktop
            ? 40
            : isTablet
            ? 32
            : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: isDesktop ? 20 : 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: isWideScreen ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: isWideScreen
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: isWideScreen
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Text(
                'Expense Breakdown',
                style: TextStyle(
                  fontSize: isDesktop
                      ? 26
                      : isTablet
                      ? 22
                      : 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D3748),
                ),
              ),
              if (!isWideScreen) SizedBox(height: isTablet ? 12 : 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? 16
                      : isTablet
                      ? 12
                      : 10,
                  vertical: isDesktop
                      ? 8
                      : isTablet
                      ? 6
                      : 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isDesktop ? 10 : 8),
                ),
                child: Text(
                  '${expensesByCategory.length} Categories',
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 14
                        : isTablet
                        ? 12
                        : 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: isDesktop
                ? 32
                : isTablet
                ? 24
                : 20,
          ),

          if (expensesByCategory.isEmpty)
            _buildEmptyExpenseState(isTablet)
          else
            _buildExpenseList(
              expensesByCategory,
              notifier,
              formatter,
              isTablet,
              isWideScreen,
              isDesktop,
            ),
        ],
      ),
    );
  }

  // Empty State
  Widget _buildEmptyExpenseState(bool isTablet) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isDesktop
            ? 60
            : isTablet
            ? 40
            : 32,
        horizontal: isDesktop
            ? 40
            : isTablet
            ? 20
            : 16,
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                isDesktop
                    ? 28
                    : isTablet
                    ? 20
                    : 16,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(isDesktop ? 24 : 16),
              ),
              child: Icon(
                Icons.category_outlined,
                size: isDesktop
                    ? 56
                    : isTablet
                    ? 40
                    : 32,
                color: const Color(0xFF6C63FF),
              ),
            ),
            SizedBox(
              height: isDesktop
                  ? 24
                  : isTablet
                  ? 16
                  : 12,
            ),
            Text(
              'No expenses yet',
              style: TextStyle(
                fontSize: isDesktop
                    ? 22
                    : isTablet
                    ? 18
                    : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(
              height: isDesktop
                  ? 12
                  : isTablet
                  ? 8
                  : 6,
            ),
            Text(
              'Start tracking your expenses to see category breakdown',
              style: TextStyle(
                fontSize: isDesktop
                    ? 16
                    : isTablet
                    ? 14
                    : 12,
                color: const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Expense List
  Widget _buildExpenseList(
    Map<String, double> expensesByCategory,
    TransactionNotifier notifier,
    NumberFormat formatter,
    bool isTablet,
    bool isWideScreen,
    bool isDesktop,
  ) {
    final totalExpenses = notifier.totalExpenses;
    final entries = expensesByCategory.entries.take(isDesktop ? 8 : 5).toList();

    if (isDesktop && entries.length > 3) {
      return _buildExpenseGrid(
        entries,
        totalExpenses,
        formatter,
        isTablet,
        context,
        3, // columns
      );
    } else if (isWideScreen && entries.length > 2) {
      return _buildExpenseGrid(
        entries,
        totalExpenses,
        formatter,
        isTablet,
        context,
        2, // columns
      );
    } else {
      return _buildExpenseColumn(entries, totalExpenses, formatter, isTablet);
    }
  }

  // Grid Layout for Wide Screens
  Widget _buildExpenseGrid(
    List<MapEntry<String, double>> entries,
    double totalExpenses,
    NumberFormat formatter,
    bool isTablet,
    BuildContext context,
    int columns,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    // Calculate item width based on columns
    final containerPadding = isDesktop
        ? 80
        : isTablet
        ? 64
        : 48;
    final spacing = isDesktop ? 20 : 16;
    final itemWidth =
        (screenWidth - containerPadding - (spacing * (columns - 1))) / columns;

    return Wrap(
      spacing: spacing.toDouble(),
      runSpacing: spacing.toDouble(),
      children: entries.map((entry) {
        final percentage = totalExpenses > 0
            ? (entry.value / totalExpenses * 100).toDouble()
            : 0.0;

        return SizedBox(
          width: itemWidth,
          child: _buildExpenseCard(entry, percentage, formatter, isTablet),
        );
      }).toList(),
    );
  }

  // Column Layout for Normal Screens
  Widget _buildExpenseColumn(
    List<MapEntry<String, double>> entries,
    double totalExpenses,
    NumberFormat formatter,
    bool isTablet,
  ) {
    return Column(
      children: entries.map((entry) {
        final percentage = totalExpenses > 0
            ? (entry.value / totalExpenses * 100).toDouble()
            : 0.0;

        return Padding(
          padding: EdgeInsets.only(bottom: isTablet ? 16 : 12),
          child: _buildExpenseCard(entry, percentage, formatter, isTablet),
        );
      }).toList(),
    );
  }

  // Individual Expense Card - Responsive
  Widget _buildExpenseCard(
    MapEntry<String, double> entry,
    double percentage,
    NumberFormat formatter,
    bool isTablet,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return Container(
      padding: EdgeInsets.all(
        isDesktop
            ? 20
            : isTablet
            ? 16
            : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        border: Border.all(
          color: const Color(0xFFEF4444).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: isDesktop ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Category Row
          Row(
            children: [
              Container(
                width: isDesktop
                    ? 56
                    : isTablet
                    ? 48
                    : 40,
                height: isDesktop
                    ? 56
                    : isTablet
                    ? 48
                    : 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                ),
                child: Icon(
                  _getCategoryIcon(entry.key),
                  color: const Color(0xFFEF4444),
                  size: isDesktop
                      ? 28
                      : isTablet
                      ? 24
                      : 20,
                ),
              ),
              SizedBox(
                width: isDesktop
                    ? 16
                    : isTablet
                    ? 12
                    : 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 18
                            : isTablet
                            ? 16
                            : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isDesktop ? 6 : 4),
                    Text(
                      formatter.format(entry.value),
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 16
                            : isTablet
                            ? 14
                            : 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: isDesktop
                ? 16
                : isTablet
                ? 12
                : 8,
          ),

          // Progress Bar Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Percentage',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 10,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop
                          ? 10
                          : isTablet
                          ? 8
                          : 6,
                      vertical: isDesktop
                          ? 6
                          : isTablet
                          ? 4
                          : 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(isDesktop ? 8 : 6),
                    ),
                    child: Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 14
                            : isTablet
                            ? 12
                            : 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 8 : 6),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFEF4444),
                ),
                minHeight: isDesktop
                    ? 8
                    : isTablet
                    ? 6
                    : 4,
                borderRadius: BorderRadius.circular(isDesktop ? 4 : 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Get category-specific icons
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'restaurant':
      case 'groceries':
        return Icons.restaurant;
      case 'transport':
      case 'travel':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'health':
      case 'medical':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'bills':
      case 'utilities':
        return Icons.receipt;
      case 'rent':
      case 'home':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  Widget _buildSettingsSection(BuildContext context, bool isTablet) {
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
          Text(
            'Settings',
            style: TextStyle(
              fontSize: isTablet ? 22 : 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildSettingsTile(
            'Theme',
            'Switch between light and dark mode',
            Icons.palette_outlined,
            () => _showThemeSettings(context, isTablet),
            isTablet,
          ),
          _buildSettingsTile(
            'Notifications',
            'Manage your notification preferences',
            Icons.notifications_outlined,
            () => _showNotificationSettings(context),
            isTablet,
          ),
          _buildSettingsTile(
            'Currency',
            'Change your default currency',
            Icons.attach_money,
            () => _showCurrencySettings(context),
            isTablet,
          ),
          _buildSettingsTile(
            'Budget Goals',
            'Set monthly spending limits',
            Icons.track_changes,
            () => _showBudgetSettings(context),
            isTablet,
          ),
          _buildSettingsTile(
            'Data Export',
            'Export your transaction data',
            Icons.download,
            () => _showExportOptions(context),
            isTablet,
          ),
          _buildSettingsTile(
            'Privacy',
            'Manage your privacy settings',
            Icons.privacy_tip_outlined,
            () => _showPrivacySettings(context),
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isTablet,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 8 : 4),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(isTablet ? 12 : 10),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: isTablet ? 24 : 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: const Color(0xFF6B7280),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: const Color(0xFF9CA3AF),
          size: isTablet ? 24 : 20,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    bool isTablet,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showClearDataDialog(context, ref),
            icon: Icon(
              Icons.delete_sweep,
              color: const Color(0xFF8B5CF6),
              size: isTablet ? 20 : 18,
            ),
            label: Text(
              'Clear All Data',
              style: TextStyle(
                color: const Color(0xFF8B5CF6),
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
              side: const BorderSide(color: Color(0xFF8B5CF6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: Icon(
              Icons.logout,
              color: const Color(0xFFEF4444),
              size: isTablet ? 20 : 18,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: const Color(0xFFEF4444),
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: isTablet ? 32 : 20),
        Text(
          'Version 1.0.0',
          style: TextStyle(
            color: const Color(0xFF9CA3AF),
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showThemeSettings(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentTheme = ref.watch(themeProvider);
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: isTablet ? 400 : double.infinity,
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Theme Settings',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 20),
                  _buildThemeOption(
                    'Light Mode',
                    Icons.light_mode,
                    currentTheme == AppTheme.light,
                    isTablet,
                    () => ref
                        .read(themeProvider.notifier)
                        .setTheme(AppTheme.light),
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  _buildThemeOption(
                    'Dark Mode',
                    Icons.dark_mode,
                    currentTheme == AppTheme.dark,
                    isTablet,
                    () => ref
                        .read(themeProvider.notifier)
                        .setTheme(AppTheme.dark),
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  _buildThemeOption(
                    'System Default',
                    Icons.settings_suggest,
                    currentTheme == AppTheme.system,
                    isTablet,
                    () => ref
                        .read(themeProvider.notifier)
                        .setTheme(AppTheme.system),
                  ),
                  SizedBox(height: isTablet ? 32 : 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Theme preference saved!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 16 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(fontSize: isTablet ? 16 : 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    String title,
    IconData icon,
    bool isSelected,
    bool isTablet,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFFE5E7EB),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected
            ? const Color(0xFF6C63FF).withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(isTablet ? 10 : 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF6C63FF),
            size: isTablet ? 20 : 18,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF6C63FF)
                : const Color(0xFF374151),
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: const Color(0xFF6C63FF),
                size: isTablet ? 24 : 20,
              )
            : null,
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 8 : 4,
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Remind me to track expenses'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Budget Alerts'),
              subtitle: const Text('Alert when approaching budget limit'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCurrencySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Currency Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('USD (\$)'),
              value: 'USD',
              groupValue: 'USD',
              onChanged: (value) {},
            ),
            RadioListTile<String>(
              title: const Text('EUR (€)'),
              value: 'EUR',
              groupValue: 'USD',
              onChanged: (value) {},
            ),
            RadioListTile<String>(
              title: const Text('GBP (£)'),
              value: 'GBP',
              groupValue: 'USD',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBudgetSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Budget Goals'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Monthly Budget Limit',
            prefixText: 'Rs. ',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Budget goal updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose export format for your transaction data:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting to CSV...')),
              );
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting to PDF...')),
              );
            },
            child: const Text('PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Analytics'),
              subtitle: const Text('Help improve the app'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Data Sharing'),
              subtitle: const Text('Share anonymous usage data'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your transactions and cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear all transactions
              final transactions = ref.read(transactionProvider);
              for (final transaction in transactions) {
                ref
                    .read(transactionProvider.notifier)
                    .removeTransaction(transaction.id);
              }

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Perform logout
                await FirebaseAuth.instance.signOut();
                print("User logged out successfully");
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout successfully!')),
                );
              } catch (e) {
                print("Logout failed: $e");
                Navigator.of(context).pop(); // Close the dialog
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
