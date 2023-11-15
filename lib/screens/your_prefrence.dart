// ignore_for_file: library_private_types_in_public_api, unused_element, prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  List<String> options = [
    'Not important',
    'Important',
  ];
  List<QuestionSection> questionSections = [
    QuestionSection(
      title: 'Nutional quality',
      questions: [
        {
          'question': 'Good nutional quality(nutri-score)',
          'selectedOption': 'Important',
        },
        {
          'question': 'Salt in low quantity',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Sugar in low quantity',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Fat in low quantity',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Saturated fat in low quantity',
          'selectedOption': 'Not important',
        },
      ],
    ),
    QuestionSection(
      title: 'Ingredients',
      questions: [
        {
          'question': 'Palm Oil free',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Without onion garlic',
          'selectedOption': 'Not important',
        },
      ],
    ),
    QuestionSection(
      title: 'Allergens',
      questions: [
        {
          'question': 'Without Gluten',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Without Milk',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Without Peanuts',
          'selectedOption': 'Not important',
        },
        {
          'question': 'Without Soy',
          'selectedOption': 'Not important',
        }
      ],
    ),
    // Add more sections here
  ];
  @override
  void initState() {
    super.initState();
    _loadSavedChoices();
    questionSections[0].isExpanded = true;
  }

  void _loadSavedChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var section in questionSections) {
      for (var questionData in section.questions) {
        var question = questionData['question'];
        var savedOption = prefs.getString('$question-selectedOption');
        if (savedOption != null) {
          setState(() {
            questionData['selectedOption'] = savedOption;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextButton(
                text: 'Save Choices',
                backgroundColor: Blue1,
                textColor: Blue2,
                onPressed: () {
                  Provider.of<ChoiceModel>(context, listen: false)
                      ._saveChoices();
                }),
            SizedBox(
              height: 30,
            ),
            CustomTextButton(
                text: 'Reset Choices',
                backgroundColor: Blue1,
                textColor: Blue2,
                onPressed: () {
                  Provider.of<ChoiceModel>(context, listen: false)
                      ._resetAllChoices();
                }),
            SizedBox(
              height: 30,
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  questionSections[index].isExpanded = isExpanded;
                });
              },
              children: questionSections.map<ExpansionPanel>((section) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(section.title),
                    );
                  },
                  body: Column(
                    children: section.questions.map<Widget>((questionData) {
                      return MCQQuestionCard(
                        question: questionData['question'],
                        options: options,
                        selectedOption: Provider.of<ChoiceModel>(context)
                            .getChoice(questionData['question']),
                        onOptionSelected: (option) {
                          Provider.of<ChoiceModel>(context, listen: false)
                              .setChoice(questionData['question'], option);
                        },
                      );
                    }).toList(),
                  ),
                  isExpanded: section.isExpanded,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChoiceModel with ChangeNotifier {
  Map<String, int> _selectedChoices = {};

  ChoiceModel() {
    loadChoices();
  }

  int getChoice(String question) {
    return _selectedChoices[question] ?? 0;
  }

  void setChoice(String question, int choice) {
    _selectedChoices[question] = choice;
    _saveChoices();
    notifyListeners();
  }

  void _saveChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedChoices.forEach((question, choice) {
      prefs.setInt('$question-selectedChoice', choice);
    });
  }

  void loadChoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var question in _selectedChoices.keys) {
      var savedChoice = prefs.getInt('$question-selectedChoice');
      if (savedChoice != null) {
        _selectedChoices[question] = savedChoice;
      }
    }
  }

  void _resetAllChoices() {
    _selectedChoices = {};
    _saveChoices();
    notifyListeners();
  }

  // Retrieve selected choices as a Map
  Map<String, int> getSelectedChoices() {
    return Map.from(_selectedChoices);
  }
}

class QuestionSection {
  String title;
  List<Map<String, dynamic>> questions;
  bool isExpanded = false;

  QuestionSection({
    required this.title,
    required this.questions,
  });
}

class MCQQuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int selectedOption;
  final ValueChanged<int> onOptionSelected;

  MCQQuestionCard({
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8.0),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: options.map((option) {
              final optionIndex = options.indexOf(option);
              return GestureDetector(
                onTap: () {
                  onOptionSelected(optionIndex); // Pass the index as an int
                },
                child: Column(
                  children: [
                    Radio(
                      value: optionIndex, // Use index as value
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        // Receive and use index as int
                        onOptionSelected(value!);
                      },
                    ),
                    Text(option),
                  ],
                ),
              );
            }).toList(),
          )
        ]));
  }
}
