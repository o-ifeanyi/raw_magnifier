import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _blueContainerOffsetCtrl;
  late AnimationController _textScaleCtrl;
  late AnimationController _textOffsetOutCtrl;
  late AnimationController _textOffsetInCtrl;
  late AnimationController _magnifierOffsetCtrl;
  late AnimationController _typeWriterCtrl;

  late Animation<double> _blueContainerOffset;
  late Animation<double> _textScale;
  late Animation<Offset> _textOffsetOut;
  late Animation<Offset> _textOffsetIn;
  late Animation<Offset> _magnifierOffset;
  late Animation<int> _typeWriter;

  bool _animationsDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.of(context).size;
    _blueContainerOffsetCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _textScaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _magnifierOffsetCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _textOffsetOutCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _textOffsetInCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _typeWriterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _blueContainerOffset = Tween<double>(begin: 0.0, end: -(size.width / 2))
        .animate(_blueContainerOffsetCtrl);

    _textScale = Tween<double>(begin: 0.0, end: 1.0).animate(_textScaleCtrl);

    _textOffsetOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -4))
        .animate(
            CurvedAnimation(parent: _textOffsetOutCtrl, curve: Curves.easeOut));

    _textOffsetIn = Tween<Offset>(begin: const Offset(0, -2), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _textOffsetInCtrl, curve: Curves.fastOutSlowIn));
    _magnifierOffset =
        Tween<Offset>(begin: const Offset(-3, 0), end: const Offset(3, 0))
            .animate(_magnifierOffsetCtrl);
    _typeWriter = StepTween(begin: 0, end: 11).animate(_typeWriterCtrl);

    Future.delayed(const Duration(seconds: 1)).then((_) {
      _blueContainerOffsetCtrl.forward();
    });

    _blueContainerOffset.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textScaleCtrl.forward();
      }
    });
    _textScaleCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _magnifierOffsetCtrl.forward();
      }
    });
    _magnifierOffsetCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textOffsetOutCtrl.forward();
      }
    });
    _textOffsetOutCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textOffsetInCtrl.forward();
      }
    });
    _textOffsetInCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          setState(() {
            _animationsDone = true;
            _typeWriterCtrl.forward();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: size.height / 3,
              width: size.width,
              color: Colors.white,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SlideTransition(
                    position: _textOffsetOut,
                    child: ScaleTransition(
                      scale: _textScale,
                      child: const Text(
                        "RawMagnifier",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Color(0XFF06559B),
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _magnifierOffset,
                    child: const RawMagnifier(
                      size: Size(100, 100),
                      magnificationScale: 2,
                      decoration: MagnifierDecoration(
                        shape: CircleBorder(
                          side: BorderSide(color: Color(0XFF06559B), width: 3),
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _textOffsetIn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/logo.png"),
                        const SizedBox(width: 15),
                        const Text(
                          "Flutter",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 50,
                            color: Color(0XFF777578),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_animationsDone)
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      alignment: Alignment.bottomCenter,
                      child: AnimatedBuilder(
                          animation: _typeWriter,
                          builder: (context, child) {
                            final text =
                                "flutter.dev".substring(0, _typeWriter.value);
                            return SizedBox(
                              width: 100,
                              child: Text(
                                text,
                                style: const TextStyle(
                                    fontSize: 20, color: Color(0xFF44B5E7)),
                                textAlign: TextAlign.start,
                              ),
                            );
                          }),
                    ),
                  AnimatedBuilder(
                    animation: _blueContainerOffset,
                    builder: (context, child) {
                      return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Positioned(
                            left: _blueContainerOffset.value,
                            child: Container(
                              height: size.height / 3,
                              width: size.width / 2,
                              color: const Color(0xFF89DEF9),
                            ),
                          ),
                          Positioned(
                            right: _blueContainerOffset.value,
                            child: Container(
                              height: size.height / 3,
                              width: size.width / 2,
                              color: const Color(0xFF89DEF9),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // For some reason the widgets moved by ScaleTransition
          // are still visible outside the boundraies of the stack hence this part
          // Comment it out to see the effect
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: size.height / 3,
              width: size.width,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
