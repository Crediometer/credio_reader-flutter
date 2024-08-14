import 'dart:developer';

import 'package:credio_reader/models/reader_transaction_request.dart';
import 'package:credio_reader/utils/helper.dart';
import 'package:dio/dio.dart';

String cardBaseUrl = "https://www.reader.crediometer.com";

class CredioTransformer extends DefaultTransformer {
  CredioTransformer() : super(jsonDecodeCallback: parseJson);
}

class HttpService {
  final collectionUrl;
  late Dio cardHttp;
  late CancelToken cancelToken;

  HttpService({required this.collectionUrl}) {
    cancelToken = CancelToken();

    // Create a Dio instance for card transactions with a different cardBaseUrl
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
        print({
          "url": "${opts.baseUrl}${opts.path}",
          "body": opts.data,
          "params": opts.queryParameters,
        });

        // if (dioInterceptors == http)
        //   opts.headers["Authorization"] = "Bearer ${tokens.accessToken}";
        // log("auth :${tokens.accessToken}");

        return handler.next(opts);
      }, onError: (DioError e, handler) async {
        print({
          "statusCode": e.response?.statusCode,
          "statusMessage": e.response?.statusMessage,
          "data": e.response?.data ?? {"message": e.error ?? e}
        });
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          // return _navigationService.navigateToArg(
          //   CredioRoutes.loginArg,
          //   true,
          // );
        }
        if (e.response?.statusCode == 404) {
          DioError response = e;
          response.response?.statusMessage =
              "Service is presently unavailable at the moment";
          return handler.next(response);
        }
        if ((e.response?.statusCode ?? 500) >= 500) {
          DioError response = e;
          response.response?.statusMessage =
              "Service is presently unavailable at the moment";
          return handler.next(response);
        }
        if (e.response?.statusCode == 400) {
          DioError response = e;
          response.response?.statusMessage =
              "Request sent is badly formatted, please try again.";
          return handler.next(response);
        }

        DioError response = e;
        response.response?.statusMessage =
            "Service is temporary unavailable, please try again.";
        return handler.next(response);
      }, onResponse: (Response res, handler) {
        log({
          "data": res.data,
          "statusCode": res.statusCode,
          "statusMessage": res.statusMessage,
        }.toString());

        return handler.next(res);
      }),
    );
  }

  void cancelReqs() {
    cancelToken.cancel("Request has been cancelled");
  }
}

class CardHttpService extends HttpService {
  CardHttpService()
      : super(
          collectionUrl: "",
        );

  Future<Map<String, dynamic>> merchantCardTopUp(
    ReaderTransactionRequest data,
  ) async {
    try {
      final req = await cardHttp.post(
        "/easyPayment",
        data: data.toJson(),
      );
      return req.data;
    } on DioError catch (e) {
      throw {
        "statusCode": e.response!.statusCode,
        "data": e.response?.data ?? {"message": e.error ?? e}
      };
    }
  }
}
