// import 'package:bloc/bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:oneappcounter/services/networking_service.dart';

// // Define the states
// abstract class NetworkConnectivityState {}

// class NetworkConnectivityInitial extends NetworkConnectivityState {}

// class NetworkConnected extends NetworkConnectivityState {}

// class NetworkDisconnected extends NetworkConnectivityState {}

// // Define the Cubit
// class NetworkConnectivityCubit extends HydratedCubit<NetworkConnectivityState> {
//   final NetworkingService networkingService;

//   NetworkConnectivityCubit(this.networkingService) : super(NetworkConnectivityInitial());

//   Future<void> checkConnectivity() async {
//     emit(NetworkConnectivityInitial());
//     try {
//       bool isConnected = await networkingService.checkInternetConnection();
//       if (isConnected) {
//         emit(NetworkConnected());
//       } else {
//         emit(NetworkDisconnected());
//       }
//     } catch (_) {
//       emit(NetworkDisconnected());
//     }
//   }

//   @override
//   NetworkConnectivityState fromJson(Map<String, dynamic> json) {
//     return NetworkConnectivityInitial();
//   }

//   @override
//   Map<String, dynamic> toJson(NetworkConnectivityState state) {
//     return {};
//   }
// }

import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class NetworkingCubit extends HydratedCubit<NetworkingState> {
  final Dio _dio = Dio();

  NetworkingCubit()
      : super(NetworkingState(
          domainUrl: 'https://www.oneapp.life',
          apiDomainUrl: 'https://www.oneapp.life/api',
        ));

  void setDomainUrl(String url) {
    final updatedState =
        state.copyWith(domainUrl: url, apiDomainUrl: '$url/api');
    emit(updatedState);
  }

  void setAccessToken(String token) {
    emit(state.copyWith(accessToken: token));
  }

  @override
  NetworkingState fromJson(Map<String, dynamic> json) {
    return NetworkingState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(NetworkingState state) {
    return state.toJson();
  }

  Future<bool> setSavedValues() async {
    // If the domain URL is already set, assume the values are already initialized
    if (state.domainUrl != null) {
      return true;
    }

    // Set the values to default if not already set
    emit(state.copyWith(
      domainUrl: 'https://www.oneapp.life',
      apiDomainUrl: 'https://www.oneapp.life/api',
    ));

    // Check if values are saved correctly by HydratedBloc
    return state.domainUrl != null && state.apiDomainUrl != null;
  }

  Future<Response?> postHttp({
    required String path,
    required Map<String, String> data,
  }) async {
    try {
      final String url = '${state.apiDomainUrl}/$path';

      final Response response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${state.accessToken}',
          },
        ),
      );

      return response;
    } catch (e) {
      // Handle the error or log it
      // print('POST request failed: $e');
      return null;
    }
  }
}

class NetworkingState {
  final String? domainUrl;
  final String? apiDomainUrl;
  final String? accessToken;

  NetworkingState({this.domainUrl, this.apiDomainUrl, this.accessToken});

  NetworkingState copyWith({
    String? domainUrl,
    String? apiDomainUrl,
    String? accessToken,
  }) {
    return NetworkingState(
      domainUrl: domainUrl ?? this.domainUrl,
      apiDomainUrl: apiDomainUrl ?? this.apiDomainUrl,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  factory NetworkingState.fromJson(Map<String, dynamic> json) {
    return NetworkingState(
      domainUrl: json['domainUrl'] as String?,
      apiDomainUrl: json['apiDomainUrl'] as String?,
      accessToken: json['accessToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domainUrl': domainUrl,
      'apiDomainUrl': apiDomainUrl,
      'accessToken': accessToken,
    };
  }
}
