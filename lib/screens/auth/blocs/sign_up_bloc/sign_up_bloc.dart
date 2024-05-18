import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:menu_app/repositories/models/user.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    // Definirea handler-ului pentru evenimentul SignUpRequired
    on<SignUpRequired>(_onSignUpRequired);
  }

  Future<void> _onSignUpRequired(
    SignUpRequired event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpProcess());

    try {
      print('SignUpRequired event received with user: ${event.email}');
      final response = await http.post(
        Uri.parse('http://menuipdp.000webhostapp.com/login.php'),
        body: {
          'email': event.email,
          'firstName': event.firstName,
          'lastName': event.lastName,
          'password': event.password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          print('User successfully signed up');
          emit(SignUpSuccess());
        } else {
          print('Sign up failed: ${responseData['message']}');
          emit(SignUpFailure(error: responseData['message']));
        }
      } else {
        print('Server error');
        emit(const SignUpFailure(error: 'Server error'));
      }
    } catch (e) {
      print('Network error: $e');
      emit(const SignUpFailure(error: 'Network error'));
    }
  }
}
