import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ResumeUploadSection extends StatefulWidget {
  final PlatformFile? selectedResume;
  final String? existingResumeId;
  final Future<void> Function() onUpload;
  final VoidCallback onRemove;
  final Function(PlatformFile) onDownload;
  final bool isLoading;
  final bool showTitle;

  const ResumeUploadSection({
    super.key,
    required this.selectedResume,
    this.existingResumeId,
    required this.onUpload,
    required this.onRemove,
    required this.onDownload,
    this.isLoading = false,
    this.showTitle = true,
  });

  @override
  State<ResumeUploadSection> createState() => _ResumeUploadSectionState();
}

class _ResumeUploadSectionState extends State<ResumeUploadSection> {
  bool _isProcessing = false;

  Future<void> _onUploadTap() async {
    // Prevent rapid/concurrent taps
    if (_isProcessing || widget.isLoading) {
      print('⚠️ File picker already in progress on ${Platform.operatingSystem}');
      return;
    }

    _isProcessing = true;
    try {
      await widget.onUpload();
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          const Text(
            'Upload Resume',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (widget.selectedResume == null &&
            widget.existingResumeId != null &&
            widget.existingResumeId!.trim().isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Text(
              'Using your existing resume on file. Upload a new file only if you want to replace it for this application.',
              style: TextStyle(fontSize: 13),
            ),
          ),
        if (widget.selectedResume == null)
          InkWell(
            onTap: widget.isLoading ? null : () => _onUploadTap(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: widget.isLoading ? Colors.grey[300]! : Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload, size: 40, color: widget.isLoading ? Colors.grey[300] : Colors.grey),
                  const SizedBox(height: 8),
                  if (widget.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      'Click to upload resume',
                      style: TextStyle(color: Colors.grey),
                    ),
                  if (!widget.isLoading)
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
                        widget.selectedResume!.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(widget.selectedResume!.size / 1024).toStringAsFixed(2)} KB',
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
                  onPressed: () => widget.onDownload(widget.selectedResume!),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
