import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'THis is for title',
    home: MyApp(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<MyApp> {
  var _currencies = ['Rupees', 'Dollar', 'Pounds'];
  final _minPadding = 5.0;

  var _currentSelectedValue = '';

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentSelectedValue = _currencies[0];
  }

  TextEditingController principalcontroller = TextEditingController();
  TextEditingController roicontroller = TextEditingController();
  TextEditingController termcontroller = TextEditingController();

  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalcontroller,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      validator: (String value) {
                        if (value.isEmpty)
                          return 'Please enter Principal amount...';
                      },
                      decoration: InputDecoration(
                        labelText: 'Principle Amount',
                        hintText: 'Enter Principal amount in Rupees',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    )),
                Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: roicontroller,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      validator: (String value){
                        if(value.isEmpty)
                          return 'ROI is mandatory!!!';
                      },
                      decoration: InputDecoration(
                        labelText: 'Rate of interest',
                        hintText: 'In Percent',
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    )),
                Padding(
                    padding:
                    EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: textStyle,
                              controller: termcontroller,
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              validator: (String value){
                                if(value.isEmpty)
                                  return 'Term is mandatory';
                              },
                              decoration: InputDecoration(
                                labelText: 'Term',
                                hintText: 'In Year',
                                labelStyle: textStyle,
                                errorStyle: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontSize: 15.0,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            )),
                        Container(
                          width: _minPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                              items: _currencies.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                _onDropDownItemSelected(newValueSelected);
                              },
                              value: _currentSelectedValue,
                            )),
                      ],
                    )),
                Padding(
                  padding:
                  EdgeInsets.only(top: _minPadding, bottom: _minPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Calculate',
                              textScaleFactor: 1.3,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          )),
                      Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Reset',
                              textScaleFactor: 1.3,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_minPadding * 2),
                  child: Text(
                    this.displayResult,
                    style: textStyle,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentSelectedValue = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principle = double.parse(principalcontroller.text);
    double roi = double.parse(roicontroller.text);
    double term = double.parse(termcontroller.text);

    double totalAmount = principle + ((principle * roi * term) / 100);

    String result =
        'After $term years, your investment will be worth $totalAmount $_currentSelectedValue';
    return result;
  }

  void _reset() {
    principalcontroller.text = '';
    roicontroller.text = '';
    termcontroller.text = '';
    displayResult = '';
    _currentSelectedValue = _currencies[0];
  }
}
