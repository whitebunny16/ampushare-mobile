import 'package:ampushare/data/models/doctor/doctors_view_model.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/models/appointment/khalti_initiate_response_model.dart';
import 'appointment_payment_page.dart';

class AppointmentBookingFormPage extends HookWidget {
  final DoctorsViewModel doctor;

  const AppointmentBookingFormPage({super.key, required this.doctor});

  Future<KhaltiInitiateResponseModel> initiateKhalti({required int appointmentId}) async {
    Dio dio = await DioHelper.getDio();
    final response = await dio.get('/api/booking/appointment/$appointmentId/initiate-khalti');
    return KhaltiInitiateResponseModel.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    final dateController = useTextEditingController();
    final timeController = useTextEditingController();
    final remarkController = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());

    void bookAppointment() async {
      if (formKey.currentState!.validate()) {
        Dio dio = await DioHelper.getDio();

        DateTime date = DateTime.parse(dateController.text);

        String appointmentDate =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        String timeString =
        timeController.text.substring(10, timeController.text.length - 1);

        try {
          final response = await dio.post(
            '/api/booking/appointments',
            data: {
              "date": appointmentDate,
              "time": timeString,
              "remark": remarkController.text,
              "doctor": doctor.id
            },
          );

          if (response.statusCode == 201) {
            KhaltiInitiateResponseModel initiateResponse = await initiateKhalti(appointmentId: response.data['id']);
            if (context.mounted) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => KhaltiPage(
                    pidx: initiateResponse.pidx,
                  )));
            }

            Fluttertoast.showToast(
                msg: "Appointment booked successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: "Error booking appointment",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Error booking appointment",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Book an Appointment with ${doctor.firstName} ${doctor.lastName}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                        doctor.image),),
                Text(
                  'Doctor: ${doctor.firstName} ${doctor.lastName}',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Speciality: ${doctor.speciality}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Email: ${doctor.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Phone: ${doctor.phoneNumber}',
                  style: const TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    dateController.text = date.toString();
                  },
                ),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                  onTap: () async {
                    var time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    timeController.text = time.toString();
                  },
                ),
                TextFormField(
                  controller: remarkController,
                  decoration: const InputDecoration(
                    labelText: 'Remark',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a remark';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: bookAppointment,
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
