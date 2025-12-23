import 'package:flutter/material.dart';

import '../widgets/applied_jobs_card.dart';

class AppliedJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        title: Text('Applied Jobs'),
      ),
      body: ListView(
        children: [
          AppliedJobCard(
            jobLogo: "assets/images/applied_jobs_sample_logo.png",
            title: 'Software Engineers',
            description:
                'Lorem ipsum dolor sit amet consectetur. Tellus laoreet vel maec enas in. Aliq uet aliquet a diam mi luctus quis masdf',
          ),
          AppliedJobCard(
            jobLogo: "assets/images/applied_jobs_sample_logo.png",
            title: 'Software Engineer',
            description:
                'Lorem ipsum dolor sit amet consectetur. Tellus laoreet vel maec enas in. Aliq uet aliquet a diam mi luctus quis masdf',
          ),
          AppliedJobCard(
            jobLogo: "assets/images/applied_jobs_sample_logo.png",
            title: 'Software Engineer',
            description:
                'Lorem ipsum dolor sit amet consectetur. Tellus laoreet vel maec enas in. Aliq uet aliquet a diam mi luctus quis masdfghgj',
          ),
          AppliedJobCard(
            jobLogo: "assets/images/applied_jobs_sample_logo.png",
            title: 'Software Engineer',
            description:
                'Lorem ipsum dolor sit amet consectetur. Tellus laoreet vel maec enas in. Aliq uet aliquet a diam mi luctus quis masdf',
          ),
          AppliedJobCard(
            jobLogo: "assets/images/applied_jobs_sample_logo.png",
            title: 'Software Engineer',
            description:
                'Lorem ipsum dolor sit amet consectetur. Tellus laoreet vel maec enas in. Aliq uet aliquet a diam mi luctus quis masdf',
          ),
        ],
      ),
    );
  }
}
