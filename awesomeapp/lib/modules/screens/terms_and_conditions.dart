import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/api_constants.dart';
import '../../core/serviceLocator.dart';
import '../auth/services/auth_provider.dart';

// class TermsAndConditions extends StatefulWidget {
//   static const id = 'TermsAndConditions';
//
//   const TermsAndConditions({Key? key}) : super(key: key);
//
//   @override
//   State<TermsAndConditions> createState() => _TermsAndConditionsState();
// }
//
// class _TermsAndConditionsState extends State<TermsAndConditions> {
//   String? _htmlContent;
//   bool _isLoading = true;
//   String? _error;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTerms();
//   }
//
//   Future<void> _fetchTerms() async {
//     try {
//       final dio = Dio();
//       final token =
//       await serviceLocator<AuthenticationProvider>().authToken();
//       final url = ApiConstants.baseUrl + ApiConstants.termsAndConditions;
//
//       final response = await dio.get(url,
//         options: Options(
//             headers: {
//               "Authorization": "Bearer $token,
//             }),
//       );
//
//       if (response.statusCode == 200 && response.data['success'] == true) {
//         final content = response.data['data']['termsAndConditions']['content'];
//         setState(() {
//           _htmlContent = content;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _error =
//               response.data['message'] ?? "Failed to load Terms And Conditions";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         _error = "Something went wrong";
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16.0.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20.0,),
//             SafeArea(child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: SvgPicture.asset(
//                     'assets/backward_arrow_head.svg', height: 20.h,
//                     width: 12.w,
//                   ),
//                 ),
//                 SizedBox(width: 50.w,),
//                 Text(
//                   "Terms And Conditions",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: ColorConstants.primaryColor,
//                     fontSize: 20.sp,
//                   ),
//                 )
//               ],
//             ),
//             ),
//             SizedBox(height: 20.h,),
//             Expanded(
//                 child: _isLoading
//                     ? Center(child: CircularProgressIndicator())
//                     :_error != null
//                     ? Center(child: Text(_error!))
//                     : SingleChildScrollView(
//                       child: Html(data: _htmlContent),
//                 )
//             )
//           ],
//         ),
//       ),
//     )
//   }
// }

class TermsAndConditions extends StatefulWidget {
  static const id = 'TermsAndConditions';

  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  String? _htmlContent;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTerms();
  }

  Future<void> _fetchTerms() async {
    try {
      final dio = Dio();
      final token =
      await serviceLocator<AuthenticationProvider>().authToken();
      final url = ApiConstants.baseUrl + ApiConstants.termsAndConditions;

      final response = await dio.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final content = response.data['data']['termsAndConditions']['content'];
        setState(() {
          _htmlContent = content;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error =
              response.data['message'] ?? "Failed to load Terms & Conditions.";
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _error = "Something went wrong. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/backward_arrow_head.svg',
                      height: 23.h,
                      width: 25.w,
                    ),
                  ),
                  SizedBox(width: 50.w),
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                      fontSize: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!))
                  : SingleChildScrollView(
                child: Html(data: _htmlContent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}