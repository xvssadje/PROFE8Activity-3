import 'package:flutter/material.dart';

void main() {
  runApp(HearingAidShopApp());
}

class HearingAidShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hearing Aid Center',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: LoginPage(),
    );
  }
}

// -------------------- LOGIN PAGE --------------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.hearing, size: 80, color: Colors.teal),
              SizedBox(height: 10),
              Text("Hearing Aid Center",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailCtl,
                      decoration: InputDecoration(labelText: "Email"),
                      validator: (value) =>
                          value!.contains("@") ? null : "Enter a valid email",
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: passCtl,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Enter password" : null,
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => HomePage()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)),
                      child: Text("Login"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => RegisterPage()));
                      },
                      child: Text("Create an Account"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- REGISTRATION PAGE --------------------
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();
  final confirmCtl = TextEditingController();
  String? role = "User";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtl,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: emailCtl,
                decoration: InputDecoration(labelText: "Email"),
                validator: (v) => v!.contains("@") ? null : "Enter valid email",
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: passCtl,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v!.length < 4 ? "Min 4 characters" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: confirmCtl,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (v) =>
                    v != passCtl.text ? "Passwords do not match" : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: role,
                items: ["Admin", "User"].map((r) {
                  return DropdownMenuItem(value: r, child: Text(r));
                }).toList(),
                onChanged: (v) => setState(() => role = v),
                decoration: InputDecoration(labelText: "Select Role"),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Registration Successful!")));
                    Navigator.pop(context);
                  }
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- HOME PAGE --------------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [
    {"name": "Basic Hearing Aid", "price": 4999.00, "img": Icons.hearing},
    {
      "name": "Smart Hearing Aid",
      "price": 8999.00,
      "img": Icons.hearing_disabled
    },
    {"name": "Bluetooth Hearing Aid", "price": 12999.00, "img": Icons.wifi},
    {
      "name": "Rechargeable Hearing Aid",
      "price": 15999.00,
      "img": Icons.battery_charging_full
    },
  ];

  List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${product['name']} added to cart")));
  }

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hearing Aid Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => logout(context),
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CartPage(cart: cart)));
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: .85),
        itemBuilder: (context, index) {
          final p = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReservationPage(selectedProduct: p)));
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(p["img"], size: 60, color: Colors.teal),
                  SizedBox(height: 8),
                  Text(p["name"],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("₱${p["price"].toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.teal)),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => addToCart(p), child: Text("Add to Cart"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------- CART PAGE --------------------
class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total =>
      widget.cart.fold(0, (sum, item) => sum + (item['price'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: widget.cart.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: widget.cart
                          .map((item) => ListTile(
                                leading: Icon(item['img'], color: Colors.teal),
                                title: Text(item['name']),
                                subtitle: Text(
                                    "₱${item['price'].toStringAsFixed(2)}"),
                              ))
                          .toList(),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("₱${total.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.payment),
                    label: Text("Pay Now"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(double.infinity, 50)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReservationPage(selectedProduct: {
                                    "name": "Cart Total",
                                    "price": total
                                  })));
                    },
                  )
                ],
              ),
            ),
    );
  }
}

// -------------------- RESERVATION PAGE --------------------
class ReservationPage extends StatefulWidget {
  final Map<String, dynamic>? selectedProduct;
  ReservationPage({this.selectedProduct});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtl = TextEditingController();
  final noteCtl = TextEditingController();
  bool payWithGCash = false;
  DateTime? resDate;
  TimeOfDay? resTime;

  @override
  Widget build(BuildContext context) {
    final product = widget.selectedProduct;

    return Scaffold(
      appBar: AppBar(title: Text("Reservation & Payment")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (product != null) ...[
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.hearing, size: 60, color: Colors.teal),
                      Text(product["name"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("₱${product["price"].toStringAsFixed(2)}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.teal[700])),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
              TextFormField(
                controller: nameCtl,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (v) => v!.isEmpty ? "Enter your name" : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: noteCtl,
                decoration:
                    InputDecoration(labelText: "Special Request / Note"),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  resDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  setState(() {});
                },
                child: Text(resDate == null
                    ? "Pick Reservation Date"
                    : "Date: ${resDate!.month}/${resDate!.day}/${resDate!.year}"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  resTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  setState(() {});
                },
                child: Text(resTime == null
                    ? "Pick Reservation Time"
                    : "Time: ${resTime!.format(context)}"),
              ),
              SizedBox(height: 12),
              SwitchListTile(
                title: Text("Pay with GCash"),
                value: payWithGCash,
                onChanged: (v) => setState(() => payWithGCash = v),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "✅ Reservation Confirmed for ${nameCtl.text}\n📦 Item: ${product?["name"] ?? "Cart Total"}\n💰 Amount: ₱${product?["price"].toStringAsFixed(2)}\n📅 Date: ${resDate?.month}/${resDate?.day}/${resDate?.year}\n⏰ Time: ${resTime?.format(context) ?? 'N/A'}\n💳 Payment: ${payWithGCash ? "GCash" : "Cash"}")));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 50)),
                child: Text("Confirm Reservation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
