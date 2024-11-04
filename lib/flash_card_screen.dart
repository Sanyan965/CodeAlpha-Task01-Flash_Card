import 'package:flutter/material.dart';
import 'dart:async';

class flash_card_screen extends StatefulWidget {
  @override
  _flash_card_screen createState() => _flash_card_screen();
}

class _flash_card_screen extends State<flash_card_screen> {
  List<Map<String, String>> flashcards = [];
  int currentFlashcardIndex = 0;
  bool quizStarted = false;
  bool showAnswerMessage = false;
  TextEditingController answerController = TextEditingController();
  String feedbackMessage = "";

  void _addFlashcard(String question, String answer) {
    setState(() {
      flashcards.add({'question': question, 'answer': answer});
    });
  }

  void _startQuiz() {
    if (flashcards.isNotEmpty) {
      setState(() {
        currentFlashcardIndex = 0;
        quizStarted = true;
        showAnswerMessage = false;
        answerController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("No flashcards added. Please add some to start the quiz."),
        ),
      );
    }
  }

  void _resetQuiz() {
    setState(() {
      flashcards.clear();
      currentFlashcardIndex = 0;
      quizStarted = false;
      showAnswerMessage = false;
      answerController.clear();
    });
  }

  void _checkAnswer() {
    String userAnswer = answerController.text.trim();
    String correctAnswer = flashcards[currentFlashcardIndex]['answer']!.trim();

    setState(() {
      if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
        feedbackMessage = 'Your answer is correct!';
        answerController.clear();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            if (currentFlashcardIndex < flashcards.length - 1) {
              currentFlashcardIndex++;
              feedbackMessage = '';
            } else {
              quizStarted = false;
              feedbackMessage = '';
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Quiz completed!")),
              );
            }
          });
        });
      } else {
        feedbackMessage = 'Your answer is incorrect. Try again!';
        showAnswerMessage = true;
      }
    });
  }

  void _showAddFlashcardDialog() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Flashcard"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: "Enter Question"),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: "Enter Answer"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  _addFlashcard(questionController.text, answerController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (flashcards.isNotEmpty && quizStarted) {
      displayText = flashcards[currentFlashcardIndex]['question']!;
    } else if (flashcards.isNotEmpty) {
      displayText = "Press 'Start Quiz' to begin.";
    } else {
      displayText = "No flashcards available.";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FlashCard Quiz',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total Flashcards Added: ${flashcards.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: _startQuiz,
              child: const Text(
                'Start Quiz',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: _resetQuiz,
              child: const Text(
                'Reset Quiz',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              displayText,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            if (quizStarted) ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: "Enter your answer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: _checkAnswer,
                child: const Text(
                  'Submit Answer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (feedbackMessage.isNotEmpty)
                Text(
                  feedbackMessage,
                  style: TextStyle(
                    color: feedbackMessage == "correct" ||
                            feedbackMessage == "Your answer is correct!"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              // if (feedbackMessage.isNotEmpty)
              //   Text(
              //     feedbackMessage,
              //     style: TextStyle(
              //       color: feedbackMessage == "correct"
              //           ? Colors.green
              //           : Colors.red,
              //     ),
              //   ),
            ],
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _showAddFlashcardDialog,
      //   tooltip: 'Add FlashCard',
      //   child: const Icon(
      //     Icons.add,

      //   ),
      // ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
            onPressed: _showAddFlashcardDialog,
            child: const Icon(Icons.add),
          ),
          const Positioned(
            bottom: 4, // Adjust the position as needed
            child: Text(
              'Add',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12, // Adjust font size as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
