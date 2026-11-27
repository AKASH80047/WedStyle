import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models.dart';

/// Client for WedStyle's private try-on backend.
///
/// The backend, not the app, holds the provider credential and submits both
/// images to a virtual try-on provider. Configure it at build time with
/// `--dart-define=AI_TRYON_BACKEND_URL=https://your-domain/try-on`.
class AiTryOnService {
  static final AiTryOnService _instance = AiTryOnService._internal();
  factory AiTryOnService() => _instance;
  AiTryOnService._internal();

  static const _backendUrl = String.fromEnvironment('AI_TRYON_BACKEND_URL');

  /// Compatibility metadata for the admin status screen. Credentials entered
  /// there are intentionally ignored: provider keys belong only on the backend.
  final AiServiceConfigModel config = AiServiceConfigModel(
    apiKey: '',
    provider: 'Private WedStyle backend',
    endpointUrl: _backendUrl.isEmpty ? 'Configured at build time' : _backendUrl,
    isEnabled: _backendUrl.isNotEmpty,
    modelName: 'Backend-managed provider',
    faceFidelityWeight: 0,
    garmentDrapePhysics: 0,
  );

  void updateConfig(AiServiceConfigModel _) {}

  bool get isLiveApiConfigured => _backendUrl.isNotEmpty;

  Future<String> processVirtualTryOn({
    required String userPhotoPath,
    required ProductModel garment,
  }) async {
    // 1. If userPhotoPath is a file path, verify it exists
    if (!userPhotoPath.startsWith('assets/') && !userPhotoPath.startsWith('blob:')) {
      final localPath = userPhotoPath.startsWith('file://')
          ? userPhotoPath.replaceFirst('file://', '')
          : userPhotoPath;
      final photo = File(localPath);
      if (!await photo.exists()) {
        throw const AiTryOnException(
          'Your selected photo is no longer available. Please choose it again.',
        );
      }
      if (await photo.length() > 10 * 1024 * 1024) {
        throw const AiTryOnException('Please choose a photo smaller than 10 MB.');
      }
    }

    // 2. In demo/emulator mode (no backend URL configured)
    if (!isLiveApiConfigured) {
      await Future.delayed(const Duration(milliseconds: 1600));

      // When using the default sample user photo, return matching high-res try-on look
      if (userPhotoPath == 'assets/images/user_face.jpg') {
        final category = garment.categoryId.toLowerCase();
        final name = garment.name.toLowerCase();
        if (category.contains('panetar') ||
            name.contains('panetar') ||
            category.contains('saree')) {
          return 'assets/images/tryon_panetar_user.jpg';
        }
        return 'assets/images/tryon_lehenga_user.jpg';
      }

      // For other models or user-uploaded photos, return the garment visual
      return garment.images.length > 1
          ? garment.images[1]
          : garment.images.first;
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_backendUrl))
        ..fields.addAll({
          'product_id': garment.id,
          'garment_image_url': garment.images.first,
          'category': garment.categoryName,
          'preserve_identity': 'true',
        })
        ..files.add(
          await http.MultipartFile.fromPath('person_image', userPhotoPath),
        );
      final response = await request.send().timeout(
        const Duration(seconds: 90),
      );
      final body = await response.stream.bytesToString();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AiTryOnException(
          'Try-on service could not process this request (${response.statusCode}).',
        );
      }
      final payload = jsonDecode(body);
      final resultUrl = payload is Map ? payload['result_image_url'] : null;
      if (resultUrl is! String || resultUrl.isEmpty) {
        throw const AiTryOnException(
          'The try-on service returned no result image. Please try again.',
        );
      }
      return resultUrl;
    } on AiTryOnException {
      rethrow;
    } on SocketException {
      throw const AiTryOnException(
        'Network unavailable. Check your connection and try again.',
      );
    } catch (_) {
      throw const AiTryOnException(
        'Try-on could not be completed. Please try again later.',
      );
    }
  }
}

class AiTryOnException implements Exception {
  final String message;
  const AiTryOnException(this.message);
  @override
  String toString() => message;
}
