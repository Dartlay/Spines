import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/features/reader/widgets/font_size_dialog.dart';
import 'package:spines/features/reader/widgets/reader_controls.dart';
import 'package:spines/features/reader/widgets/reader_page_content.dart';
import 'package:spines/features/reader/widgets/swipe_indicator.dart';
import '../bloc/reader_bloc.dart';
import '../../shared/widgets/loading_view.dart';
import '../../shared/widgets/error_view.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../main.dart';

class ReaderPage extends StatelessWidget {
  final String bookId;

  const ReaderPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReaderBloc(repository: globalRepository)..add(LoadReader(bookId)),
      child: ReaderView(bookId: bookId),
    );
  }
}

class ReaderView extends StatefulWidget {
  final String bookId;

  const ReaderView({super.key, required this.bookId});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> with TickerProviderStateMixin {
  late PageController _pageController;
  bool _isPageControllerReady = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isPageControllerReady = true);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _jumpToPage(int page) {
    if (_isPageControllerReady && _pageController.hasClients) {
      _pageController.jumpToPage(page);
    }
  }

  void _toggleControls(bool show) {
    if (show) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  void _showPageIndicator(int currentPage, int totalPages) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Страница $currentPage из $totalPages'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReaderBloc, ReaderState>(
      listener: (context, state) {
        if (state.status == ReaderStatus.loaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _jumpToPage(state.currentPage);
          });
        }
        _toggleControls(state.showControls);
      },
      builder: (context, state) {
        if (state.status == ReaderStatus.loading) {
          return const LoadingView(message: 'Загрузка книги...');
        }

        if (state.status == ReaderStatus.error) {
          return ErrorView(
            message: state.errorMessage ?? 'Ошибка загрузки',
            onRetry: () {
              context.read<ReaderBloc>().add(LoadReader(widget.bookId));
            },
          );
        }

        if (state.pages.isEmpty) {
          return const ErrorView(message: 'Книга пуста');
        }

        return WillPopScope(
          onWillPop: () async {
            _navigateBack(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F3F0),
            body: GestureDetector(
              onTap: () {
                context.read<ReaderBloc>().add(const ToggleControls());
              },
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: state.pages.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (page) {
                      context.read<ReaderBloc>().add(
                        UpdateReaderProgress(widget.bookId, page),
                      );
                      _showPageIndicator(page + 1, state.pages.length);
                    },
                    itemBuilder: (context, index) {
                      return ReaderPageContent(
                        text: state.pages[index],
                        pageNumber: index + 1,
                        totalPages: state.pages.length,
                        fontSize: state.fontSize,
                        showSwipeHint: index == 0 && state.currentPage == 0,
                      );
                    },
                  ),

                  if (_isDragging)
                    SwipeIndicator(
                      currentPage: state.currentPage + 1,
                      totalPages: state.pages.length,
                    ),

                  if (state.showControls)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ReaderTopControls(
                          onBackPressed: () => _navigateBack(context),
                          onFontSizePressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (modalContext) {
                                return FontSizeDialog(
                                  readerBloc: context.read<ReaderBloc>(),
                                );
                              },
                            );
                          },
                          title: state.book?.title,
                          author: state.book?.author,
                        ),
                      ),
                    ),

                  if (state.showControls)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ReaderBottomControls(
                          currentPage: state.currentPage,
                          totalPages: state.pages.length,
                          fontSize: state.fontSize,
                          onPageChanged: (page) {
                            if (_isPageControllerReady) {
                              _pageController.jumpToPage(page);
                              context.read<ReaderBloc>().add(
                                UpdateReaderProgress(widget.bookId, page),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
