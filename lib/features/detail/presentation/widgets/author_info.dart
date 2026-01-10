import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/utils/helper.dart';

class AuthorInfo extends StatelessWidget {
  const AuthorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          child: Text(
            story.name.isNotEmpty ? story.name[0].toUpperCase() : '?',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                story.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
              ),
              Text(
                getTimeDifference(context, story.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
