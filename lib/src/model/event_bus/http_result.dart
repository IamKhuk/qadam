class HttpResult {
  final bool isSuccess;
  final int status;
  var result;

  HttpResult({
    required this.isSuccess,
    required this.result,
    required this.status,
  });
}