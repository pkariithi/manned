import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MannedPagesAboutDialog extends StatelessWidget {
  const MannedPagesAboutDialog({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyUrlToClipboard(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/icon.png'), width: 48, height: 48),
          SizedBox(width: 16),
          Text('Manned Pages'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Version 1.0.2',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'A modern, user-friendly Linux command reference application for Ubuntu.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Manned Pages provides comprehensive documentation for the most commonly used Linux commands. Designed specifically for Ubuntu with the native Yaru theme, it presents command information in a clean, accessible interface that\'s easier to navigate than traditional man pages.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'https://github.com/pkariithi/manned',
                    child: InkWell(
                      onTap: () =>
                          _launchUrl('https://github.com/pkariithi/manned'),
                      onSecondaryTap: () => _copyUrlToClipboard(
                        context,
                        'https://github.com/pkariithi/manned',
                      ),
                      child: Image.asset(
                        'assets/github-logo.png',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Tooltip(
                    message: 'https://buymeacoffee.com/patrickariithi',
                    child: InkWell(
                      onTap: () =>
                          _launchUrl('https://buymeacoffee.com/patrickariithi'),
                      onSecondaryTap: () => _copyUrlToClipboard(
                        context,
                        'https://buymeacoffee.com/patrickariithi',
                      ),
                      child: Image.asset(
                        'assets/buymeacoffee.png',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
