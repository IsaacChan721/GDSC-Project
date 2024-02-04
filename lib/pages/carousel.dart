import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Column videoCarousel(List<Widget> videos) {
  CarouselController buttonCarouselController = CarouselController();
  return Column(
    children: [
      Expanded(
        child: CarouselSlider(
          items:videos,
          carouselController: buttonCarouselController,
          options: CarouselOptions(
            autoPlay: false,
            // enlargeCenterPage: true,
            // viewportFraction: 0.2,
            aspectRatio: 2.0,
            initialPage: 0,
          ),
        ),
      ),
      Row(
        children: [
          ElevatedButton(
            onPressed: () => buttonCarouselController.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.linear),
            child: const Text('<'),
          ),
          ElevatedButton(
            onPressed: () => buttonCarouselController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.linear),
            child: const Text('>'),
          )
        ],
      )
    ]
  );
}

// class CarouselDemo extends StatelessWidget {
//   CarouselController buttonCarouselController = CarouselController();

//  @override
//   Widget build(BuildContext context) => Column(
//     children: [
//       CarouselSlider(
//         items:[ Text('hi'), Text('bye')],
//         carouselController: buttonCarouselController,
//         options: CarouselOptions(
//           height: 100,
//           autoPlay: false,
//           // enlargeCenterPage: true,
//           // viewportFraction: 0.2,
//           aspectRatio: 2.0,
//           initialPage: 2,
//         ),
//       ),
//       Row(
//         children: [
//           ElevatedButton(
//             onPressed: () => buttonCarouselController.nextPage(
//                 duration: Duration(milliseconds: 300), curve: Curves.linear),
//             child: const Text('<'),
//           ),
//           ElevatedButton(
//             onPressed: () => buttonCarouselController.previousPage(
//                 duration: Duration(milliseconds: 300), curve: Curves.linear),
//             child: const Text('>'),
//           )
//         ],
//       )
//     ]
//   );
// }