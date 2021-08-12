import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gosip/pickers/user_image_picker.dart';
class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn,this.isLoading);
  final bool isLoading;
  final void Function(String email,String password,String userName,File image,bool isLogin,BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin=true;
  String _userEmail='';
  String _userName='';
  String _userPassword='';
  final _formKey=GlobalKey<FormState>();
  File _userImageFile;
  void _pickedImage (File image){
    _userImageFile=image;
  }
  void _trySubmit()
  {
   final isValid= _formKey.currentState.validate();
   FocusScope.of(context).unfocus();
  if(_userImageFile==null && !_isLogin)
    {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image',

        ),backgroundColor: Colors.red,
      ),
      );
      return;
    }
   if(isValid){
     _formKey.currentState.save();
     widget.submitFn(
       _userEmail.trim(),_userPassword.trim(),_userName.trim(),_userImageFile,_isLogin,context
     );
   }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Card(margin:EdgeInsets.all(20),child: SingleChildScrollView(
      child:Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(!_isLogin) UserImagePicker(_pickedImage),
              TextFormField(
                key: ValueKey('Email'),
                validator: (value){
                  if(value.isEmpty || !value.contains('@'))
                    {
                      return 'Please enter a valid email address';
                    }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                onSaved: (value){
                  _userEmail=value;
                },
              ),
              if(! _isLogin)
              TextFormField(
                key: ValueKey('Username'),
                validator: (value){
                  if(value.isEmpty || value.length<4){
                    return 'Please enter at least 4 characters';

                  }
                  return null;
                },



                decoration: InputDecoration(
                  labelText: 'Username'
                ),
                onSaved: (value){
                  _userName=value;
                },
              ),
              TextFormField(
                key: ValueKey('Password'),
                  validator: (value){
                    if(value.isEmpty || value.length<7 )
                      {
                        return 'Password must be at least 7 characters long';
                      }
                    return null;
                  },

                  decoration:InputDecoration(
                    labelText: 'Password',
                  ),
                onSaved: (value){
                    _userPassword=value;
                },
                ),

              SizedBox(
                height: 12,
              ),
              if(widget.isLoading)
                CircularProgressIndicator(),
              if(!widget.isLoading)
                RaisedButton(
                child: Text(_isLogin?'Login':'SignUp'),
                color: Theme.of(context).primaryColor,
                onPressed:_trySubmit,
              ),
              if(!widget.isLoading)
              FlatButton(child: Text(_isLogin?'Create New account':'I already have an account'),

              onPressed: (){
                setState(() {
                  _isLogin=!_isLogin;
                });
              },)
            ],
          ),
        ),
      ),
    ),),);
  }
}
