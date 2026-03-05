import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spines/features/reader/widgets/reader_stat_item.dart';
import '../bloc/reader_bloc.dart';

class ReaderTopControls extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onFontSizePressed;
  final String? title;
  final String? author;

  const ReaderTopControls({
    super.key,
    required this.onBackPressed,
    required this.onFontSizePressed,
    this.title,
    this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildControlButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: onBackPressed,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title ?? 'Чтение',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Georgia',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (author != null)
                      Text(
                        author!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildControlButton(
                icon: Icons.format_size_rounded,
                onPressed: onFontSizePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        onPressed: onPressed,
        splashRadius: 24,
      ),
    );
  }
}

class ReaderBottomControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double fontSize;
  final ValueChanged<int> onPageChanged;

  const ReaderBottomControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.fontSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildSlider(), const SizedBox(height: 16), _buildStats()],
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
          ),
          child: Slider(
            value: currentPage.toDouble(),
            min: 0,
            max: (totalPages - 1).toDouble(),
            divisions: totalPages - 1,
            onChanged: (value) => onPageChanged(value.round()),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReaderStatItem(
          icon: Icons.menu_book_rounded,
          value: '${currentPage + 1}',
          label: 'текущая',
        ),
        ReaderStatItem(
          icon: Icons.auto_awesome_rounded,
          value: '${_calculateProgress()}%',
          label: 'прочитано',
        ),
        ReaderStatItem(
          icon: Icons.hourglass_empty_rounded,
          value: '${totalPages - currentPage - 1}',
          label: 'осталось',
        ),
      ],
    );
  }

  int _calculateProgress() {
    return ((currentPage + 1) / totalPages * 100).round();
  }
}
