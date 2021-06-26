import 'package:flutter/material.dart';
import 'package:flutter_form_validation/Constent.dart';
import 'package:flutter_form_validation/components/default_button.dart';
import 'package:flutter_form_validation/components/form_error.dart';
import 'package:flutter_form_validation/helper/keyboard.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter form validation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String password;
  String email;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void showSnackBar(BuildContext con,String s) {
    final snackBar = SnackBar(
      content: Text(s),
      backgroundColor: const Color(0xffae00f0),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  buildEmailFormField(),
                  SizedBox(height: 30),
                  buildPasswordFormField(),
                  SizedBox(height: 30),
                  FormError(errors: errors),
                  SizedBox(height: 20),
                  DefaultButton(
                    text: "Continue",
                    press: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        KeyboardUtil.hideKeyboard(context);
                        showSnackBar(context,'ok');

                        // Navigator.pushNamed(context, HomePage.routeName);
                      }
                    },
                  ),
                ],
              ),
            )
        ),
      ),

    );

  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        border: OutlineInputBorder(),
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock_outline),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {

      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter email address";
        }else if(!emailValidatorRegExp.hasMatch(value)){
          return "Enter valid email address";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.mail_outline),
      ),
    );
  }
}
