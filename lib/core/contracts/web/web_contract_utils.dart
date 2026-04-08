import 'dart:convert';

String encodeJson(Map<String, dynamic> value) => jsonEncode(_compactMap(value));

String encodeJsonList(List<Map<String, dynamic>> value) =>
    jsonEncode(value.map(_compactMap).toList());

Map<String, dynamic> _compactMap(Map<String, dynamic> source) {
  final result = <String, dynamic>{};
  source.forEach((key, value) {
    if (value == null) return;
    if (value is Map<String, dynamic>) {
      result[key] = _compactMap(value);
      return;
    }
    if (value is List<Map<String, dynamic>>) {
      result[key] = value.map(_compactMap).toList();
      return;
    }
    result[key] = value;
  });
  return result;
}

String? normalizeMonthYearToIso(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  final monthYearWithSlash = RegExp(r'^(\d{2})\/(\d{4})$');
  final monthYearCompact = RegExp(r'^(\d{2})(\d{4})$');
  final isoPrefix = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');

  Match? match = monthYearWithSlash.firstMatch(trimmed);
  if (match == null) {
    match = monthYearCompact.firstMatch(trimmed);
  }

  if (match != null) {
    final month = int.tryParse(match.group(1)!);
    final year = int.tryParse(match.group(2)!);
    if (month == null || year == null || month < 1 || month > 12) {
      return trimmed;
    }
    return DateTime.utc(year, month, 1).toIso8601String();
  }

  final isoMatch = isoPrefix.firstMatch(trimmed);
  if (isoMatch != null) {
    final year = int.tryParse(isoMatch.group(1)!);
    final month = int.tryParse(isoMatch.group(2)!);
    final day = int.tryParse(isoMatch.group(3)!);
    if (year != null && month != null && day != null) {
      return DateTime.utc(year, month, day).toIso8601String();
    }
  }

  final parsed = DateTime.tryParse(trimmed);
  if (parsed != null) {
    return DateTime.utc(parsed.year, parsed.month, parsed.day).toIso8601String();
  }

  return trimmed;
}

String normalizeZip(Object? value) => value?.toString().trim() ?? '';

String? nullIfBlank(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}

String ensureHtmlString(String value) => value.trim();

String combineName(String firstName, String surname) {
  final first = firstName.trim();
  final last = surname.trim();
  return [first, last].where((part) => part.isNotEmpty).join(' ');
}

bool isRemoteResource(String? pathOrUrl) {
  if (pathOrUrl == null) return false;
  final normalized = pathOrUrl.trim().toLowerCase();
  return normalized.startsWith('http://') || normalized.startsWith('https://');
}

String safeString(Object? value) => value?.toString().trim() ?? '';
