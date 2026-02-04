// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageAvatarPicker extends StatefulWidget {
//   final String? imageUrl;
//   final double radius;
//   final Function(File image) onImagePicked;

//   const ImageAvatarPicker({
//     super.key,
//     this.imageUrl,
//     required this.onImagePicked,
//     this.radius = 55,
//   });

//   @override
//   State<ImageAvatarPicker> createState() => _ImageAvatarPickerState();
// }

// class _ImageAvatarPickerState extends State<ImageAvatarPicker> {
//   final ImagePicker _picker = ImagePicker();
//   File? _image;

//   Future<void> _pickImage() async {
//     final file = await _picker.pickImage(source: ImageSource.gallery);
//     if (file != null && mounted) {
//       final img = File(file.path);
//       setState(() => _image = img);
//       widget.onImagePicked(img);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30),
//       child: GestureDetector(
//         onTap: _pickImage,
//         child: Stack(
//           children: [
//             // Priority: Local file > Network image > Default
//             _image != null
//                 ? CircleAvatar(
//                     radius: widget.radius,
//                     backgroundImage: FileImage(_image!),
//                   )
//                 : widget.imageUrl != null
//                 ? ClipOval(
//                     child: CachedNetworkImage(
//                       imageUrl: widget.imageUrl!,
//                       height: widget.radius * 2,
//                       width: widget.radius * 2,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) =>
//                           const CircularProgressIndicator(),
//                       errorWidget: (context, url, error) =>
//                           CircleAvatar(radius: widget.radius),
//                     ),
//                   )
//                 : CircleAvatar(radius: widget.radius),
//             Positioned(
//               right: 3,
//               bottom: 3,
//               child: CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Theme.of(context).primaryColor,
//                 child: const Icon(
//                   Icons.camera_alt,
//                   size: 20,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
