import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:navigation_drawer_challenge/src/core/providers/providers.dart';
import 'package:navigation_drawer_challenge/src/views/widgets/like_button.dart';

import 'filter_by_button.dart';
import 'search_button.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FilterBy(),
        actions: const [SearchButton()],
      ),
      body: const ProductsGrid(),
    );
  }
}

class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final products = ref.watch(filteredProductsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          childAspectRatio: 1 / 2.2,
        ),
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return Column(
            children: [
              Expanded(
                flex: 13,
                child: _ImageRotationAnimation(
                  image: product.image,
                  index: index,
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    _TextUpAnimation(
                      child: Text(
                        product.name,
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      index: index,
                    ),
                    const SizedBox(height: 7),
                    _TextUpAnimation(
                      child: Text(
                        product.subname,
                        style: GoogleFonts.libreBaskerville(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      index: index,
                    ),
                    const SizedBox(height: 15),
                    _TextUpAnimation(
                      child: Text(
                        '${product.price} USD',
                        style: GoogleFonts.nunito(
                          color: const Color(0xFF4559A9),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      index: index,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _TextUpAnimation extends ConsumerWidget {
  const _TextUpAnimation({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(categoryAnimationControllerProvider);

    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: controller.controller,
        builder: (_, child) {
          return Transform.translate(
            offset: controller.isAnimating
                ? controller.textUpAnimation(index).value
                : const Offset(0, 0),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class _ImageRotationAnimation extends ConsumerWidget {
  const _ImageRotationAnimation({
    Key? key,
    required this.index,
    required this.image,
  }) : super(key: key);

  final int index;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(categoryAnimationControllerProvider);

    return AnimatedBuilder(
      animation: controller.controller,
      builder: (_, child) {
        final matrix = Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(pi * controller.rotateAnimation(index).value);

        return Transform(
          alignment: Alignment.center,
          transform: controller.isAnimating ? matrix : Matrix4.identity(),
          child: child,
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(image),
              ),
            ),
          ),
          const Positioned(
            bottom: 8,
            right: 10,
            child: LikeButton(),
          ),
        ],
      ),
    );
  }
}