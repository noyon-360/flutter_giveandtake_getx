import 'package:flutter/material.dart';
import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

class TermsandConditions extends StatelessWidget {
  const TermsandConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "Terms & Conditions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
        
              /// 1. Introduction
              Text(
                "1. Introduction",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "When you use Elevator Video Pitch (EVP) you agree to all these terms. "
                    "When you register and join the Elevator Video Pitch site, you become a “Member”. "
                    "If you have chosen not to register for our Services, you may access limited features as a “Visitor”.\n\n"
                    "As a Visitor or Member of our Services, the collection, use, and sharing of your personal data is subject to our Privacy Policy including our use of Cookies. "
                    "This Contract applies to Members and Visitors.\n\n"
                    "By creating an Elevator Video Pitch account or accessing or using our Services, you are agreeing to enter a legally binding contract with Elevator Video Pitch "
                    "(even if you are using third party credentials or using our Services on behalf of a company). If you do not agree to this Contract, do not create an account or "
                    "access or otherwise use any of our Services. If you wish to terminate this Contract at any time, you can do so by disabling your account and no longer accessing or using our Services.\n\n"
                    "This Contract applies to EVPitch.com, Elevator Video Pitch mobile apps, and other communications and services that state that they are offered under this Contract (“Services”), "
                    "including the offsite storage of data for those Services.\n\n"
                    "At all times, you are entering into this Contract with Elevator Video Pitch (also referred to as “we” and “us”), and we will be the controller of your personal data "
                    "provided to or processed in connection with our Services.\n\n"
                    "We may modify this Contract and our Privacy Policy from time to time. If required by applicable laws or we make material changes to this Contract, "
                    "we will provide you notice to provide you the opportunity to review the changes before they become effective.\n\n"
                    "We agree that changes cannot be backdated. If you object to any of these changes, you may delete your account. "
                    "Your continued use of our Services after we publish or send a notice about our changes to these terms means that you are consenting to the updated terms as of their effective date.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// 2. Obligations
              Text(
                "2. Obligations",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "To be eligible to enter this Contract you must be at least our “Minimum Age.” "
                    "“Minimum Age” means 16 years old. However, if local data privacy laws require that you must be older for Elevator Video Pitch to lawfully provide our Services to you "
                    "without parental consent, the local minimum age will prevail. To use the Services, you agree that:\n\n"
                    "2.1  You must be the minimum age or older.\n"
                    "2.2  You will only have one Elevator Video Pitch account, which must be in your real name.\n"
                    "2.3  Creating an account with false information is a violation of our terms.\n"
                    "2.4  You will keep your password a secret (as you would protect your bank PIN number).\n"
                    "2.5  You will not share your account with anyone else and will follow our policies and the law.\n"
                    "2.6  You are responsible for anything that happens through your account unless you close it or report misuse.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// 3. Payment
              Text(
                "3. Payment",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "You will honour your subscription payment obligations and confirm you are okay with us storing your payment information. "
                    "You understand that there may be taxes added to our prices.\n\n"
                    "Refunds are subject to our policy.\n\n"
                    "If you purchase a subscription, your payment method will be automatically charged at the start of each subscription period for the fees and taxes applicable to that period. "
                    "To avoid future charges, please cancel before the renewal date.\n\n"
                    "We may modify our prices effective prospectively upon reasonable notice to the extent allowed under the law.\n\n"
                    "Our monthly paid subscriptions are non-refundable after 7 days and yearly subscriptions non-refundable after 30 days. "
                    "Pro-rata payments will be deducted from refunds if the Elevator Video Pitch account has been used.\n\n"
                    "We may calculate taxes payable by you based on the billing information that you provide us.\n"
                    "You can obtain a copy of your invoice through your Elevator Video Pitch account settings under Payment History.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// 4. Notices and Messages
              Text(
                "4. Notices and Messages",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "You’re okay with us providing notices and messages to you through our websites, mobile apps, and contact information provided. "
                    "If your contact information is out of date, you may miss out on important notices.\n\n"
                    "You agree that we will provide notices and messages to you within the Elevator Pitch Site or sent to the contact information you provided us (e.g., email or mobile number). "
                    "You agree to keep your contact information up to date.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// 5. Sharing
              Text(
                "5. Sharing",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Your profile information is available to all Members and Visitors to the site. "
                    "Your Elevator Video Pitch and CV will only be made available to recruiters when you apply for a job.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// Rights and Limits
              Text(
                "6. Rights and Limits",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "You own your original data including your elevator video pitch and resume that you provide to us, but you also grant us a non-exclusive license to it. "
                    "If content includes personal data, it is subject to our Privacy Policy.\n\n"
                    "You can end this license by deleting your account, and your data will no longer be viewable by recruiters as part of the Services we offer. "
                    "The data will not be retained unless we are required by law to retain or share it with others, nor beyond the reasonable time it takes to remove your account from backup systems.\n\n"
                    "We will not include your CVs, Profiles or Elevator Video Pitches in advertisements, or sell your content to third parties.\n\n"
                    "By submitting suggestions for improvement or other feedback regarding our Services to Elevator Video Pitch, you agree that we can use and share (but do not have to) such feedback for any purpose without compensation to you.\n\n"
                    "You promise to only provide your own Elevator Video Pitch and other information that you have the right to share and that your Elevator Video Pitch profile will be an accurate reflection of your knowledge, skills and experience.\n\n"
                    "You agree to only provide content and other information that does not violate the law or anyone’s rights (including intellectual property rights). "
                    "You have choices about how much information to provide on your profile but also agree that the profile information you provide will be truthful. "
                    "Elevator Video Pitch may be required by law to remove certain content and other information in certain countries.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              SizedBox(height: 20),
        
              /// Service Availability
              Text(
                "7. Service Availability",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "We may change or limit the availability of some features or end any \nService.\n"
                    "We may change, suspend or discontinue any of our Services. "
                    "We may also limit the availability of features, content and other information so that they are not available to all Visitors or Members (e.g., by country or by subscription access).",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              SizedBox(height: 20),
        
              /// Others’ Content
              Text(
                "8. Others’ Content",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "By using the Services, you may encounter content or other information that might be inaccurate, incomplete, delayed, misleading, illegal, offensive, or otherwise harmful. "
                    "You agree that we are not responsible for content or other information made available through or within the Services by others, including Members. "
                    "While we have checks and balances in place to review much of the content and other information presented on our site, we cannot always prevent misuse of our Services, "
                    "and you agree that we are not responsible for any such misuse. You also acknowledge the risk that others may share inaccurate or misleading information about themselves and their previous work history, "
                    "and that you or your organization may therefore be mistakenly associated with content about others, for example, when we list companies known by their current and past employees registered on our site.\n\n"
                    "You further acknowledge that Elevator Video Pitch does not supervise, direct, control, or monitor Members in the making of their elevator video pitches, "
                    "or in their providing recruiters or companies with work, delivering products or performing services, and you agree that:\n\n"
                    "8.1  Elevator Video Pitch is not responsible for offers of labour, or performance or procurement of these.\n"
                    "8.2  Elevator Video Pitch does not evaluate or endorse any Member’s elevator pitch, resume, work history claimed or profile.\n"
                    "8.3  Elevator Video Pitch is not an agent or employment agency on behalf of any Member offering employment or other work, products or services.\n"
                    "8.4  With respect to employment or other work, Elevator Video Pitch does not make employment or hiring decisions on behalf of Members offering opportunities "
                    "and does not have such authority from Members or organizations using our products.\n"
                    "8.5  For Recruiter and Company accounts, you must be at least 18 years of age to advertise jobs, and you must have all the required licenses and provide jobs consistent with the relevant industry standards and local labour regulations.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              SizedBox(height: 20),
        
              /// Limits
              Text(
                "9. Limits",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "We have the right to limit how you interact on our Site.\n\n"
                    "Elevator Video Pitch reserves the right to limit your use of our Services, including your ability to apply for jobs. "
                    "Elevator Video Pitch reserves the right to restrict, suspend, or terminate your account if you breach this Contract or the law or are misusing the Services "
                    "(e.g., by recording inappropriate content in place of a professional Elevator Pitch).\n\n"
                    "We can also remove any content or other information you shared if we believe it violates this Contract.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              SizedBox(height: 20),
        
              /// Intellectual Property Rights
              Text(
                "10. Intellectual Property Rights",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "LinkedIn reserves all its intellectual property rights in the Services. "
                    "Elevator Video Pitch logos and other Elevator Video Pitch trademarks, are owned exclusively by Elevator Video Pitch Ltd.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              SizedBox(height: 20),
        
              /// Recommendations
              Text(
                "11. Recommendations",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "We use the data and other information that you provide and that we have about Members and content on the Services to make recommendations for jobs that may be useful to you. "
                    "Keeping your profile accurate and up to date helps us to make these recommendations more accurate and relevant.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              const SizedBox(height: 20),
        
              /// Disclaimer and Limit of Liability
              Text(
                "12. Disclaimer and Limit of Liability",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "12.1  No Warranty\n"
                    "This is our disclaimer of legal liability for the quality, safety, or reliability of our Services.\n\n"
                    "Elevator Video Pitch and its affiliates make no representation or warranty about our services, "
                    "including any representation that the services will be uninterrupted or error-free, and provide the services "
                    "including content and information on an ‘as is’ and ‘as available’ basis.\n\n"
                    "To the fullest extent permitted under applicable law, Elevator Video Pitch and its affiliates disclaim any implied "
                    "or statutory warranty, including any implied warranty of title, accuracy of data, non-infringement, "
                    "merchantability or fitness for a particular purpose.\n\n"
                    "12.2  Exclusion of Liability\n"
                    "These are the limits of legal liability we may have to you.\n\n"
                    "To the fullest extent permitted by law and unless Elevator Video Pitch has entered into a separate written agreement "
                    "that overrides this contract, Elevator Video Pitch, including its affiliates, will not be liable in connection with "
                    "this contract for lost profits or lost business opportunities, reputation, loss of data (e.g. downtime or loss of, use of "
                    "or changes to your information or content) or any indirect, incidental, consequential, special or punitive damages.\n\n"
                    "Elevator Video Pitch and its affiliates will not be liable to you in connection with this contract for any amount that "
                    "exceeds the total fees paid or payable by you to Elevator Video Pitch for the services during the term of your contract with us.\n\n"
                    "12.3  Exclusions\n"
                    "The limitations of liability in this Section are part of the basis of the agreement between you and Elevator Video Pitch "
                    "and shall apply to all claims of liability (e.g. warranty, tort, negligence, contract and law) even if Elevator Video Pitch "
                    "or its affiliates has been told of the possibility of any such damage, and even if these remedies fail their essential purpose.\n\n"
                    "These limitations of liability do not apply to liability for death or personal injury or for fraud, gross negligence "
                    "or intentional misconduct or in cases of negligence, where a material obligation has been breached. A material obligation "
                    "being an obligation which forms a prerequisite to our delivery of services and one which you may reasonably rely, "
                    "but only to the extent that the damages were caused by the breach and were foreseeable as a precursor to and upon conclusion of the contract.\n\n"
                    "12.4  Termination\n"
                    "Either Elevator Video Pitch or the Member can end this Contract, but some rights and obligations survive.\n\n"
                    "Both you and Elevator Video Pitch may terminate this Contract at any time with notice to the other. "
                    "On termination, you lose the right to access our Services.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              const SizedBox(height: 20),
        
              /// Governing Law and Dispute Resolution
              Text(
                "13. Governing Law and Dispute Resolution",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "In the unlikely event we end up in a legal dispute, you and Elevator Video Pitch agree to resolve it in UK courts using British law.\n\n"
                    "British law governs all claims related to Elevator Video Pitch provision of our Services, but this shall not deprive you of the mandatory consumer protections under the law of the country "
                    "to which we direct your Services where you have habitual residence. With respect to jurisdiction, you and Elevator Video Pitch agree to choose the courts of the country to which we direct your "
                    "Services where you have habitual residence for all disputes arising out of or relating to this User Agreement, alternatively you may choose the responsible court in the UK.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              const SizedBox(height: 20),
        
              /// General Terms
              Text(
                "14. General Terms",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "If a court with authority over this Contract finds any part of it unenforceable, Members and Elevator Video Pitch agree that the court should modify the terms to make that part enforceable "
                    "while still achieving its intent. If the court cannot do that, we and you agree to ask the court to remove that unenforceable part and still enforce the rest of this Contract.\n\n"
                    "This Contract (including additional terms that may be provided by us when you engage with a feature of the Elevator Video Pitch Services) is the only agreement between us and supersedes "
                    "all prior agreements for the Services.\n\n"
                    "If we don’t act to enforce a breach of this Contract, that does not mean that Elevator Video Pitch has waived its right to enforce this Contract. You may not assign or transfer this Contract "
                    "(or your membership or use of our Services) to anyone. However, you agree that Elevator Video Pitch may assign this Contract to a party that buys us in future without your consent. "
                    "There are no third-party beneficiaries to this Contract.\n\n"
                    "You agree that the only way to provide us legal notice is at the registered address provided on our website.",
                style: TextStyle(
                  fontSize: 10,
                  height: 1.5,
                  color: Color(0xFF424242),
                ),
              ),
        
              const SizedBox(height: 20),
              /// 15. Elevator Video Pitch “Dos and Don’ts”
              Text(
                "15. Elevator Video Pitch “Dos and Don’ts”",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Elevator Video Pitch is a professional community. This list of “Dos and Don’ts” limits what you can and cannot do on our Services.\n\n"
                    "15.1  You agree that you will:\n"
                    "15.1.1  Comply with all applicable laws, including, without limitation, privacy laws, intellectual property laws, anti-spam laws, export control laws, laws governing the content shared, and other applicable laws and regulatory requirements.\n"
                    "15.1.2  Provide accurate contact and identity information to us and keep it updated.\n"
                    "15.1.3  Use your real name on your profile and in your elevator video pitch; and\n"
                    "15.1.4  Use all our Services in a professional manner.\n\n"
                    "15.2  You agree that you will not:\n"
                    "15.2.1  Create a false identity on Elevator Video Pitch, misrepresent your identity, create a member profile for anyone other than yourself (a real person), or use or attempt to use someone else’s account.\n"
                    "15.2.2  Develop, support or use software, devices, scripts, robots or other means or processes (such as crawlers, browser plugins and add-ons or any other technology) to scrape or copy the Services.\n"
                    "15.2.3  Override any security feature or bypass or circumvent any access controls or use limits of the Services.\n"
                    "15.2.4  Copy, use, display or distribute any information (including profiles) obtained from the Services, whether directly or through third parties.\n"
                    "15.2.5  Disclose information that you do not have the consent to disclose.\n"
                    "15.2.6  Violate the intellectual property rights of others, including elevator pitches recorded on our site.\n"
                    "15.2.7  Violate the intellectual property or other rights of Elevator Video Pitch, including copying or distributing our elevator pitch videos or other materials.\n"
                    "15.2.8  Post or otherwise share anything that contains malware or any other harmful code.\n"
                    "15.2.9  Reverse engineer, decompile, disassemble, decipher or otherwise attempt to derive the source code for the Site.\n"
                    "15.2.10  Imply or state that you are affiliated with or endorsed by Elevator Video Pitch without consent.\n"
                    "15.2.11  Re-sell or otherwise monetize our Services or related data.\n"
                    "15.2.12  Use bots or other unauthorized automated methods.\n"
                    "15.2.13  Engage in “framing”, “mirroring”, or otherwise simulating the appearance or function of the Services.\n"
                    "15.2.14  Interfere with the operation of, or place an unreasonable load on, the site.\n"
                    "15.2.15  Violate any terms concerning a specific Service.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// 16. Complaints Regarding Content
              Text(
                "16. Complaints Regarding Content",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "We ask that you report content and other information that you believe violates your rights (including intellectual property rights) or otherwise violates this Contract or the law. "
                    "To the extent we can act under the law, we may remove or restrict access to content, features, services, or information, including if we believe that it’s reasonably necessary to avoid harm "
                    "to Elevator Video Pitch or others, violates the law or is reasonably necessary to prevent misuse of our Services.\n\n"
                    "We respect the intellectual property rights of others. We require that information shared by Members be accurate and not in violation of the intellectual property rights or other rights of third parties.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 20),
        
              /// 17. How To Contact Us
              Text(
                "17. How To Contact Us",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B7FD0),
                ),
              ),
              SizedBox(height: 3),
              Text(
                "You can contact us via our email address at info@elevatorvideopitch.com or via our Contact Form or at our address on our website.",
                style: TextStyle(fontSize: 10, height: 1.5, color: Color(0xFF424242)),
              ),
        
              SizedBox(height: 60),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

