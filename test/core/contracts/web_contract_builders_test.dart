import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:giveandtake/core/contracts/web/job_application_contract.dart';
import 'package:giveandtake/core/contracts/web/job_contract.dart';
import 'package:giveandtake/core/contracts/web/profile_contract.dart';
import 'package:giveandtake/core/contracts/web/recruiter_company_contract.dart';
import 'package:giveandtake/core/contracts/web/resume_contract.dart';
import 'package:giveandtake/features/job_listing/data/models/job_application_request.dart';

void main() {
  group('ResumePayloadBuilder', () {
    late Directory tempDirectory;
    late File photo;
    late File banner;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'resume_payload_test',
      );
      photo = File('${tempDirectory.path}${Platform.pathSeparator}photo.jpg');
      banner = File('${tempDirectory.path}${Platform.pathSeparator}banner.jpg');
      await photo.writeAsBytes(const [1, 2, 3]);
      await banner.writeAsBytes(const [4, 5, 6]);
    });

    tearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('buildCreate mirrors web multipart keys', () {
      final payload = ResumePayloadBuilder.buildCreate(
        CandidateResumeCreateInput(
          userId: 'user-1',
          type: 'candidate',
          firstName: 'Jane',
          lastName: 'Doe',
          email: 'jane@example.com',
          title: 'Product Designer',
          country: 'Bangladesh',
          city: 'Dhaka',
          zip: ' 1207 ',
          aboutUs: '<p>Hello</p>',
          immediatelyAvailable: true,
          skills: const ['Figma', 'Flutter'],
          certifications: const ['Google UX'],
          languages: const ['English'],
          socialLinks: const [
            ResumeSocialLinkInput(
              label: 'LinkedIn',
              url: 'https://linkedin.com/in/jane',
            ),
          ],
          experiences: const [
            CandidateExperienceInput(
              company: 'Acme',
              position: 'Designer',
              country: 'Bangladesh',
              city: 'Dhaka',
              zip: '1207',
              jobDescription: 'Designed flows',
              jobCategory: 'Design',
              startDate: '01/2024',
              currentlyWorking: true,
            ),
          ],
          educationList: const [
            CandidateEducationInput(
              university: 'DU',
              degree: 'BSc',
              fieldOfStudy: 'CSE',
              country: 'Bangladesh',
              city: 'Dhaka',
              startDate: '01/2020',
              graduationDate: '12/2023',
            ),
          ],
          awardsAndHonors: const [
            CandidateAwardInput(
              title: 'Winner',
              programeName: 'Hackathon',
              programeDate: '02/2024',
              description: 'Top team',
            ),
          ],
          photo: photo,
          banner: banner,
        ),
      );

      final resume =
          jsonDecode(payload.fields['resume']!) as Map<String, dynamic>;
      final experiences =
          jsonDecode(payload.fields['experiences']!) as List<dynamic>;
      final education =
          jsonDecode(payload.fields['educationList']!) as List<dynamic>;
      final honors =
          jsonDecode(payload.fields['awardsAndHonors']!) as List<dynamic>;

      expect(payload.fields['userId'], 'user-1');
      expect(resume['aboutUs'], '<p>Hello</p>');
      expect(resume['zip'], '1207');
      expect(resume['position'], isNull);
      expect((resume['sLink'] as List<dynamic>).single['label'], 'LinkedIn');
      expect(experiences.single['position'], 'Designer');
      expect(experiences.single['currentlyWorking'], isTrue);
      expect(experiences.single.containsKey('endDate'), isFalse);
      expect(
        experiences.single['startDate'],
        '2024-01-01T00:00:00.000Z',
      );
      expect(
        education.single['graduationDate'],
        '2023-12-01T00:00:00.000Z',
      );
      expect(
        honors.single['programeDate'],
        '2024-02-01T00:00:00.000Z',
      );
      expect(payload.files['photo']!.single.path, photo.path);
      expect(payload.files['banner']!.single.path, banner.path);
    });

    test('buildUpdate preserves ids and web mutation markers', () {
      final payload = ResumePayloadBuilder.buildUpdate(
        CandidateResumeUpdateInput(
          resumeId: 'resume-1',
          userId: 'user-1',
          type: 'candidate',
          firstName: 'Jane',
          lastName: 'Doe',
          email: 'jane@example.com',
          title: 'Product Designer',
          country: 'Bangladesh',
          city: 'Dhaka',
          zip: '1207',
          aboutUs: 'Updated',
          immediatelyAvailable: false,
          skills: const ['Figma'],
          certifications: const ['Google UX'],
          languages: const ['English'],
          socialLinks: const [
            ResumeSocialLinkInput(
              id: 'social-1',
              mutation: WebMutationType.update,
              label: 'LinkedIn',
              url: 'https://linkedin.com/in/jane',
            ),
          ],
          experiences: const [
            CandidateExperienceInput(
              id: 'exp-1',
              mutation: WebMutationType.update,
              company: 'Acme',
              position: 'Lead Designer',
              country: 'Bangladesh',
              city: 'Dhaka',
              zip: '1207',
              jobDescription: 'Updated',
              jobCategory: 'Design',
              startDate: '01/2024',
              endDate: '03/2026',
            ),
          ],
          educationList: const [
            CandidateEducationInput(
              id: 'edu-1',
              mutation: WebMutationType.delete,
              university: 'DU',
              degree: 'BSc',
              fieldOfStudy: 'CSE',
              country: 'Bangladesh',
              city: 'Dhaka',
            ),
          ],
          awardsAndHonors: const [
            CandidateAwardInput(
              id: 'award-1',
              mutation: WebMutationType.update,
              title: 'Winner',
              programeName: 'Hackathon',
              programeDate: '02/2024',
              description: 'Top team',
            ),
          ],
        ),
      );

      final resume =
          jsonDecode(payload.fields['resume']!) as Map<String, dynamic>;
      final experiences =
          jsonDecode(payload.fields['experiences']!) as List<dynamic>;
      final education =
          jsonDecode(payload.fields['educationList']!) as List<dynamic>;
      final honors =
          jsonDecode(payload.fields['awardsAndHonors']!) as List<dynamic>;

      expect(resume['_id'], 'resume-1');
      expect(resume['type'], 'update');
      expect(resume['zipCode'], '1207');
      expect((resume['sLink'] as List<dynamic>).single['_id'], 'social-1');
      expect((resume['sLink'] as List<dynamic>).single['type'], 'update');
      expect(experiences.single['_id'], 'exp-1');
      expect(experiences.single['type'], 'update');
      expect(experiences.single['endDate'], '2026-03-01T00:00:00.000Z');
      expect(education.single['_id'], 'edu-1');
      expect(education.single['type'], 'delete');
      expect(honors.single['_id'], 'award-1');
      expect(honors.single['type'], 'update');
    });
  });

  group('Recruiter and company payloads', () {
    late Directory tempDirectory;
    late File photo;
    late File banner;
    late File logo;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'company_payload_test',
      );
      photo = File('${tempDirectory.path}${Platform.pathSeparator}photo.jpg');
      banner = File('${tempDirectory.path}${Platform.pathSeparator}banner.jpg');
      logo = File('${tempDirectory.path}${Platform.pathSeparator}logo.jpg');
      await photo.writeAsBytes(const [1]);
      await banner.writeAsBytes(const [2]);
      await logo.writeAsBytes(const [3]);
    });

    tearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('RecruiterPayloadBuilder uses exact multipart keys', () {
      final payload = RecruiterPayloadBuilder.buildCreate(
        RecruiterAccountInput(
          userId: 'user-1',
          firstName: 'Jane',
          sureName: 'Doe',
          title: 'Recruiter',
          bio: 'Bio',
          country: 'Bangladesh',
          city: 'Dhaka',
          zipCode: '1207',
          emailAddress: 'jane@example.com',
          phoneNumber: '123',
          companyId: 'company-1',
          socialLinks: const [
            WebSocialLinkInput(
              label: 'LinkedIn',
              url: 'https://linkedin.com/in/jane',
            ),
          ],
          photo: photo,
          banner: banner,
        ),
      );

      expect(payload.fields['sureName'], 'Doe');
      expect(payload.fields['emailAddress'], 'jane@example.com');
      expect(payload.fields['companyId'], 'company-1');
      expect(payload.fields['sLink[0][label]'], 'LinkedIn');
      expect(
        payload.fields['sLink[0][url]'],
        'https://linkedin.com/in/jane',
      );
      expect(payload.files['photo']!.single.path, photo.path);
      expect(payload.files['banner']!.single.path, banner.path);
    });

    test('CompanyPayloadBuilder serializes arrays with web keys', () {
      final payload = CompanyPayloadBuilder.build(
        CompanyAccountInput(
          userId: 'user-1',
          cname: 'Acme',
          cemail: 'hello@acme.com',
          aboutUs: 'About company',
          industry: 'Technology',
          country: 'Bangladesh',
          city: 'Dhaka',
          zipcode: '1212',
          service: const ['Design', 'Engineering'],
          employeesId: const ['1-10', '11-50'],
          awardsAndHonors: const [
            CompanyHonorInput(
              title: 'Winner',
              programeName: 'Startup Awards',
              programeDate: '03/2026',
              description: 'Best startup',
            ),
          ],
          socialLinks: const [
            WebSocialLinkInput(
              label: 'Website',
              url: 'https://acme.com',
            ),
          ],
          clogo: logo,
          banner: banner,
        ),
      );

      expect(payload.fields['cname'], 'Acme');
      expect(payload.fields['zipcode'], '1212');
      expect(
        jsonDecode(payload.fields['service']!) as List<dynamic>,
        ['Design', 'Engineering'],
      );
      expect(
        jsonDecode(payload.fields['employeesId']!) as List<dynamic>,
        ['1-10', '11-50'],
      );
      final honors =
          jsonDecode(payload.fields['AwardsAndHonors']!) as List<dynamic>;
      expect(honors.single['programeDate'], '2026-03-01T00:00:00.000Z');
      final social = jsonDecode(payload.fields['sLink']!) as List<dynamic>;
      expect(social.single['url'], 'https://acme.com');
      expect(payload.files['clogo']!.single.path, logo.path);
      expect(payload.files['banner']!.single.path, banner.path);
    });
  });

  group('Job and profile payloads', () {
    test('JobPayloadBuilder mirrors web schema and expiry calculation', () {
      final payload = JobPayloadBuilder.build(
        const JobContractInput(
          userId: 'user-1',
          companyId: 'company-1',
          title: 'Flutter Engineer',
          description: 'Build mobile apps',
          location: 'Dhaka',
          vacancy: 2,
          experience: '3+ years',
          jobCategoryId: 'cat-1',
          name: 'Acme',
          role: 'Engineer',
          compensation: 'Negotiable',
          employementType: 'full-time',
          publishDate: '2026-04-08T00:00:00.000Z',
          careerStage: 'Mid Level',
          locationType: 'On-site',
          expirationDateDays: '45 days',
          websiteUrl: 'https://acme.com/careers',
          applicationRequirement: [
            JobRequirementInput(
              requirement: JobPayloadBuilder.validVisaLabel,
              status: 'required',
            ),
            JobRequirementInput(
              requirement: 'Resume/CV',
              status: '',
            ),
          ],
          customQuestion: [
            JobQuestionInput(question: 'Why you?'),
            JobQuestionInput(question: ''),
          ],
        ),
      );

      expect(payload['companyId'], 'company-1');
      expect(payload['employement_Type'], 'full-time');
      expect(payload['career_Stage'], 'Mid Level');
      expect(payload['location_Type'], 'On-site');
      expect(payload['website_Url'], 'https://acme.com/careers');
      expect(payload['expirationDate'], '45');
      expect(payload['deadline'], '2026-05-23T00:00:00.000Z');
      expect(payload['expiryDate'], '2026-05-23T00:00:00.000Z');
      expect(
        payload['applicationRequirement'],
        [
          {
            'requirement': JobPayloadBuilder.validVisaLabel,
            'status': 'required',
          },
        ],
      );
      expect(
        payload['customQuestion'],
        [
          {'question': 'Why you?'},
        ],
      );
    });

    test('ProfilePayloadBuilder combines names like web app', () {
      expect(
        ProfilePayloadBuilder.buildUpdate(
          const PersonalInfoInput(
            firstName: 'Jane',
            surname: 'Doe',
            address: ' Dhaka ',
          ),
        ),
        {
          'name': 'Jane Doe',
          'address': 'Dhaka',
        },
      );
    });
  });

  group('Job application payloads', () {
    late Directory tempDirectory;
    late File resumeFile;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp('job_app_test');
      resumeFile = File(
        '${tempDirectory.path}${Platform.pathSeparator}resume.pdf',
      );
      await resumeFile.writeAsBytes(const [10, 20, 30]);
    });

    tearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('resume upload uses /resume contract keys', () {
      final payload = JobApplicationPayloadBuilder.buildResumeUpload(
        ResumeUploadInput(
          userId: 'user-1',
          file: resumeFile,
        ),
      );

      expect(payload.fields['userId'], 'user-1');
      expect(payload.files['resumes']!.single.path, resumeFile.path);
    });

    test('JobApplicationRequest emits web parity json', () {
      final json = JobApplicationRequest(
        jobId: 'job-1',
        userId: 'user-1',
        resumeId: 'resume-1',
        hasValidVisa: true,
        answer: const [
          {'question': 'Why you?', 'ans': 'Because.'},
        ],
      ).toJson();

      expect(
        json,
        {
          'jobId': 'job-1',
          'userId': 'user-1',
          'resumeId': 'resume-1',
          'answer': const [
            {'question': 'Why you?', 'ans': 'Because.'},
          ],
          'hasValidVisa': true,
        },
      );
    });
  });
}
