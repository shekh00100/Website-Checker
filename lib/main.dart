import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WebsiteCheckerApp());
}

class WebsiteCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Website Checker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.purple,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _url = "";
  bool _isChecking = false;
  String _result = '';

  void _checkWebsiteStatus() async {
    setState(() {
      _isChecking = true;
    });

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        _showResult('$_url is up and running!');
      } else {
        _showResult('$_url is down.');
      }
    } catch (e) {
      _showResult('Error: $e');
    }

    setState(() {
      _isChecking = false;
    });
  }

  void _showResult(String message) {
    setState(() {
      _result = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Website Checker'),
      ),
      body: Center(
        // Center the main content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) {
                  _url = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter website URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              WebsiteCheckButton(
                isChecking: _isChecking,
                onPressed: _checkWebsiteStatus,
              ),
              SizedBox(height: 16.0),
              Text(
                _result,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center, // Center text horizontally
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebsiteCheckButton extends StatelessWidget {
  final bool isChecking;
  final Function onPressed;

  WebsiteCheckButton({required this.isChecking, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isChecking ? null : () => onPressed(),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).hintColor, // Use accent color
        // onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: isChecking
          ? CircularProgressIndicator()
          : Text(
              'Check Website',
              style: TextStyle(fontSize: 16.0),
            ),
    );
  }
}
