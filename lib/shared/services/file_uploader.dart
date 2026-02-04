import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_architecture_blueprint/core/error/failures.dart';
import 'package:flutter_architecture_blueprint/core/error/handle_dio_failure.dart';
import 'package:flutter_architecture_blueprint/core/network/dio_client.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class FileUploader {
  final DioClient dioClient;

  FileUploader(this.dioClient);

  Future<Either<Failure, String>> uploadImage(
    File file, {
    required String pathSegment,
  }) async {
    try {
      final originalImage = img.decodeImage(file.readAsBytesSync());

      if (originalImage != null) {
        // Resize the image (width: 300, height: auto-maintained)
        final resizedImage = img.copyResize(originalImage, width: 100);

        // Save the resized image to a temporary file
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/resized_image.jpg')
          ..writeAsBytesSync(img.encodeJpg(resizedImage));

        FormData formatData = FormData.fromMap({
          "image": await MultipartFile.fromFile(
            tempFile.path,
            filename:
                "${DateTime.now().millisecondsSinceEpoch}${path.basename(file.path)}",
          ),
        });

        final response = await dioClient.post(
          '/upload/$pathSegment',
          data: formatData,
        );
        await tempFile.delete(); // Clean up after success
        return Right(response.data["filePath"]);
      } else {
        return Left(ValidationFailure('Invalid image file'));
      }
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
