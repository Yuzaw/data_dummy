import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Proceed with login logic only if the form is valid
                    String email = emailController.text;
                    String password = passwordController.text;
                    print('Email: $email, Password: $password');

                    // Navigate to the home page if login is successful
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [
    Product(name: 'Bando 08', price: 2000),
    Product(name: 'Bando 2 Cagak', price: 3000),
    Product(name: 'Bando 20 DN', price: 1000),
    Product(name: 'Bando 3 Daun', price: 2000),
    Product(name: 'Bando 30', price: 2000),
    Product(name: 'Bando 35', price: 2000),
    Product(name: 'Bando 47', price: 3000),
    Product(name: 'Bando 50', price: 3000),
    Product(name: 'Bando 75', price: 7000),
  ];

  TextEditingController editingController = TextEditingController();
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: ProductSearch(products));
              },
              child: Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length * 2 - 1,
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return Divider();
          }

          final productIndex = index ~/ 2;

          return Dismissible(
            key: Key(products[productIndex].name),
            onDismissed: (direction) {
              setState(() {
                products.removeAt(productIndex);
              });
            },
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
              alignment: Alignment.centerRight,
            ),
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${productIndex + 1}.',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        '${products[productIndex].name}\nHarga: Rp.${products[productIndex].price}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        products.removeAt(productIndex);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProductDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addProductDialog(BuildContext context) {
    String newProductName = '';
    int newProductPrice = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a Product'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  newProductName = value;
                },
                decoration: InputDecoration(labelText: 'Product'),
              ),
              TextField(
                onChanged: (value) {
                  newProductPrice = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  products.add(
                    Product(name: newProductName, price: newProductPrice),
                  );
                  filteredProducts = products;
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Product {
  String name;
  int price;

  Product({required this.name, required this.price});
}

class ProductSearch extends SearchDelegate<String> {
  final List<Product> products;

  ProductSearch(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show the results based on the search
    final results = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types
    final suggestionList = products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResults(suggestionList);
  }

  Widget _buildSearchResults(List<Product> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].name),
          onTap: () {
            // Handle item selection
            close(context, results[index].name);
          },
        );
      },
    );
  }
}
