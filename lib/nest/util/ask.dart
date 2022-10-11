part of lidea.nest;

class AskNest {
  // static Future<dynamic> request(String url) => null;
  // static Future<dynamic> get(Uri uri, {Map<String, String> headers}) => null;
  // // static Future<dynamic> put(Uri uri, {Map<String, String> headers}) => null;
  // static Future<dynamic> patch(Uri uri, {Map<String, String> headers, Object body}) async {
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest req = await httpClient.patchUrl(uri);
  //   debugPrint(req);
  //   return null;
  // }
  late Uri uri;

  /// `url` String, Uri...
  AskNest(dynamic url) {
    uri = urlParse(url);
  }

  Uri urlParse(dynamic url) => (url is Uri) ? url : Uri.parse(url);
  HttpClient get client => HttpClient();

  /// ` await AskNest(item).get<Uint8List>().catchError((e) => null);`
  Future<T> get<T>({Map<String, Object>? headers, String? body}) => open<T>(
        uri,
        method: 'GET',
        headers: headers,
        body: body,
      );

  Future<T> put<T>({Map<String, Object>? headers, String? body}) => open<T>(
        uri,
        method: 'PUT',
        headers: headers,
        body: body,
      );

  Future<T> patch<T>({Map<String, Object>? headers, String? body}) => open<T>(
        uri,
        method: 'PATCH',
        headers: headers,
        body: body,
      );

  Future<T> post<T>({Map<String, Object>? headers, String? body}) => open<T>(
        uri,
        method: 'POST',
        headers: headers,
        body: body,
      );

  /// Request data over HTTP `...errorHandler(?).then().catchError();`
  Future<T> open<T>(Uri uri, {String? method, Map<String, Object>? headers, String? body}) async {
    try {
      HttpClient httpClient = client;
      HttpClientRequest req = await httpClient.openUrl((method ?? 'get').toUpperCase(), uri);

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
      // Status: 201 gist comment Created
      if (res.statusCode == 200 || res.statusCode == 201) {
        // debugPrint(res.headers.toString());
        if (T == String) {
          return await responseToString(res) as T;
        } else if (T == Uint8List) {
          return await responseToBytes(res) as T;
        } else if (<String, dynamic>{} is T) {
          return await responseToMap(res) as T;
        } else {
          return res as T;
        }
      } else {
        debugPrint('${res.statusCode}');
        // debugPrint('${res.compressionState}');
        return Future<T>.error('Failed to load');
        // return Future.error("Failed to load", StackTrace.fromString("code: ${res.statusCode}"));
      }

      // return await new HttpClient().openUrl((method??'get').toUpperCase(), uri).then(
      //   (HttpClientRequest request) {
      // ).then((HttpClientResponse response) async{
      // });

    } on PlatformException catch (e) {
      return Future<T>.error(e.message!);
    } on TimeoutException catch (e) {
      return Future<T>.error(e.message!);
    } on SocketException catch (e) {
      if (e.port == null || e.address == null) {
        return Future<T>.error('No internet');
      } else {
        return Future<T>.error('Failed host lookup');
      }
    } on Error catch (e) {
      debugPrint('$e');
      return Future<T>.error('Error', e.stackTrace);
    } catch (e) {
      return Future<T>.error(e);
    }
  }

  Future<String> responseToString(HttpClientResponse response) async {
    return await response.transform(utf8.decoder).join();
    // final completer = Completer<String>();
    // final data = StringBuffer();
    // this.response.transform(utf8.decoder).listen((e) {
    //   data.write(e);
    // }, onDone: () => completer.complete(data.toString()));
    // return completer.future;
  }

  Future<Map<String, dynamic>> responseToMap(HttpClientResponse response) async {
    Map<String, dynamic> sd = {};
    response.headers.forEach((name, values) => sd[name] = values);
    // response.headers.value(name)
    // return {
    //   'header': response.headers,
    //   'body': UtilDocument.decodeJSON<Map<String, dynamic>>(await responseToString(response)),
    // };
    final str = await responseToString(response);
    sd['body'] = UtilDocument.decodeJSON<Map<String, dynamic>>(str);
    return sd;
  }

  Future<Uint8List> responseToBytes(HttpClientResponse response) async {
    return await consolidateHttpClientResponseBytes(response);
  }
}




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

class AskNest {
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
      return Future.error("No internet", StackTrace.fromString(e.toString()));
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
    // return await AskNest.errorHandler(http.get(uri, headers: headers)).catchError((error, stackTrace) => null);
      return http.get(uri, headers: headers).catchError((e) {
        throw Future.error("No internet");
      });
  }

  /// patch
  static Future<http.Response> patch(Uri uri, {Map<String, String> headers, Object body}) async {
    return await AskNest.errorHandler(http.patch(uri,headers: headers,body: body)).catchError((error, stackTrace) => null);
    // return await http.patch(uri,headers: headers,body: body);
  }

  static Future<String> request(String url) async {
    return await AskNest.get(Uri.parse(url)).then((response)=>response.body).catchError((error, stackTrace) => null);
  }

  // Future<String> requestString(String url) async {
  //   // return await AskNest.get(Uri.parse(url)).then((response)=>response.body).catchError((error, stackTrace) => null);
  //   return await AskNest.get(Uri.parse(url)).then((response)=>response.body);
  // }

  // await consolidateHttpClientResponseBytes(data);
  // await data.transform(utf8.decoder).join();
  // Future<List<int>> requestByte(String url) async {
  //   // return await AskNest.get(Uri.parse(url)).then((response)=>response.bodyBytes).catchError((error, stackTrace) => null);
  //   return await AskNest.get(Uri.parse(url)).then((response)=>response.bodyBytes);
  // }
}
*/