import 'package:capstone/business_logic/bloc/bloc.dart';
import 'package:capstone/data/data_providers/data_providers.dart';
import 'package:capstone/data/models/login.dart';
import 'package:capstone/presentation/screens/screens.dart';
import 'package:capstone/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            loadingCommon(context);
          } else if (state is LoginInvalid) {
            Navigator.of(context).pop();
          } else if (state is LoginAdminLoaded) {
            _loginAdminLoaded(context);
          } else if (state is LoginManagerLoaded) {
            _loginManagerLoaded(context);
          } else if (state is LoginError) {
            _loginError(context, state);
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: LoginForm(
            size: size,
          ),
        ),
      ),
    );
  }
}

// ignore: todo
//TODO Stuff
_loginError(BuildContext context, LoginError state) {
  showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Error'),
        content: Text(state.message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      );
    },
  );
}

_loginAdminLoaded(BuildContext context) {
  BlocProvider.of<UserBloc>(context).add(UserFetchEvent(
    searchValue: "",
    searchField: "",
    fetchNext: 0,
    pageNum: 0,
    statusId: StatusIntBase.All,
  ));
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (BuildContext context) => ScreenManager()),
    ModalRoute.withName('/'),
  );
}

_loginManagerLoaded(BuildContext context) {
  BlocProvider.of<ShelfBloc>(context).add(ShelfFetchEvent(
    storeId: "",
    shelfName: "",
    fetchNext: 100,
    pageNum: 0,
    statusId: 0,
  ));
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (BuildContext context) => ScreenShelf()),
    ModalRoute.withName('/'),
  );
}

// ignore: todo
//TODO View
class LoginForm extends StatefulWidget {
  final Size size;

  const LoginForm({Key key, @required this.size}) : super(key: key);
  @override
  LoginFormState createState() {
    return LoginFormState(size);
  }
}

class LoginFormState extends State<LoginForm> {
  final Size size;
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  LoginFormState(this.size);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/cffe.png",
                  color: kPrimaryColor,
                  height: size.width * 0.4,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: kDefaultPadding, right: kDefaultPadding),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          LoginTextField(
                            hintText: "Username",
                            controller: _username,
                            obscureText: false,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          PasswordTextField(
                            hintText: 'Password',
                            controller: _password,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is LoginInvalid) {
                                return LoginInvalidTextField(state.message);
                              }
                              return Text("");
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          PrimaryButton(
                            text: "Login",
                            onPressed: () {
                              print("==========================");
                              if (_formKey.currentState.validate()) {
                                LoginModel loginModel = new LoginModel(
                                  userName: _username.text,
                                  passWord: _password.text,
                                );
                                BlocProvider.of<LoginBloc>(context)
                                    .add(LoginClickLoginButton(loginModel));
                              }
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "If you don't have an account , contact your Admin",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: kCaptionTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class PasswordTextField extends StatefulWidget {
//   PasswordTextField(this._validate, this._labelText, this._controller);
//   final String _validate;
//   final String _labelText;
//   final TextEditingController _controller;
//   @override
//   _PasswordTextFieldState createState() => _PasswordTextFieldState(
//       this._validate, this._labelText, this._controller);
// }

// class _PasswordTextFieldState extends State<PasswordTextField> {
//   _PasswordTextFieldState(this._validate, this._labelText, this._controller);
//   final String _validate;
//   final String _labelText;
//   final TextEditingController _controller;

//   bool _obscureText = true;
//   void _toggle() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           TextFormField(
//             controller: _controller,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: _labelText,
//               contentPadding: EdgeInsets.fromLTRB(5, 0, 10, 0),
//             ),
//             obscureText: _obscureText,
//             validator: (value) {
//               switch (_labelText) {
//                 case 'Password':
//                   if (value.isEmpty) {
//                     return _validate;
//                   }
//                   break;

//                 default:
//               }
//               return null;
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.remove_red_eye),
//             onPressed: () {
//               _toggle();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class LoginInvalidTextField extends StatelessWidget {
  final String message;

  const LoginInvalidTextField(this.message);

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }
    return Text("");
  }
}
