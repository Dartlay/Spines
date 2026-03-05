import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spines/data/models/book.dart';

class EpubService {
  static Future<List<String>> extractText(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      final epubBook = await EpubReader.readBook(bytes);

      final chapters = <String>[];

      if (epubBook.Chapters != null) {
        for (final chapter in epubBook.Chapters!) {
          if (chapter.HtmlContent != null && chapter.HtmlContent!.isNotEmpty) {
            final text = _convertHtmlToPlainText(chapter.HtmlContent!);
            if (text.isNotEmpty) {
              chapters.add(text);
            }
          }
        }
      }
      return chapters;
    } catch (e, stackTrace) {
      return [];
    }
  }

  static String _convertHtmlToPlainText(String html) {
    if (html.isEmpty) return '';

    try {
      String text = html;
      text = text.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '\n\n');
      text = text.replaceAll(RegExp(r'</p>', caseSensitive: false), '');
      text = text.replaceAll(
        RegExp(r'<h1[^>]*>', caseSensitive: false),
        '\n\n',
      );
      text = text.replaceAll(RegExp(r'</h1>', caseSensitive: false), '\n');
      text = text.replaceAll(
        RegExp(r'<h2[^>]*>', caseSensitive: false),
        '\n\n',
      );
      text = text.replaceAll(RegExp(r'</h2>', caseSensitive: false), '\n');
      text = text.replaceAll(
        RegExp(r'<h3[^>]*>', caseSensitive: false),
        '\n\n',
      );
      text = text.replaceAll(RegExp(r'</h3>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'<ul[^>]*>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'</ul>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'<ol[^>]*>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'</ol>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), ' • ');
      text = text.replaceAll(RegExp(r'</li>', caseSensitive: false), '\n');
      text = text.replaceAll(
        RegExp(r'<blockquote[^>]*>', caseSensitive: false),
        '\n\n',
      );
      text = text.replaceAll(
        RegExp(r'</blockquote>', caseSensitive: false),
        '\n\n',
      );

      text = text.replaceAll(RegExp(r'<div[^>]*>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'</div>', caseSensitive: false), '\n');

      text = text.replaceAll(RegExp(r'<span[^>]*>', caseSensitive: false), '');
      text = text.replaceAll(RegExp(r'</span>', caseSensitive: false), '');
      text = text.replaceAll(RegExp(r'<br[^>]*>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'<br/>', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'<br />', caseSensitive: false), '\n');
      text = text.replaceAll(RegExp(r'<[^>]*>'), '');
      text = text
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .replaceAll('&#39;', "'")
          .replaceAll('&mdash;', '—')
          .replaceAll('&ndash;', '–')
          .replaceAll('&laquo;', '«')
          .replaceAll('&raquo;', '»')
          .replaceAll('&hellip;', '…')
          .replaceAll('&rsquo;', '’')
          .replaceAll('&lsquo;', '‘')
          .replaceAll('&ldquo;', '“')
          .replaceAll('&rdquo;', '”')
          .replaceAll('&bull;', '•')
          .replaceAll('&middot;', '·')
          .replaceAll('&copy;', '©')
          .replaceAll('&reg;', '®')
          .replaceAll('&trade;', '™')
          .replaceAll('&euro;', '€')
          .replaceAll('&pound;', '£')
          .replaceAll('&yen;', '¥')
          .replaceAll('&sect;', '§')
          .replaceAll('&para;', '¶');
      text = text.replaceAllMapped(
        RegExp(r'&#(\d+);'),
        (match) => String.fromCharCode(int.parse(match.group(1)!)),
      );

      text = text.replaceAllMapped(
        RegExp(r'&#x([0-9a-fA-F]+);'),
        (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
      );
      text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
      text = text.replaceAll(RegExp(r'^[\s\n]+'), '');
      text = text.replaceAll(RegExp(r'[\s\n]+$'), '');

      return text;
    } catch (e) {
      return html;
    }
  }

  static Future<Map<String, dynamic>> getMetadata(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      final epubBookRef = await EpubReader.openBook(bytes);

      String title =
          epubBookRef.Title ?? filePath.split('/').last.split('.').first;
      String author = epubBookRef.Author ?? 'Неизвестный автор';
      int pages = 100;
      if (epubBookRef.Schema?.Package?.Spine?.Items != null) {
        pages = epubBookRef.Schema!.Package!.Spine!.Items!.length;
      }

      return {'title': title, 'author': author, 'pages': pages};
    } catch (e) {
      return {
        'title': filePath.split('/').last.split('.').first,
        'author': 'Неизвестный автор',
        'pages': 100,
      };
    }
  }

  static List<String> splitIntoPages(String text, int charsPerPage) {
    final pages = <String>[];
    for (int i = 0; i < text.length; i += charsPerPage) {
      final end = (i + charsPerPage < text.length)
          ? i + charsPerPage
          : text.length;
      pages.add(text.substring(i, end));
    }
    return pages;
  }
}
