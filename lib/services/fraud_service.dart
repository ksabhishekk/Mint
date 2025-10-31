import 'package:mintworth/models/fraud_challenge.dart';
import 'package:mintworth/services/local_storage_service.dart';

class FraudService {
  static const String _key = 'fraud_challenges';

  Future<List<FraudChallenge>> getAllChallenges() async {
    final jsonList = LocalStorageService.getJsonList(_key);
    if (jsonList != null && jsonList.isNotEmpty) {
      return jsonList.map((json) => FraudChallenge.fromJson(json)).toList();
    }

    final challenges = _getSampleChallenges();
    await saveChallenges(challenges);
    return challenges;
  }

  Future<void> saveChallenges(List<FraudChallenge> challenges) async {
    await LocalStorageService.saveJsonList(_key, challenges.map((c) => c.toJson()).toList());
  }

  Future<void> markChallengeCompleted(String challengeId) async {
    final challenges = await getAllChallenges();
    final index = challenges.indexWhere((c) => c.id == challengeId);
    if (index >= 0) {
      challenges[index] = challenges[index].copyWith(isCompleted: true, updatedAt: DateTime.now());
      await saveChallenges(challenges);
    }
  }

  List<FraudChallenge> _getSampleChallenges() {
    final now = DateTime.now();
    return [
      FraudChallenge(
        id: 'fraud1',
        title: 'Fake KYC Update',
        scenario: '''You receive an SMS: "Your bank account will be blocked in 24 hours. Update KYC immediately by clicking: bit.ly/kyc-update786. Call 9876543210 for help."

The link asks for your ATM card number, CVV, and OTP.''',
        type: 'Phishing',
        redFlags: [
          'Urgency tactics (24-hour deadline)',
          'Suspicious shortened link',
          'Bank never asks for CVV/OTP via SMS',
          'Generic message, no personalization',
        ],
        correctAction: 'Ignore the message and contact your bank directly through official channels',
        options: [
          'Click the link and update KYC immediately',
          'Call the number provided to verify',
          'Ignore and contact bank through official app/website',
          'Forward the SMS to friends as warning',
        ],
        correctOptionIndex: 2,
        pointsReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      FraudChallenge(
        id: 'fraud2',
        title: 'Wrong UPI Transfer',
        scenario: '''You receive a call: "Hello, I accidentally sent ₹5,000 to your UPI ID. Please return it immediately. Send to this VPA: refund@paytm"

The caller sounds distressed and keeps rushing you.''',
        type: 'UPI Fraud',
        redFlags: [
          'Unsolicited call about money transfer',
          'Pressure to act quickly',
          'No money actually received in your account',
          'VPA looks suspicious',
        ],
        correctAction: 'Verify your transaction history first - if no money received, it\'s a scam',
        options: [
          'Immediately send money to help the person',
          'Check your account first, if no credit received, ignore',
          'Ask for their bank details instead of UPI',
          'Send half the amount as compromise',
        ],
        correctOptionIndex: 1,
        pointsReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      FraudChallenge(
        id: 'fraud3',
        title: 'Investment WhatsApp Group',
        scenario: '''You're added to a WhatsApp group "Stock Tips Pro" with 200 members. Admin shares: "Invest ₹10,000 in XYZ penny stock today, guaranteed 500% returns in 1 month! Limited slots. DM for account details."

Several members post screenshots of huge profits.''',
        type: 'Investment Scam',
        redFlags: [
          'Guaranteed returns (no investment is guaranteed)',
          'Penny stock pump-and-dump scheme',
          'Unsolicited group addition',
          'Fake testimonials/screenshots',
          'Pressure with "limited slots"',
        ],
        correctAction: 'Exit the group and report as spam - legitimate investments don\'t guarantee returns',
        options: [
          'Invest ₹10,000 to test the opportunity',
          'Ask for more proof before investing',
          'Exit group immediately and report',
          'Invest small amount like ₹1,000 first',
        ],
        correctOptionIndex: 2,
        pointsReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      FraudChallenge(
        id: 'fraud4',
        title: 'Lottery Winner',
        scenario: '''Email received: "Congratulations! You have won ₹25 Lakh in Kaun Banega Crorepati lottery. To claim prize, pay processing fee of ₹5,000 to account number 1234567890."

Email has KBC logo and looks official.''',
        type: 'Lottery Scam',
        redFlags: [
          'You never participated in any lottery',
          'Asking for money to claim prize',
          'Legitimate lotteries deduct taxes from winnings',
          'Sent via email, not official communication',
        ],
        correctAction: 'Delete the email - you cannot win a lottery you never entered',
        options: [
          'Pay ₹5,000 to claim the ₹25 lakh prize',
          'Negotiate to pay ₹2,000 instead',
          'Delete email, it\'s a scam',
          'Reply asking for more details',
        ],
        correctOptionIndex: 2,
        pointsReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      FraudChallenge(
        id: 'fraud5',
        title: 'Fake Customer Care',
        scenario: '''You search Google for "Flipkart customer care number" and call the first result. The agent says: "Your refund is stuck. To release it, install AnyDesk app and share the code with me."''',
        type: 'Remote Access Scam',
        redFlags: [
          'Google search result might be fake ad',
          'Asking to install remote access app',
          'Real customer care never needs device access',
          'Genuine refunds process automatically',
        ],
        correctAction: 'Hang up and contact customer care through official app only',
        options: [
          'Install AnyDesk and share code',
          'Share code but don\'t allow access',
          'Hang up, use official app to contact support',
          'Ask them to email instructions instead',
        ],
        correctOptionIndex: 2,
        pointsReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
      FraudChallenge(
        id: 'fraud6',
        title: 'Fake Job Offer',
        scenario: '''You receive: "Congratulations! Selected for Data Entry job at Amazon. Work from home. Salary ₹25,000/month. Pay ₹3,000 registration fee to jobs@amazon-india.com to receive your offer letter and laptop."''',
        type: 'Job Scam',
        redFlags: [
          'Legitimate companies never charge registration fees',
          'Email domain is fake (not @amazon.com)',
          'Too-good-to-be-true salary for simple work',
          'No interview process mentioned',
        ],
        correctAction: 'Ignore - real companies don\'t charge candidates for jobs',
        options: [
          'Pay ₹3,000 to secure the job',
          'Negotiate lower registration fee',
          'Ignore completely, it\'s a scam',
          'Ask for offer letter first, then pay',
        ],
        correctOptionIndex: 2,
        pointsReward: 50,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
