import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/payment_history_response_model.dart';

class ReceiptPdfService {
  /// Generate and download receipt PDF for a transaction
  static Future<void> generateAndDownloadReceipt(
    PaymentTransaction transaction,
  ) async {
    try {
      final pdf = _generatePdf(transaction);
      await _savePdf(pdf, transaction);
    } catch (e) {
      throw Exception('Failed to generate receipt: $e');
    }
  }

  /// Generate PDF document
  static pw.Document _generatePdf(PaymentTransaction transaction) {
    final pdf = pw.Document();

    // Format date
    String formattedDate = 'N/A';
    try {
      final date = DateTime.parse(transaction.createdAt);
      formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(date);
    } catch (e) {
      formattedDate = 'N/A';
    }

    // Determine status color and display text
    final String status = transaction.paymentStatus;
    final bool isRefunded = transaction.planStatus.toLowerCase() == 'refunded';
    final bool isCompleted =
        status.toLowerCase() == 'complete' ||
        status.toLowerCase() == 'completed';

    String displayStatus = status;
    if (isCompleted) {
      displayStatus = 'Completed';
    } else if (isRefunded) {
      displayStatus = 'Refunded';
    } else if (status.toLowerCase() == 'pending') {
      displayStatus = 'Pending';
    }

    final plan = transaction.planId?.title ?? 'N/A';
    final transactionId = transaction.transactionId.isNotEmpty
        ? transaction.transactionId
        : 'N/A';
    final amount = transaction.amount;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F7F9FC'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PAYMENT RECEIPT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#212121'),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Transaction Voucher',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColor.fromHex('#595959'),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Transaction Details Section
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColor.fromHex('#E5E7EB'),
                    width: 1,
                  ),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(6),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Transaction ID and Date
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Transaction ID',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#9CA3AF'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              transactionId,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#212121'),
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Date & Time',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#9CA3AF'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              formattedDate,
                              style: pw.TextStyle(
                                fontSize: 11,
                                color: PdfColor.fromHex('#212121'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 16),

                    // Divider
                    pw.Divider(color: PdfColor.fromHex('#E5E7EB'), height: 1),

                    pw.SizedBox(height: 16),

                    // Plan and Status
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Plan Name',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#9CA3AF'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              plan,
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#212121'),
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Status',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#9CA3AF'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: pw.BoxDecoration(
                                color: isCompleted
                                    ? PdfColor.fromHex('#D1FAE5')
                                    : isRefunded
                                    ? PdfColor.fromHex('#FEE2E2')
                                    : PdfColor.fromHex('#DCEDff'),
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4),
                                ),
                              ),
                              child: pw.Text(
                                displayStatus,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: isCompleted
                                      ? PdfColor.fromHex('#065F46')
                                      : isRefunded
                                      ? PdfColor.fromHex('#991B1B')
                                      : PdfColor.fromHex('#1E40AF'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 16),

                    // Divider
                    pw.Divider(color: PdfColor.fromHex('#E5E7EB'), height: 1),

                    pw.SizedBox(height: 16),

                    // Amount Section
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Subtotal',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex('#595959'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Taxes & Fees',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColor.fromHex('#595959'),
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '\$0.00',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 12),

                    // Divider
                    pw.Divider(color: PdfColor.fromHex('#E5E7EB'), height: 1),

                    pw.SizedBox(height: 12),

                    // Total Amount
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'TOTAL AMOUNT',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#212121'),
                          ),
                        ),
                        pw.Text(
                          '\$${amount.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#2B7FD0'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              // Footer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F3F4F6'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(6),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Thank you for your purchase!',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#212121'),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'This is an automated receipt generated for your transaction. Please keep this for your records.',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor.fromHex('#595959'),
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      'For support or questions, please contact our support team.',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: PdfColor.fromHex('#9CA3AF'),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Document info
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Generated on: ${DateFormat('MMM dd, yyyy HH:mm:ss').format(DateTime.now())}',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColor.fromHex('#9CA3AF'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  /// Save PDF to device
  static Future<void> _savePdf(
    pw.Document pdf,
    PaymentTransaction transaction,
  ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'receipt_${transaction.transactionId}_$timestamp.pdf';

      // Get appropriate directory based on platform
      Directory directory;

      if (Platform.isAndroid) {
        // For Android, use external storage directory (accessible to user)
        final dir = await getExternalStorageDirectory();
        if (dir != null) {
          // Navigate to a user-accessible location
          // /storage/emulated/0/Android/data/package/files
          directory = dir;
        } else {
          // Fallback to internal documents
          directory = await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        // For iOS, use application documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // For other platforms, use application documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      final file = File('${directory.path}/$fileName');

      // Write PDF bytes to file
      final pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes);

      // Open the PDF file
      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      throw Exception('Failed to save receipt: $e');
    }
  }
}
