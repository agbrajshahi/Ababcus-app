import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const AbacusMathApp());
}

class AbacusMathApp extends StatelessWidget {
  const AbacusMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abacus Flash Math',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const FlashCalculationScreen(),
    );
  }
}

class FlashCalculationScreen extends StatefulWidget {
  const FlashCalculationScreen({super.key});

  @override
  State<FlashCalculationScreen> createState() => _FlashCalculationScreenState();
}

class _FlashCalculationScreenState extends State<FlashCalculationScreen> {
  int digitLength = 1;
  int numberOfRows = 5;
  double speedInSeconds = 1.0;

  List<int> numbersList = [];
  int currentDisplayIndex = -1;
  int calculatedSum = 0;
  bool isRunning = false;
  bool isFinished = false;

  final TextEditingController _answerController = TextEditingController();
  String resultMessage = '';

  void startPractice() {
    FocusScope.of(context).unfocus();
    _answerController.clear();
    
    List<int> generated = [];
    int minVal = pow(10, digitLength - 1).toInt();
    int maxVal = (pow(10, digitLength) - 1).toInt();
    Random rand = Random();

    int sum = 0;
    for (int i = 0; i < numberOfRows; i++) {
      int num = minVal + rand.nextInt(maxVal - minVal + 1);
      if (i > 0 && rand.nextBool() && (sum - num) > 0) {
        num = -num;
      }
      generated.add(num);
      sum += num;
    }

    setState(() {
      numbersList = generated;
      calculatedSum = sum;
      currentDisplayIndex = 0;
      isRunning = true;
      isFinished = false;
      resultMessage = '';
    });

    Timer.periodic(Duration(milliseconds: (speedInSeconds * 1000).round()), (timer) {
      if (currentDisplayIndex < numbersList.length - 1) {
        setState(() {
          currentDisplayIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
          isFinished = true;
        });
      }
    });
  }

  void checkAnswer() {
    int? userAnswer = int.tryParse(_answerController.text.trim());
    setState(() {
      if (userAnswer == calculatedSum) {
        resultMessage = '🎉 সঠিক উত্তর! (Correct: $calculatedSum)';
      } else {
        resultMessage = '❌ ভুল উত্তর! সঠিক ছিল: $calculatedSum';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abacus Flash Math Practice'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isRunning && currentDisplayIndex >= 0
                    ? '${numbersList[currentDisplayIndex]}'
                    : isFinished
                        ? '?'
                        : 'READY',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: isRunning
                      ? (numbersList[currentDisplayIndex] < 0 ? Colors.redAccent : Colors.greenAccent)
                      : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (isFinished) ...[
              TextField(
                controller: _answerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'আপনার উত্তর লিখুন',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: checkAnswer,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                child: const Text('উত্তর যাচাই করুন'),
              ),
              if (resultMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    resultMessage,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
            ],

            const Divider(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Digit Length:'),
                DropdownButton<int>(
                  value: digitLength,
                  items: [1, 2, 3, 4, 5].map((val) => DropdownMenuItem(value: val, child: Text('$val Digit'))).toList(),
                  onChanged: isRunning ? null : (v) => setState(() => digitLength = v!),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number Of Rows:'),
                DropdownButton<int>(
                  value: numberOfRows,
                  items: [3, 5, 10, 15, 20].map((val) => DropdownMenuItem(value: val, child: Text('$val Rows'))).toList(),
                  onChanged: isRunning ? null : (v) => setState(() => numberOfRows = v!),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Speed (sec):'),
                DropdownButton<double>(
                  value: speedInSeconds,
                  items: [0.3, 0.5, 1.0, 1.5, 2.0].map((val) => DropdownMenuItem(value: val, child: Text('${val}s'))).toList(),
                  onChanged: isRunning ? null : (v) => setState(() => speedInSeconds = v!),
                )
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: isRunning ? null : startPractice,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Flash Practice'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
