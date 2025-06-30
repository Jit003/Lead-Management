import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kredipal/constant/app_color.dart';
import 'package:kredipal/widgets/custom_app_bar.dart';

import 'dart:developer' as developer;

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  Map<String, String?> uploadedFiles = {
    'Aadhaar Card': null,
    'PAN Card': null,
    'Bank Statement': null,
  };
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickFile(String documentType) async {
    try {
      if (!mounted) {
        developer.log('Widget not mounted, aborting file pick');
        return;
      }

      String? fileName;

      if (documentType == 'Aadhaar Card' || documentType == 'PAN Card') {
        final picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          fileName = image.name;
          developer.log('Picked $documentType: $fileName');
        } else {
          developer.log('No image selected for $documentType');
        }
      } else if (documentType == 'Bank Statement') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select File Type'),
            content: const Text(
                'Choose to upload an image or PDF for Bank Statement.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      uploadedFiles[documentType] = image.name;
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$documentType uploaded successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                    developer.log('Picked $documentType image: ${image.name}');
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No image selected'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                    developer.log('No image selected for $documentType');
                  }
                },
                child: const Text('Image'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                    allowMultiple: false,
                  );

                  if (result != null &&
                      result.files.isNotEmpty &&
                      result.files.first.name.isNotEmpty) {
                    fileName = result.files.first.name;
                    developer.log('Picked $documentType PDF: $fileName');
                  } else {
                    developer.log('No PDF selected for $documentType');
                  }
                },
                child: const Text('PDF'),
              ),
            ],
          ),
        );

        if (fileName == null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file selected'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }

      if (fileName != null) {
        setState(() {
          uploadedFiles[documentType] = fileName;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$documentType uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (documentType != 'Bank Statement') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file selected'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      developer.log('Error uploading $documentType: $e',
          stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading $documentType: $e'),
            backgroundColor: const Color.fromARGB(255, 255, 101, 101),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _bankAccountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(title: 'Documents', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildDocumentCard(
              title: 'Aadhar Card',
              icon: Icons.perm_identity,
              fileName: uploadedFiles['Aadhaar Card'],
              onUpload: () => _pickFile('Aadhaar Card'),
            ),
            const SizedBox(height: 12),
            _buildDocumentCard(
              title: 'PAN Card',
              icon: Icons.credit_card,
              fileName: uploadedFiles['PAN Card'],
              onUpload: () => _pickFile('PAN Card'),
            ),
            const SizedBox(height: 12),
            _buildDocumentCard(
              title: 'Bank Statement',
              icon: Icons.account_balance,
              fileName: uploadedFiles['Bank Statement'],
              onUpload: () => _pickFile('Bank Statement'),
            ),
            const SizedBox(height: 24),
            _buildBankAccountForm(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      uploadedFiles.values
                          .every((file) => file != null && file.isNotEmpty)) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Documents submitted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please upload all documents and fill bank details',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: Color.fromARGB(255, 255, 101, 101),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.btnColor,
                  disabledBackgroundColor: const Color(0xFFCCCCCC),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Documents',
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildDocumentCard({
    required String title,
    required IconData icon,
    required String? fileName,
    required VoidCallback onUpload,
  }) {
    return Container(
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
            child: Icon(icon, color: Colors.teal, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName != null && fileName.isNotEmpty
                      ? fileName
                      : 'No file uploaded',
                  style: TextStyle(
                    fontSize: 11,
                    color: fileName != null && fileName.isNotEmpty
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onUpload,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal),
              ),
              child: Text(
                fileName != null && fileName.isNotEmpty ? 'Replace' : 'Upload',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountForm() {
    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bank Account Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bankAccountController,
              decoration: InputDecoration(
                labelText: 'Bank Account Number',
                labelStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: const Icon(
                  Icons.account_balance,
                  color: Colors.teal,
                  size: 20,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter bank account number';
                }
                if (!RegExp(r'^\d{9,18}$').hasMatch(value)) {
                  return 'Enter a valid account number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ifscController,
              decoration: InputDecoration(
                labelText: 'IFSC Code',
                labelStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: const Icon(
                  Icons.code,
                  color: Colors.teal,
                  size: 20,
                ),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter IFSC code';
                }
                if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
                  return 'Enter a valid IFSC code';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
