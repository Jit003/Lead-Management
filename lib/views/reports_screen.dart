import 'package:flutter/material.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedReportType = 'All';
  List<Map<String, dynamic>> _filteredReports = [];
  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Lead Conversion Report',
      'type': 'Leads',
      'metrics': {
        'Total Leads': 150,
        'Converted': 45,
        'Pending': 105,
      },
      'date': '2025-06-10',
    },
    {
      'title': 'Document Upload Status',
      'type': 'Documents',
      'metrics': {
        'Submitted': 80,
        'Pending': 20,
        'Rejected': 10,
      },
      'date': '2025-06-09',
    },
    {
      'title': 'Credit Card Applications',
      'type': 'Applications',
      'metrics': {
        'Approved': 30,
        'In Progress': 15,
        'Declined': 5,
      },
      'date': '2025-06-08',
    },
    {
      'title': 'Loan Applications',
      'type': 'Applications',
      'metrics': {
        'Approved': 25,
        'In Progress': 10,
        'Declined': 3,
      },
      'date': '2025-06-07',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredReports = _reports;
    _searchController.addListener(_filterReports);
  }

  void _filterReports() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReports = _reports.where((report) {
        final matchesQuery = report['title'].toLowerCase().contains(query) ||
            report['date'].toLowerCase().contains(query);
        final matchesType = _selectedReportType == 'All' ||
            report['type'] == _selectedReportType;
        return matchesQuery && matchesType;
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
      appBar: CustomAppBar(title: 'Reports', actions: []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reports by title or date',
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
              onChanged: (value) => _filterReports(),
            ),
            const SizedBox(height: 16),
            // Filter Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Reports',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedReportType,
                  items: ['All', 'Leads', 'Documents', 'Applications']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReportType = value!;
                      _filterReports();
                    });
                  },
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  underline: Container(),
                  dropdownColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Reports List
            Expanded(
              child: _filteredReports.isEmpty
                  ? const Center(
                      child: Text(
                        'No reports found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredReports.length,
                      itemBuilder: (context, index) {
                        final report = _filteredReports[index];
                        return _buildReportCard(
                          title: report['title'],
                          type: report['type'],
                          metrics: report['metrics'],
                          date: report['date'],
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Viewing details for ${report['title']}'),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          },
                          onExport: () {
                            // Placeholder for export functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Exporting ${report['title']}'),
                                backgroundColor: Colors.teal,
                              ),
                            );
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

  Widget _buildReportCard({
    required String title,
    required String type,
    required Map<String, dynamic> metrics,
    required String date,
    required VoidCallback onTap,
    required VoidCallback onExport,
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
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Date: $date',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            ...metrics.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                // key: onExport,
                onPressed: () {},
                child: Text(
                  'Export Report',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.btnColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
