import 'package:flutter/material.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        title: 'Support',
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Support Section
              _buildSectionTitle('Contact Support'),
              _buildContactOptions(context),
              // FAQ Section
              _buildSectionTitle('Frequently Asked Questions'),
              _buildFAQSection(),
              // Feedback Form Section
              _buildSectionTitle('Submit Feedback'),
              _buildFeedbackForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    final contactOptions = [
      {
        'title': 'Call Us',
        'subtitle': '+91 123-456-7890',
        'icon': Icons.phone_outlined,
        'color': const Color(0xFF10B981),
        'onTap': () {
          // Placeholder for call functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Calling support...')),
          );
        },
      },
      {
        'title': 'Email Us',
        'subtitle': 'support@kredipal.com',
        'icon': Icons.email_outlined,
        'color': Colors.orange.shade600,
        'onTap': () {
          // Placeholder for email functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening email client...')),
          );
        },
      },
      {
        'title': 'Live Chat',
        'subtitle': 'Chat with us now',
        'icon': Icons.chat_outlined,
        'color': const Color(0xFF8B5CF6),
        'onTap': () {
          // Placeholder for chat functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Starting live chat...')),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: contactOptions.length,
      itemBuilder: (context, index) {
        final option = contactOptions[index];
        return _buildContactCard(option);
      },
    );
  }

  Widget _buildContactCard(Map<String, dynamic> option) {
    return GestureDetector(
      onTap: option['onTap'],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: option['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                option['icon'],
                color: option['color'],
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              option['title'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              option['subtitle'],
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'How do I apply for a loan?',
        'answer':
            'You can apply for a loan by navigating to the "Loan Products" section on the dashboard and selecting the desired loan type.',
      },
      {
        'question': 'What are the eligibility criteria for a personal loan?',
        'answer':
            'Eligibility criteria include being above 21 years, having a stable income, and a good credit score.',
      },
      {
        'question': 'How can I track my loan application status?',
        'answer':
            'Loan status tracking is coming soon! You’ll be able to track your application directly from the dashboard.',
      },
      {
        'question': 'What documents are required for a business loan?',
        'answer':
            'Required documents include business registration, financial statements, and proof of identity.',
      },
    ];

    return Column(
      children: faqs.map((faq) => _buildFAQItem(faq)).toList(),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq['question']!,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            faq['answer']!,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
      tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      childrenPadding: const EdgeInsets.only(bottom: 8),
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildFeedbackForm(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          TextField(
            controller: feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your feedback here...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (feedbackController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Feedback submitted!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                feedbackController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your feedback')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
