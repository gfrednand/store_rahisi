import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeRahisi/pages/settings/help_screen.dart';
import 'package:storeRahisi/providers/index.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final String toolbarname;

  SettingsPage({Key key, this.toolbarname}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Setting(toolbarname);
}

class Setting extends State<SettingsPage> {
  bool switchValue = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String toolbarname;

  Setting(this.toolbarname);

  @override
  Widget build(BuildContext context) {
    SettingsModel settingModel = Provider.of<SettingsModel>(context);
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1
        .copyWith(color: theme.textTheme.caption.color);

    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Settings', style: Theme.of(context).textTheme.headline6),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              new Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signup_screen()));*/
                      },
                      child: new Text(
                        'Notification',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: theme.textTheme.headline6.color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Card(
                    child: Container(
                  padding: EdgeInsets.only(
                      left: 10.0, top: 5.0, bottom: 5.0, right: 5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.notifications,
                            color: theme.textTheme.headline6.color,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5.0),
                          ),
                          Text(
                            'Notification',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: theme.textTheme.headline6.color,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                          value: settingModel.isNotificationOn,
                          onChanged: (bool value) {
                            setState(() {
                            
                                settingModel.updateNotification(value);
                            });
                          }),
                    ],
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
              ),
              new Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                  children: <Widget>[
                    _verticalD(),
                    new GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signup_screen()));*/
                      },
                      child: new Text(
                        'Legal',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: theme.textTheme.headline6.color,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Card(
                    child: Container(
                  //  padding: EdgeInsets.only(left: 10.0,top: 15.0,bottom: 5.0,right: 5.0),

                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 15.0, bottom: 15.0),
                          child: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.assignment,
                                  color: theme.textTheme.headline6.color,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                ),
                                Text(
                                  'Terms Off Use',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: theme.textTheme.headline6.color,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              const url =
                                  'https://store-rahisi.web.app/terms-conditions.html';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not lauch $url';
                              }
                            },
                          )),
                      Divider(
                        height: 5.0,
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 15.0, bottom: 15.0),
                          child: GestureDetector(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.lock_outline,
                                    color: theme.textTheme.headline6.color,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                  ),
                                  Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        color: theme.textTheme.headline6.color),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                const url =
                                    'https://store-rahisi.web.app/privacy-policy.html';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not lauch $url';
                                }
                              })),
                    ],
                  ),
                )),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Dark Mode',
                      style: theme.textTheme.bodyText1,
                    ),
                    Spacer(),
                    Switch(
                        value: settingModel.isDarkModeOn,
                        onChanged: (booleanValue) {
                          setState(() {
                            settingModel.updateTheme(booleanValue);
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        /*_scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('You selected: $value')
        ));*/
      }
    });
  }

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
      );

  erticalD() => Container(
        margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
      );

  bool a = true;
  String mText = "Press to hide";
}
