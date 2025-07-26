import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart' as transaction_model;

class TransactionNotifier
    extends StateNotifier<List<transaction_model.Transaction>> {
  TransactionNotifier() : super([]) {
    _loadUserTransactions();
  }

  Future<void> _loadUserTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = [];
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      final transactions = snapshot.docs
          .where((doc) => doc.id != 'init') // Skip init document
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return transaction_model.Transaction.fromJson(data);
          })
          .toList();

      state = transactions;
    } catch (e) {
      print("Error loading transactions: $e");
      state = [];
    }
  }

  Future<void> addTransaction(transaction_model.Transaction transaction) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Add to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add(transaction.toJson());

      // Create new transaction with Firestore ID
      final newTransaction = transaction_model.Transaction(
        id: docRef.id,
        title: transaction.title,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        date: transaction.date,
        description: transaction.description,
      );

      // Update local state
      state = [newTransaction, ...state];
    } catch (e) {
      print("Error adding transaction: $e");
    }
  }

  Future<void> removeTransaction(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Remove from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .delete();

      // Update local state
      state = state.where((transaction) => transaction.id != id).toList();
    } catch (e) {
      print("Error removing transaction: $e");
    }
  }

  Future<void> updateTransaction(
    transaction_model.Transaction updatedTransaction,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(updatedTransaction.id)
          .update(updatedTransaction.toJson());

      // Update local state
      state = state.map((transaction) {
        return transaction.id == updatedTransaction.id
            ? updatedTransaction
            : transaction;
      }).toList();
    } catch (e) {
      print("Error updating transaction: $e");
    }
  }

  double get totalBalance {
    return state.fold<double>(0, (sum, transaction) {
      return transaction.type == transaction_model.TransactionType.income
          ? sum + transaction.amount
          : sum - transaction.amount;
    });
  }

  double get totalIncome {
    return state
        .where(
          (transaction) =>
              transaction.type == transaction_model.TransactionType.income,
        )
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpenses {
    return state
        .where(
          (transaction) =>
              transaction.type == transaction_model.TransactionType.expense,
        )
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
  }

  List<transaction_model.Transaction> get recentTransactions {
    final sorted = [...state];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  Map<String, double> get expensesByCategory {
    final expenses = state.where(
      (t) => t.type == transaction_model.TransactionType.expense,
    );
    final Map<String, double> categoryTotals = {};

    for (final transaction in expenses) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  List<transaction_model.Transaction> getTransactionsByMonth(DateTime month) {
    return state.where((transaction) {
      return transaction.date.year == month.year &&
          transaction.date.month == month.month;
    }).toList();
  }

  // Method to refresh transactions
  Future<void> refreshTransactions() async {
    await _loadUserTransactions();
  }

  // Method to clear transactions when user logs out
  void clearTransactions() {
    state = [];
  }
}

final transactionProvider =
    StateNotifierProvider<
      TransactionNotifier,
      List<transaction_model.Transaction>
    >((ref) => TransactionNotifier());
