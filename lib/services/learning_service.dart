import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mintworth/models/learning_module.dart';

class LearningService {
  // Get the static modules list (can move to a global read-only collection later)
  Future<List<LearningModule>> getAllModules() async {
    return _getSampleModules();
  }

  // Fetch completed module IDs for the current user
  Future<List<String>> getCompletedModuleIds() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    final modulesMap = data?['modules'];
    if (modulesMap != null && modulesMap['completedIds'] != null) {
      return List<String>.from(modulesMap['completedIds']);
    }
    return [];
  }

  // Mark module as completed for this user
  Future<void> markModuleCompleted(String moduleId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final doc = await userDoc.get();
    final modulesMap = doc.data()?['modules'] ?? {};
    final completedIds = List<String>.from(modulesMap['completedIds'] ?? []);
    if (!completedIds.contains(moduleId)) {
      completedIds.add(moduleId);
      await userDoc.update({'modules.completedIds': completedIds});
    }
  }

  List<LearningModule> _getSampleModules() {
    final now = DateTime.now();
    return [
      LearningModule(
        id: 'module1',
        title: 'Budgeting Basics',
        description: 'Learn how to create and maintain a budget',
        category: 'Budgeting',
        content: '''Master the 50-30-20 rule for smart budgeting:

• 50% for Needs: Essential expenses like rent, groceries, utilities, and transportation
• 30% for Wants: Entertainment, dining out, hobbies, and lifestyle choices
• 20% for Savings: Emergency fund, investments, and debt repayment

Track your spending by categorizing expenses. Use apps or maintain a simple spreadsheet. Review monthly to identify areas for improvement.

Set realistic goals and automate savings to ensure consistency. Remember, budgeting is about balance, not restriction.''',
        pointsReward: 100,
        quiz: [
          QuizQuestion(
            question: 'According to the 50-30-20 rule, what percentage should go to savings?',
            options: ['10%', '15%', '20%', '25%'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'Which is a "Need" expense?',
            options: ['Netflix subscription', 'Grocery shopping', 'Movie tickets', 'Gaming console'],
            correctAnswerIndex: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      LearningModule(
        id: 'module2',
        title: 'Understanding SIP',
        description: 'Learn about Systematic Investment Plans',
        category: 'Investing',
        content: '''Systematic Investment Plan (SIP) allows you to invest small amounts regularly in mutual funds.

Benefits of SIP:
• Rupee Cost Averaging: Buy more units when prices are low, fewer when high
• Power of Compounding: Earn returns on returns over time
• Disciplined Investing: Build wealth systematically without market timing
• Affordable: Start with as little as ₹500/month

Example: ₹5,000/month SIP for 20 years at 12% returns = ₹50 lakh investment becomes ₹1.5 crore!

Choose equity funds for long-term (5+ years), debt funds for short-term goals.''',
        pointsReward: 100,
        quiz: [
          QuizQuestion(
            question: 'What is the minimum amount to start a SIP?',
            options: ['₹100', '₹500', '₹1,000', '₹5,000'],
            correctAnswerIndex: 1,
          ),
          QuizQuestion(
            question: 'Which type of fund is suitable for goals beyond 5 years?',
            options: ['Liquid funds', 'Debt funds', 'Equity funds', 'Money market funds'],
            correctAnswerIndex: 2,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      LearningModule(
        id: 'module3',
        title: 'UPI Decoded',
        description: 'Master Unified Payments Interface',
        category: 'Digital Payments',
        content: '''UPI (Unified Payments Interface) revolutionized digital payments in India.

Key Features:
• Instant money transfer 24/7
• Single mobile app for multiple bank accounts
• Virtual Payment Address (VPA) - No need to share bank details
• Secure with two-factor authentication

How to use safely:
✓ Set a strong UPI PIN
✓ Never share OTP or PIN with anyone
✓ Verify merchant VPA before paying
✓ Check transaction history regularly
✓ Use only official UPI apps

Popular UPI apps: Google Pay, PhonePe, Paytm, BHIM UPI.''',
        pointsReward: 100,
        quiz: [
          QuizQuestion(
            question: 'What should you NEVER share with anyone?',
            options: ['Your VPA', 'Your name', 'Your UPI PIN', 'Your phone number'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'What does VPA stand for?',
            options: ['Virtual Payment App', 'Virtual Payment Address', 'Verified Payment Account', 'Valid Payment Access'],
            correctAnswerIndex: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      LearningModule(
        id: 'module4',
        title: 'Credit Score 101',
        description: 'Understanding your credit score',
        category: 'Credit',
        content: '''Your credit score (300-900) determines loan eligibility and interest rates.

Credit Score Ranges:
• 750-900: Excellent - Best rates, easy approvals
• 650-749: Good - Decent rates
• 550-649: Fair - Higher rates, limited options
• Below 550: Poor - Loan rejections likely

How to improve:
✓ Pay credit card bills on time
✓ Keep credit utilization below 30%
✓ Maintain old credit accounts
✓ Avoid multiple loan applications
✓ Check credit report annually

Even one late payment can drop your score by 50-100 points. Pay at least the minimum due before the due date.''',
        pointsReward: 100,
        quiz: [
          QuizQuestion(
            question: 'What is considered an excellent credit score?',
            options: ['Above 600', 'Above 650', 'Above 700', 'Above 750'],
            correctAnswerIndex: 3,
          ),
          QuizQuestion(
            question: 'What should be your credit utilization ratio?',
            options: ['Below 10%', 'Below 30%', 'Below 50%', 'Below 70%'],
            correctAnswerIndex: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      LearningModule(
        id: 'module5',
        title: 'Tax Basics',
        description: 'Understanding income tax in India',
        category: 'Taxes',
        content: '''Income Tax in India operates under two regimes:

Old Regime:
• Higher tax rates but allows deductions
• Section 80C: ₹1.5 lakh (PPF, ELSS, Insurance)
• Section 80D: ₹25,000 (Health insurance)
• HRA, Home loan interest deductions

New Regime (Default):
• Lower tax rates but NO deductions
• Simplified structure

Tax Slabs (New Regime 2024):
• Up to ₹3 lakh: Nil
• ₹3-7 lakh: 5%
• ₹7-10 lakh: 10%
• ₹10-12 lakh: 15%
• ₹12-15 lakh: 20%
• Above ₹15 lakh: 30%

File ITR before July 31st every year to avoid penalties.''',
        pointsReward: 100,
        quiz: [
          QuizQuestion(
            question: 'What is the maximum deduction under Section 80C?',
            options: ['₹50,000', '₹1 lakh', '₹1.5 lakh', '₹2 lakh'],
            correctAnswerIndex: 2,
          ),
          QuizQuestion(
            question: 'By when should you file your ITR?',
            options: ['March 31', 'June 30', 'July 31', 'December 31'],
            correctAnswerIndex: 2,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      LearningModule(
        id: 'module6',
        title: 'Emergency Fund',
        description: 'Building your financial safety net',
        category: 'Savings',
        content: '''An emergency fund is money set aside for unexpected expenses.

Why you need it:
• Job loss or income disruption
• Medical emergencies
• Urgent home/vehicle repairs
• Prevents debt accumulation

How much to save:
• Beginners: 3 months of expenses
• Ideal: 6 months of expenses
• Self-employed: 9-12 months of expenses

Where to keep it:
✓ Savings bank account
✓ Liquid mutual funds
✓ Fixed deposits (short-term)

Keep it accessible but separate from daily spending. Build it gradually - start with ₹1,000/month.''',
        pointsReward: 100,
        quiz: [
          QuizQuestion(
            question: 'How many months of expenses should an ideal emergency fund cover?',
            options: ['3 months', '6 months', '12 months', '24 months'],
            correctAnswerIndex: 1,
          ),
          QuizQuestion(
            question: 'Where should you NOT keep your emergency fund?',
            options: ['Savings account', 'Liquid funds', 'Stock market', 'Fixed deposit'],
            correctAnswerIndex: 2,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
