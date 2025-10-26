import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ResumeUploadSection extends StatelessWidget {
  final PlatformFile? selectedResume;
  final VoidCallback onUpload;
  final VoidCallback onRemove;
  final Function(PlatformFile) onDownload;

  const ResumeUploadSection({
    super.key,
    required this.selectedResume,
    required this.onUpload,
    required this.onRemove,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Resume',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        if (selectedResume == null)
          InkWell(
            onTap: onUpload,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Click to upload resume',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'PDF, DOC, DOCX (max. 10MB)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedResume!.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(selectedResume!.size / 1024).toStringAsFixed(2)} KB',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.green),
                  onPressed: () => onDownload(selectedResume!),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
