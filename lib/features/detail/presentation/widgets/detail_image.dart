import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String photoUrl;

  const DetailImage({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      photoUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 350,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          ),
        );
      },
      errorBuilder:
          (context, error, stackTrace) => Container(
            height: 350,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
          ),
    );
  }
}
