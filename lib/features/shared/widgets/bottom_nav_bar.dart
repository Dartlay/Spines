import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spines/core/localization/s.dart';
import 'package:spines/core/theme/app_colors.dart';
import 'package:spines/features/favorites/bloc/favorites_bloc.dart';
import 'package:spines/features/home/bloc/home_bloc.dart';
import 'package:spines/features/shelf/bloc/shelf_bloc.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == navigationShell.currentIndex) {
            _refreshCurrentPage(context, index);
          }

          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: context.tr.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: context.tr.favorites,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_outlined),
            activeIcon: Icon(Icons.auto_stories),
            label: context.tr.myShelf,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: context.tr.profile,
          ),
        ],
      ),
    );
  }

  void _refreshCurrentPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        try {
          context.read<HomeBloc>().add(const RefreshHomeData());
        } catch (e) {}
        break;
      case 1:
        try {
          context.read<FavoritesBloc>().add(const RefreshFavorites());
        } catch (e) {}
        break;
      case 2:
        try {
          context.read<ShelfBloc>().add(const RefreshShelf());
        } catch (e) {}
        break;
    }
  }
}
