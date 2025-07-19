import 'package:flutter/material.dart';

class FilterNews extends StatefulWidget {
  final String initialSort;
  final String initialSentiment;
  const FilterNews({
    super.key,
    required this.initialSentiment,
    required this.initialSort,
  });

  @override
  State<FilterNews> createState() => _FilterNewsState();
}

class _FilterNewsState extends State<FilterNews> {
  @override
  void initState() {
    super.initState();
    sortOptions = widget.initialSort;
    selectedSentiment = widget.initialSentiment;
  }

  String sortOptions = 'Desc';
  String selectedSentiment = 'Neutral';

  final sortChoices = {'Desc': 'Newest to Oldest', 'Asc': 'Oldest to Newest'};
  final sentimentChoices = {
    '': 'ALL',
    'Neutral': 'Neutral News',
    'Positive': 'Positive News',
    'Negative': 'Negative News',
  };

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Filter Option',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sort By',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            ...sortChoices.entries.map(
                              (entry) => ChoiceChip(
                                label: Text(entry.value),
                                selected: sortOptions == entry.key,
                                onSelected: (bool selected) {
                                  setModalState(() {
                                    sortOptions = entry.key;
                                  });
                                  setState(() {});
                                },
                                selectedColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Sentiment',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            ...sentimentChoices.entries.map(
                              (entry) => ChoiceChip(
                                label: Text(entry.value),
                                selected: selectedSentiment == entry.key,
                                onSelected: (bool selected) {
                                  setModalState(() {
                                    selectedSentiment = entry.key;
                                  });
                                  setState(() {});
                                },
                                selectedColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            'sortOptions': sortOptions,
                            'selectedSentiment': selectedSentiment,
                          });
                        },
                        child: const Text('Apply'),
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
