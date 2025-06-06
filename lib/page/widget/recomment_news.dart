import 'package:flutter/material.dart';

  Widget RecommentNews() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(10, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image
                          Image.network(
                            'https://www.shutterstock.com/image-illustration/tv-news-studio-broadcaster-breaking-260nw-1067935568.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 130,
                          ),
                          // Title
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(
                              10,
                              8,
                              10,
                              4,
                            ),
                            child: Text(
                              'US Tariffs Expected To Dent Thai GDP',
                              maxLines: 3,
                              overflow:
                              TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff14213D),
                              ),
                            ),
                          ),
                          // Date and Time Ago
                          Padding(
                            padding:
                            const EdgeInsets.fromLTRB(
                              10,
                              0,
                              10,
                              10,
                            ),
                            child: Text(
                              'Date: 2/4/2025 | 2d',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
