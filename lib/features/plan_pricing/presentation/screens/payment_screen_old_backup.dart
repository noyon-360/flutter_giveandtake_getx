import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/paypal_webview_screen.dart';
import 'package:karlfive/features/plan_pricing/presentation/screens/plan_pricing_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String planTitle;
  final double amount;
  final String? orderId;
  final String? approveUrl;

  const PaymentScreen({
    super.key,
    required this.planTitle,
    this.amount = 0.00,
    this.orderId,
    this.approveUrl,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  bool _showCardForm = false;
  bool _isCardPaymentProcessing = false;

  // Form controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  bool _deliverToBillingAddress = true;
  String _selectedCountry = 'GB'; // Default UK
  String? _selectedCounty;

  // Countries and Counties lists
  List<Map<String, String>> _countries = [];
  List<String> _counties = [];
  bool _isLoadingCountries = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoadingCountries = true;
    });

    // TODO: Replace with actual PayPal API call
    // Simulating API response with common countries
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _countries = [
        {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧'},
        {'code': 'US', 'name': 'United States', 'flag': '🇺🇸'},
        {'code': 'CA', 'name': 'Canada', 'flag': '🇨🇦'},
        {'code': 'AU', 'name': 'Australia', 'flag': '🇦🇺'},
        {'code': 'DE', 'name': 'Germany', 'flag': '🇩🇪'},
        {'code': 'FR', 'name': 'France', 'flag': '🇫🇷'},
        {'code': 'IT', 'name': 'Italy', 'flag': '🇮🇹'},
        {'code': 'ES', 'name': 'Spain', 'flag': '🇪🇸'},
        {'code': 'NL', 'name': 'Netherlands', 'flag': '🇳🇱'},
        {'code': 'SE', 'name': 'Sweden', 'flag': '🇸🇪'},
      ];
      _isLoadingCountries = false;
      _loadCountiesForCountry(_selectedCountry);
    });
  }

  void _loadCountiesForCountry(String countryCode) {
    // TODO: Replace with actual PayPal API call
    // Simulating county/state data based on country
    if (countryCode == 'GB') {
      _counties = [
        'Aberdeenshire',
        'Angus',
        'Argyll and Bute',
        'Bedfordshire',
        'Berkshire',
        'Bristol',
        'Buckinghamshire',
        'Cambridgeshire',
        'Cheshire',
        'Cornwall',
        'Cumbria',
        'Derbyshire',
        'Devon',
        'Dorset',
        'Durham',
        'East Sussex',
        'Essex',
        'Gloucestershire',
        'Greater London',
        'Greater Manchester',
        'Hampshire',
        'Hertfordshire',
        'Kent',
        'Lancashire',
        'Leicestershire',
        'Lincolnshire',
        'Merseyside',
        'Norfolk',
        'North Yorkshire',
        'Northamptonshire',
        'Nottinghamshire',
        'Oxfordshire',
        'Shropshire',
        'Somerset',
        'South Yorkshire',
        'Staffordshire',
        'Suffolk',
        'Surrey',
        'Tyne and Wear',
        'Warwickshire',
        'West Midlands',
        'West Sussex',
        'West Yorkshire',
        'Wiltshire',
        'Worcestershire',
      ];
    } else if (countryCode == 'US') {
      _counties = [
        'Alabama',
        'Alaska',
        'Arizona',
        'Arkansas',
        'California',
        'Colorado',
        'Connecticut',
        'Delaware',
        'Florida',
        'Georgia',
        // Add more US states as needed
      ];
    } else {
      _counties = [];
    }

    // Reset selected county when country changes
    if (!_counties.contains(_selectedCounty)) {
      _selectedCounty = null;
    }
  }

  Future<void> _handlePayPalPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Navigate to PayPal WebView for payment
    Get.to(
      () => PaypalWebViewScreen(
        planTitle: widget.planTitle,
        amount: widget.amount,
        orderId: widget.orderId,
        onFinish: (transactionId) {
          setState(() {
            _isProcessing = false;
          });

          // Payment completed successfully
          Get.snackbar(
            'Payment Completed',
            'Payment succeeded for ${widget.planTitle}!\nTransaction ID: $transactionId',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Navigate back to plan pricing screen after delay
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAll(() => PlanPricingScreen());
          });
        },
      ),
    )?.then((_) {
      setState(() {
        _isProcessing = false;
      });
    });
  }

  void _handleDebitCardPayment() {
    setState(() {
      _showCardForm = !_showCardForm;
    });
  }

  Future<void> _processCardPayment() async {
    // Validate all fields
    if (_cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _address1Controller.text.isEmpty ||
        _cityController.text.isEmpty ||
        _postcodeController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isCardPaymentProcessing = true;
    });

    // TODO: Implement PayPal GraphQL API call
    // For now, simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isCardPaymentProcessing = false;
    });

    Get.snackbar(
      'Payment Processing',
      'Card payment functionality will be implemented with PayPal GraphQL API',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header - Payment title
              const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0070BA),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Complete your secure payment using our trusted\npayment methods.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2C2C2C),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Pay with PayPal section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pay with PayPal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // PayPal Button (Yellow)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handlePayPalPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC439),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFF003087),
                            ),
                          ),
                        )
                      : Image.asset(
                          'assets/images/paypal_logo.png',
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              'PayPal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003087),
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Debit or Credit Card Button (Black)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleDebitCardPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2E2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Debit or Credit Card',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card Payment Form (Expandable)
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _showCardForm
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: _buildCardPaymentForm(),
              ),

              const SizedBox(height: 8),

              // Powered by PayPal
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Powered by ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6C6C6C),
                    ),
                  ),
                  Image.asset(
                    'assets/images/paypal_logo.png',
                    height: 14,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'PayPal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0070BA),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Summary Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Payment Details
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment Details:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Plan ID
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '•  ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: 'Plan ID: '),
                            TextSpan(
                              text:
                                  widget.orderId ?? '68f5d69263f7f2594042c309',
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Charges info
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•  ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Charges include Applicable VAT/GST and/or Sales Taxes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Total Amount
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\$${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0070BA),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Safe & secure payment
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Safe & secure payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Description text
              const Text(
                'Your payment information is processed securely. We do not store your credit card details.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF4A4A4A),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Payment method icons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Visa/Mastercard
                  Container(
                    width: 70,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A1F71), Color(0xFFED1C24)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/visa_card.png',
                        height: 30,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.credit_card,
                            color: Colors.white,
                            size: 24,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // PayPal
                  Container(
                    width: 70,
                    height: 45,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/paypal_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'PP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0070BA),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Generic Card
                  Container(
                    width: 70,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF79E1B), Color(0xFFFF6B00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Security Badge
                  Container(
                    width: 70,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0070BA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showCardForm = false;
                  });
                },
                icon: const Icon(Icons.close, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Card Number
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Card number',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: 'Expires',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Security code',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Billing address header
          Row(
            children: [
              const Text(
                'Billing address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // Country flag and dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      _countries.firstWhere(
                            (c) => c['code'] == _selectedCountry,
                            orElse: () => {'flag': '�'},
                          )['flag'] ??
                          '🌍',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4),
                    DropdownButton<String>(
                      value: _selectedCountry,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                      items: _countries.isEmpty
                          ? [
                              const DropdownMenuItem(
                                value: 'GB',
                                child: Text(''),
                              ),
                            ]
                          : _countries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['code'],
                                child: Row(
                                  children: [
                                    Text(
                                      country['flag'] ?? '🌍',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      country['name'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountry = value ?? 'GB';
                          _loadCountiesForCountry(_selectedCountry);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // First name and Last name
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: 'First name',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: 'Last name',
                    hintStyle: const TextStyle(color: Color(0xFF999999)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address line 1
          TextField(
            controller: _address1Controller,
            decoration: InputDecoration(
              hintText: 'Address line 1',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Address line 2
          TextField(
            controller: _address2Controller,
            decoration: InputDecoration(
              hintText: 'Address line 2',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Town/City
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: 'Town/City',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // County (Optional) - Dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCounty,
              decoration: const InputDecoration(
                hintText: 'County (Optional)',
                hintStyle: TextStyle(color: Color(0xFF999999)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              isExpanded: true,
              items: [
                if (_counties.isEmpty)
                  const DropdownMenuItem<String>(
                    value: '',
                    child: Text(
                      'County (Optional)',
                      style: TextStyle(color: Color(0xFF999999)),
                    ),
                  ),
                ..._counties.map((county) {
                  return DropdownMenuItem<String>(
                    value: county,
                    child: Text(county),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCounty = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // Postcode
          TextField(
            controller: _postcodeController,
            decoration: InputDecoration(
              hintText: 'Postcode',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Mobile
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Mobile',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              prefixText: '+44  ',
              prefixStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Email
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Deliver to billing address checkbox
          Row(
            children: [
              Checkbox(
                value: _deliverToBillingAddress,
                onChanged: (value) {
                  setState(() {
                    _deliverToBillingAddress = value ?? true;
                  });
                },
                activeColor: const Color(0xFF0070BA),
              ),
              const Expanded(
                child: Text(
                  'Deliver to billing address',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Terms and conditions
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'You acknowledge the '),
                TextSpan(
                  text: 'terms',
                  style: const TextStyle(
                    color: Color(0xFF0070BA),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(
                  text:
                      ' of the service PayPal provides to the seller and agree to the ',
                ),
                TextSpan(
                  text: 'Privacy Statement',
                  style: const TextStyle(
                    color: Color(0xFF0070BA),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: '. No PayPal account required.'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pay button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isCardPaymentProcessing ? null : _processCardPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070BA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: _isCardPaymentProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      'Pay \$${widget.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Powered by PayPal
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Powered by ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6C6C6C),
                ),
              ),
              Image.asset(
                'assets/images/paypal_logo.png',
                height: 14,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'PayPal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0070BA),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
