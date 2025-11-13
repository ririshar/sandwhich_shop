import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  final TextEditingController _noteController = TextEditingController();
  String _note = '';
  String _selectedSize = 'Footlong'; // <-- new state for selected sandwich size

  void _increaseQuantity() {
    // read current note before updating quantity
    _note = _noteController.text.trim();
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    // read current note before updating quantity
    _note = _noteController.text.trim();
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Notes input field
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Add notes (e.g. "no onions", "extra pickles")',
                  labelText: 'Order note',
                  border: OutlineInputBorder(), // adds a border
                  isDense: true,
                ),
                maxLines: 1,
              ),
            ),
            // show the current note for this order
            if (_note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Note: $_note',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ),

            // order item now shows selected size
            OrderItemDisplay(
              _quantity,
              _selectedSize,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      _quantity < widget.maxQuantity ? _increaseQuantity : null,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label:
                      const Text('Add', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  icon: const Icon(Icons.remove, color: Colors.white),
                  label: const Text('Remove',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Slider-style toggle between Footlong and Six-inch (light pink)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ToggleButtons(
                isSelected: [
                  _selectedSize == 'Footlong',
                  _selectedSize == 'Six-inch'
                ],
                onPressed: (int index) {
                  setState(() {
                    _selectedSize = index == 0 ? 'Footlong' : 'Six-inch';
                  });
                },
                borderRadius: BorderRadius.circular(8),
                fillColor:
                    Colors.pink.shade100, // light pink fill when selected
                selectedColor: Colors.white,
                color: Colors.black87,
                constraints: const BoxConstraints(minWidth: 120, minHeight: 40),
                children: const [
                  Text('Footlong'),
                  Text('Six-inch'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // change to 100, 150, 300 to experiment
      height: 80, // make smaller to force overflow
      color: Colors.pink, // visible background
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        '$quantity $itemType sandwich(es): ${'🥪' * quantity}',
        style: const TextStyle(color: Colors.white, fontSize: 16),
        maxLines: 2,
        overflow: TextOverflow.ellipsis, // see truncated text when too big
        textAlign: TextAlign.center,
      ),
    );
  }
}

//class MyApp extends StatelessWidget {
//  const MyApp({super.key});

// This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Sandwich Shop',
//      theme: ThemeData(
//        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//        useMaterial3: true,
//      ),
//      home: const MyHomePage(title: 'Sandwich shop'),
//    );
//  }
//}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Sandwich Shop!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
