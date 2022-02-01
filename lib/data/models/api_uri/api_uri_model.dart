class ApiUri {
  final String baseUrl;
  final String route;
  final Map<String, String> params;

  ApiUri({
    required this.baseUrl,
    required this.route,
    required this.params,
  });
}
