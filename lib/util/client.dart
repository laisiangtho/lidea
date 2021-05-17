part of '../engine.dart';

class UtilClient {
  // static Future<dynamic> request(String url) => null;
  // static Future<dynamic> get(Uri uri, {Map<String, String> headers}) => null;
  // // static Future<dynamic> put(Uri uri, {Map<String, String> headers}) => null;
  // static Future<dynamic> patch(Uri uri, {Map<String, String> headers, Object body}) async {
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest req = await httpClient.patchUrl(uri);
  //   print(req);
  //   return null;
  // }
  late Uri uri;

  /// `url` String, Uri...
  UtilClient(dynamic url) {
    this.uri=this.urlParse(url);
  }

  Uri urlParse (dynamic url) => (url is Uri)?url:Uri.parse(url);
  HttpClient get client => new HttpClient();


  /// ` await UtilClient(item).get<Uint8List>().catchError((e) => null);`
  Future<T> get<T>({Map<String, Object>? headers, String? body}) => open<T>(
    this.uri,
    method:'GET',
    headers: headers, 
    body: body
  );
  
  Future<T> put<T>({Map<String, Object>? headers, String? body}) => open<T>(
    this.uri,
    method:'PUT',
    headers: headers, 
    body: body
  );

  Future<T> patch<T>({Map<String, Object>? headers, String? body}) => open<T>(
    this.uri,
    method:'PATCH',
    headers: headers, 
    body: body
  );

  /// Request data over HTTP `...errorHandler(?).then().catchError();`
  Future<T> open<T>(Uri uri,{String? method, Map<String, Object>? headers, String? body}) async {
    try {
      HttpClient httpClient = client;
      HttpClientRequest req = await httpClient.openUrl((method??'get').toUpperCase(), uri);

      if (headers != null) {
        // request.headers.set('content-type', 'application/json');
        // request.headers.add(name, value)
        headers.forEach((key, value) => req.headers.set(key, value));
      }

      if (body != null) {
        // req.add(utf8.encode(json.encode(body)));
        req.write(body);
      }

      HttpClientResponse res = await req.close();
      httpClient.close();

      // Check the res.statusCode
      if (res.statusCode == 200){
        if (T == String){
          return await _responseToString(res) as T;
        } else if (T == Uint8List){
          return await _responseToBytes(res) as T;
        } else {
          return res as T;
        }
      } else {
        print(res.statusCode);
        return Future.error("Failed to load", StackTrace.fromString("code: ${res.statusCode}"));
      }

      // return await new HttpClient().openUrl((method??'get').toUpperCase(), uri).then(
      //   (HttpClientRequest request) {
      // ).then((HttpClientResponse response) async{
      // });
      
    } on PlatformException catch (e) {
      return Future.error(e.message!);
    } on TimeoutException catch (e) {
      return Future.error(e.message!);
    } on SocketException catch (e) {
      if (e.port == null || e.address == null){
        return Future.error("No Internet", StackTrace.fromString(e.message));
      } else {
        return Future.error("Failed host lookup", StackTrace.fromString(uri.toString()));
      }
    } on Error catch (e) {
      return Future.error("Error", e.stackTrace);
    } catch (e) {
      return Future.error(e);
    }
  }
}

Future<String> _responseToString(HttpClientResponse response) async{
  return await response.transform(utf8.decoder).join();
  // final completer = Completer<String>();
  // final data = StringBuffer();
  // this.response.transform(utf8.decoder).listen((e) {
  //   data.write(e);
  // }, onDone: () => completer.complete(data.toString()));
  // return completer.future;
}

Future<Uint8List> _responseToBytes (HttpClientResponse response) async => await consolidateHttpClientResponseBytes(response);

/*
  // Future<List<int>> download(String url) async {
  //   final data = await this.requestIO(url);
  //   // return await consolidateHttpClientResponseBytes(data);
  // }

  // Future<String> download(String url) async {
  //   final data = await this.requestIO(url);
  // utf8.encode("Some data");
  //   return await data.transform(utf8.decoder).join();
  // }
  //  String url =
  // 'https://pae.ipportalegre.pt/testes2/wsjson/api/app/ws-authenticate';
  //   Map<String, Object> map = {
  //       'data': {'apikey': '12345678901234567890'},
  //   };

class UtilClient {
  /// Request data over HTTP `...errorHandler(?).then().catchError();`
  static Future<http.Response> errorHandler(Future<http.Response> a) async {
    try {
      http.Response response = await a;

      if (response.statusCode == 200){
        return response;
      } else {
        return Future.error("Failed to load, code: ${response?.statusCode}");
      }
    } catch (e) {
      return Future.error("No Internet", StackTrace.fromString(e.toString()));
    }
  }

  // Future<HttpClientResponse> requestIO(String url,{Map<String, String> headers}) async {
  //   final client = new HttpClient();
  //   final request = await client.getUrl(Uri.parse(url));
  //   // final request = await client.get('api.github.com', 443, '/gists/$id');
  //   request.headers.set('name', headers);
  //   final response = await request.close();
  //   // if (response.statusCode != 200) throw "Error on initializing data";
  //   if (response.statusCode != 200) return Future.error("Error on initializing data");
  //   return response;
  // }

  /// get
  // static Future<http.Response> get(Uri uri, {Map<String, String> headers}) async => await http.get(uri, headers: headers);
  static Future<http.Response> get(Uri uri, {Map<String, String> headers}) {
    // return await UtilClient.errorHandler(http.get(uri, headers: headers)).catchError((error, stackTrace) => null);
      return http.get(uri, headers: headers).catchError((e) {
        throw Future.error("No Internet");
      });
  }

  /// patch
  static Future<http.Response> patch(Uri uri, {Map<String, String> headers, Object body}) async {
    return await UtilClient.errorHandler(http.patch(uri,headers: headers,body: body)).catchError((error, stackTrace) => null);
    // return await http.patch(uri,headers: headers,body: body);
  }

  static Future<String> request(String url) async {
    return await UtilClient.get(Uri.parse(url)).then((response)=>response.body).catchError((error, stackTrace) => null);
  }

  // Future<String> requestString(String url) async {
  //   // return await UtilClient.get(Uri.parse(url)).then((response)=>response.body).catchError((error, stackTrace) => null);
  //   return await UtilClient.get(Uri.parse(url)).then((response)=>response.body);
  // }

  // await consolidateHttpClientResponseBytes(data);
  // await data.transform(utf8.decoder).join();
  // Future<List<int>> requestByte(String url) async {
  //   // return await UtilClient.get(Uri.parse(url)).then((response)=>response.bodyBytes).catchError((error, stackTrace) => null);
  //   return await UtilClient.get(Uri.parse(url)).then((response)=>response.bodyBytes);
  // }
}
*/