import 'dart:convert';

import 'package:ampushare/data/models/doctor/doctors_view_model.dart';
import 'package:ampushare/pages/appointment_booking_page/appointment_booking_form_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppointmentBookingPage extends HookWidget {
  const AppointmentBookingPage({super.key});

  Future<List<DoctorsViewModel>> fetchDoctors() async {
    Dio dio = await DioHelper.getDio();
    final response = await dio.get('/api/booking/doctors');
    return doctorsViewModelFromJson(jsonEncode(response.data));
  }

  @override
  Widget build(BuildContext context) {
    final doctorsFuture = useMemoized(fetchDoctors);

    final snapshot = useFuture(doctorsFuture);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book an Appointment'),
      ),
      body: snapshot.connectionState == ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : snapshot.hasError
              ? Center(child: Text('${snapshot.error}'))
              : ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var doctor = snapshot.data?[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${doctor?.image}'),
                      ),
                      title: Text('${doctor?.firstName} ${doctor?.lastName}'),
                      subtitle: Text(doctor?.speciality ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppointmentBookingFormPage(doctor: doctor!),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
