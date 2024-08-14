import 'package:credio_reader/models/reader_transaction_request.dart';
import 'package:credio_reader/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

String cardBaseUrl = "https://www.reader.crediometer.com";

class CredioTransformer extends DefaultTransformer {
  CredioTransformer() : super(jsonDecodeCallback: parseJson);
}

class HttpService {
  late Dio cardHttp;
  late CancelToken cancelToken;

  HttpService() {
    cancelToken = CancelToken();

    cardHttp = Dio(
      BaseOptions(
        baseUrl: cardBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    _configureInterceptors(cardHttp);

    cardHttp.transformer = CredioTransformer();
  }

  void _configureInterceptors(Dio dioInterceptors) {
    dioInterceptors.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions opts, handler) async {
        return handler.next(opts);
      }, onError: (DioException e, handler) async {
        if (kDebugMode) {
          print({
            "statusCode": e.response?.statusCode,
            "statusMessage": e.response?.statusMessage,
            "data": e.response?.data ?? {"message": e.error ?? e}
          });
        }
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {}
        if (e.response?.statusCode == 404) {
          DioException response = e;
          response.response?.statusMessage =
              "Service is presently unavailable at the moment";
          return handler.next(response);
        }
        if ((e.response?.statusCode ?? 500) >= 500) {
          DioException response = e;
          response.response?.statusMessage =
              "Service is presently unavailable at the moment";
          return handler.next(response);
        }
        if (e.response?.statusCode == 400) {
          DioException response = e;
          response.response?.statusMessage =
              "Request sent is badly formatted, please try again.";
          return handler.next(response);
        }

        DioException response = e;
        response.response?.statusMessage =
            "Service is temporary unavailable, please try again.";
        return handler.next(response);
      }, onResponse: (Response res, handler) {
        return handler.next(res);
      }),
    );
  }

  void cancelReqs() {
    cancelToken.cancel("Request has been cancelled");
  }
}

class CardHttpService extends HttpService {
  CardHttpService();

  Future<Map<String, dynamic>> merchantCardTopUp(
    ReaderTransactionRequest data,
  ) async {
    try {
      final req = await cardHttp.post(
        "/easyPayment",
        data: data.toJson(),
      );
      return req.data;
    } on DioException catch (e) {
      throw {
        "statusCode": e.response!.statusCode,
        "data": e.response?.data ?? {"message": e.error ?? e}
      };
    }
  }
}
