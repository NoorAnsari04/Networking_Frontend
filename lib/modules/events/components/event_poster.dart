import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/event_model.dart';

class EventImageWidget extends StatelessWidget {
  final EventModel event;

  EventImageWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: CachedNetworkImage(
          imageUrl: event.posterUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
