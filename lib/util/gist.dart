part of '../engine.dart';

class GistData {
  final String token;
  final String id;

  late UtilClient client;

  GistData({required this.token, required this.id}) {
    client = UtilClient(uri);
  }

  Uri get uri => Uri.https('api.github.com', '/gists/$id');

  Map<String, String> get header => {
    'Accept': 'application/vnd.github.v3+json',
    'Authorization':'token $token',
    // 'Content-type': 'application/json',
    'User-Agent': 'lidea'
  };

  /// get content
  Future<dynamic> test() async {

    // await client.get<String>().then((res) {
    //   print('result $res');
    // }).catchError((e){
    //   print('error $e');
    // });

    // file list
    // await this.files().then((res) {
    //   print('result $res');
    // }).catchError((e){
    //   print('error $e');
    // });

    // test return
    // final abc = await this.files().then((res) {
    //   print('result $res');
    //   return 'work fine';
    // }).catchError((e){
    //   print('error $e');
    //   return 'error return testing';
    // });
    // return abc;

    // Update a file
    // await this.update('test.json',UtilDocument.encodeJSON({"build":131,"Updating":true})).then((res) {
    //   print('result $res');
    // }).catchError((e){
    //   print('error $e');
    // });
    // Create a file
    // await this.update('delete.json',UtilDocument.encodeJSON({"build":121,"Updating":true})).then((res) {
    //   print('result $res');
    // }).catchError((e){
    //   print('error $e');
    // });
    // await this.remove('delete.json').then((res) {
    //   print('result $res');
    // }).catchError((e){
    //   print('error $e');
    // });

    // return 'working';
    
    return await this.testDownloadAndExtract().catchError((e){
      print('error $e');
    });
  }

  Future<List<String>> testDownloadAndExtract(){
    return this.files().then((res) async {
      final List<String> result =[];
      final files = res.where((e) => e['type']=="application/zip");
      for (var item in files) {
        if (item['truncated'] == false){
          final bytes = await UtilDocument.strToListInt(item['content']);
          await UtilArchive().extract(bytes);
        } else {
          await UtilClient(item['url']).get<Uint8List>().then((res) {
            UtilArchive().extract(res).then(
              (arc) {
                arc!.forEach((fileName) async { 
                  final isExists = await UtilDocument.exists(fileName);
                  print('$fileName added: $isExists');
                });
              }
            );
          });
        }
        // final isExists = await UtilDocument.exists(item['file']);
        // result.add('${item['file']} added: $isExists');
      }
      return result;
    });
    // final url = 'https://gist.githubusercontent.com/khensolomon/9dc9dc3eb09fbdfe026f9b526ed85415/raw/ba858c18573831953eaa1d54ceef87e91ff67fa9/env.json';
    // return await this.download(url);
    // return await this.update('test.json',UtilDocument.encodeJSON({"Updating":true}));
  }

  /// get list of files
  Future<List<Map<String, dynamic>>> files() {
    return client.get<String>().then<List<Map<String, dynamic>>>((res) {
      return UtilDocument.decodeJSON<Map<String, dynamic>>(res)['files'].values.map(
        (entry) => {
          'file':entry['filename'],
          'type':entry['type'],
          'url':entry['raw_url'],
          'size':entry['size'],
          'truncated':entry['truncated'],
          'content':entry['truncated'] == true?'':entry['content'],
        }
      ).toList().cast<Map<String, dynamic>>();
    });
  }

  /// Update or Create a file eg. fileContent: UtilDocument.encodeJSON({"test":true})
  Future<dynamic> update(String fileName, Object fileContent) {
    return client.patch<String>(headers: header, body: UtilDocument.encodeJSON<Object>(
      {
        "files":{
          "$fileName":{"content":fileContent}
        }
      }
    ));
  }

  /// Delete a file
  Future<dynamic> remove(String fileName) async{
    return client.patch<String>(headers: header, body: UtilDocument.encodeJSON<Object>(
      {
        "files":{
          "$fileName":{"content":""}
        }
      }
    ));
  }

}
