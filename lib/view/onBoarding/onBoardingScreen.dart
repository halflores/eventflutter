import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventflutter/view/root_app.dart';
import 'package:eventflutter/constants.dart' as constants;
import 'package:eventflutter/theme/color.dart' as color;

final _currentPageNotifier = ValueNotifier<int>(0);

final List<String> _titlesList = [
  'Consultor',
  'Cómo te podemos ayudar?',
  'Y luego?'
];

final List<String> _subtitlesList = [
  'Somos un grupo de personas expertas en diferentes áreas, disponibles para ayudarte a resolver tus inquietudes y requerimientos para tu proyecto.',
  'Regístrate y describe tu inquietud o requerimiento.',
  'Recibirás diferentes propuestas para que puedas evaluar y elegir el más conveniente para ti.'
];

final List<IconData> _imageList = [
  Icons.people_outline,
  Icons.app_registration,
  Icons.mobile_friendly
];
final List<Widget> _pages = [];

List<Widget> populatePages(BuildContext context) {
  _pages.clear();
  _titlesList.asMap().forEach((index, value) => _pages.add(getPage(
      _imageList.elementAt(index), value, _subtitlesList.elementAt(index))));
  _pages.add(getLastPage(context));
  return _pages;
}

Widget _buildCircleIndicator() {
  return CirclePageIndicator(
    selectedDotColor: Colors.white,
    dotColor: Colors.white30,
    selectedSize: 8,
    size: 6.5,
    itemCount: _pages.length,
    currentPageNotifier: _currentPageNotifier,
  );
}

Widget getPage(IconData icon, String title, String subTitle) {
  return Center(
    child: Container(
      color: color.primary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 120,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  subTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 17.0),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget getLastPage(BuildContext context) {
  return Center(
    child: Container(
      color: color.primary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Icon(
                  Icons.thumb_up_outlined,
                  color: Colors.white,
                  size: 120,
                ),
              ),
              const Text(
                'Encontrarás conocimiento, habilidad y experiencia.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      setFinishedOnBoarding();
                      //pushReplacement(context, new AuthScreen());
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RootApp()));
                    },
                    child: const Text(
                      "Comenzar",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 5.0, color: Colors.blue),
                    ),
                    /*              borderSide: const BorderSide(color: Colors.white),
                    shape: const StadiumBorder(), */
                  ))
            ],
          ),
        ),
      ),
    ),
  );
}

Future<bool> setFinishedOnBoarding() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(constants.finishedOnBoarding, true);
}

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        PageView(
          children: populatePages(context),
          onPageChanged: (int index) {
            _currentPageNotifier.value = index;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildCircleIndicator(),
          ),
        )
      ],
    ));
  }
}
