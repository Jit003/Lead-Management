import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';
import 'document_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredLeads = [];

  // Sample lead data (replace with API/database in production)
  final List<Map<String, String>> _leads = [
    {
      'name': 'Punya Sahoo',
      'phone': '8144021906',
      'email': 'punyapravasahoo17@gmail.com',
      'leadType': 'Credit Card',
    },
    {
      'name': 'Jayashree Jena',
      'phone': '8797345621',
      'email': 'jjena2002@gmail.com',
      'leadType': 'Loan',
    },
    {
      'name': 'Ravi Kumar',
      'phone': '9876543210',
      'email': 'ravi.kumar@gmail.com',
      'leadType': 'Credit Card',
    },
    {
      'name': 'Anita Sharma',
      'phone': '8765432109',
      'email': 'anita.sharma@gmail.com',
      'leadType': 'Loan',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredLeads = _leads; 
    _searchController.addListener(_filterLeads);
  }

  void _filterLeads() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLeads = _leads.where((lead) {
        return lead['name']!.toLowerCase().contains(query) ||
            lead['phone']!.toLowerCase().contains(query) ||
            lead['email']!.toLowerCase().contains(query) ||
            lead['leadType']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(title: 'Search Leads', actions: []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, phone, email, or lead type',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
              onChanged: (value) => _filterLeads(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Leads',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredLeads.isEmpty
                  ? const Center(
                      child: Text(
                        'No leads found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredLeads.length,
                      itemBuilder: (context, index) {
                        final lead = _filteredLeads[index];
                        return _buildLeadCard(
                          name: lead['name']!,
                          phone: lead['phone']!,
                          email: lead['email']!,
                          leadType: lead['leadType']!,
                          onTap: () {
                            Get.to(() => const DocumentScreen());
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadCard({
    required String name,
    required String phone,
    required String email,
    required String leadType,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Colors.teal, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lead Type: $leadType',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal),
              ),
              child: const Text(
                'Upload Documents',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}