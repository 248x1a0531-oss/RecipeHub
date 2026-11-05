import 'package:flutter/material.dart';

void main() => runApp(RecipeHubApp());

class Recipe {
  final String name, category, time, image, level;
  final List<String> ingredients;
  final List<String> steps;
  final double rating;
  Recipe({required this.name, required this.category, required this.time, required this.image, required this.level, required this.ingredients, required this.steps, required this.rating});
}

List<Recipe> allRecipes = [
  Recipe(name: "Paneer Butter Masala", category: "Indian", time: "30 min", image: "🍛", level: "Medium", rating: 4.8, ingredients: ["200g Paneer", "2 Tomatoes", "1 Onion", "Butter", "Cream", "Garam Masala"], steps: ["Onion, Tomato fry cheyali", "Masala paste chesi cook cheyali", "Paneer vesi 5 min cook cheyali", "Cream vesi serve cheyali"]),
  Recipe(name: "Veg Biryani", category: "Indian", time: "45 min", image: "🍚", level: "Hard", rating: 4.9, ingredients: ["2 Cups Basmati Rice", "Mixed Vegetables", "Curd", "Biryani Masala", "Mint Leaves"], steps: ["Rice 70% cook cheyali", "Vegetables tho masala cheyali", "Layering chesi dum lo pettali", "15 min low flame lo cook cheyali"]),
  Recipe(name: "Pasta Alfredo", category: "Italian", time: "25 min", image: "🍝", level: "Easy", rating: 4.7, ingredients: ["200g Pasta", "Milk", "Cheese", "Garlic", "Butter", "Pepper"], steps: ["Pasta boil cheyali", "Butter lo garlic fry cheyali", "Milk, Cheese vesi sauce cheyali", "Pasta kalipi serve cheyali"]),
  Recipe(name: "Chocolate Cake", category: "Dessert", time: "50 min", image: "🍰", level: "Medium", rating: 4.9, ingredients: ["1 Cup Maida", "Cocoa Powder", "Sugar", "Eggs", "Butter", "Baking Powder"], steps: ["Dry ingredients kalapali", "Wet ingredients kalipi mix cheyali", "180C lo 30 min bake cheyali", "Cool ayyaka serve cheyali"]),
  Recipe(name: "Masala Dosa", category: "South Indian", time: "20 min", image: "🥞", level: "Medium", rating: 4.8, ingredients: ["Dosa Batter", "Potato", "Onion", "Mustard", "Curry Leaves", "Turmeric"], steps: ["Potato masala prepare cheyali", "Dosa pan lo thin ga veyali", "Masala petti fold cheyali", "Chutney tho serve cheyali"]),
  Recipe(name: "Fruit Salad", category: "Healthy", time: "10 min", image: "🥗", level: "Easy", rating: 4.5, ingredients: ["Apple", "Banana", "Grapes", "Honey", "Lemon Juice"], steps: ["Fruits anni cut cheyali", "Honey, Lemon kalapali", "Fridge lo 10 min pettali", "Chilled ga serve cheyali"]),
];

class RecipeHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'RecipeHub', theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true), debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = "";
  String selectedCat = "All";
  Set<int> favs = {};
  List<String> cats = ["All", "Indian", "Italian", "Dessert", "South Indian", "Healthy"];

  @override
  Widget build(BuildContext context) {
    List<Recipe> filtered = allRecipes.where((r) {
      bool matchSearch = r.name.toLowerCase().contains(search.toLowerCase());
      bool matchCat = selectedCat == "All" || r.category == selectedCat;
      return matchSearch && matchCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("🍳 RecipeHub"), backgroundColor: Colors.orange, foregroundColor: Colors.white, centerTitle: true),
      body: Column(children: [
        Padding(padding: EdgeInsets.all(12), child: TextField(onChanged: (v) => setState(() => search = v), decoration: InputDecoration(hintText: "Search recipes... Paneer, Cake...", prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
        Container(height: 40, child: ListView(scrollDirection: Axis.horizontal, children: cats.map((c) => Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: ChoiceChip(label: Text(c), selected: selectedCat == c, onSelected: (_) => setState(() => selectedCat = c), selectedColor: Colors.orange.shade200))).toList())),
        Expanded(child: filtered.isEmpty ? Center(child: Text("No recipes found")) : ListView.builder(itemCount: filtered.length, itemBuilder: (ctx, i) {
          var r = filtered[i]; int realIndex = allRecipes.indexOf(r);
          return Card(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: ListTile(leading: CircleAvatar(child: Text(r.image, style: TextStyle(fontSize: 22)), backgroundColor: Colors.orange.shade100, radius: 28), title: Text(r.name, style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text("${r.category} • ${r.time} • ⭐ ${r.rating}"), trailing: IconButton(icon: Icon(favs.contains(realIndex) ? Icons.favorite : Icons.favorite_border, color: Colors.red), onPressed: () => setState(() { favs.contains(realIndex) ? favs.remove(realIndex) : favs.add(realIndex); })), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(recipe: r)))));
        })),
      ]),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Recipe recipe;
  DetailPage({required this.recipe});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(recipe.name), backgroundColor: Colors.orange, foregroundColor: Colors.white), body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Center(child: Text(recipe.image, style: TextStyle(fontSize: 80))),
      SizedBox(height: 10),
      Center(child: Text(recipe.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
      Center(child: Text("${recipe.category} • ${recipe.time} • ${recipe.level} • ⭐ ${recipe.rating}", style: TextStyle(color: Colors.grey[600]))),
      SizedBox(height: 20),
      Text("🧾 Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ...recipe.ingredients.map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 3), child: Row(children: [Icon(Icons.check_circle, color: Colors.green, size: 18), SizedBox(width: 8), Text(e)]))),
      SizedBox(height: 16),
      Text("👩‍🍳 Steps:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ...recipe.steps.asMap().entries.map((e) => Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 13, child: Text("${e.key + 1}")), SizedBox(width: 10), Expanded(child: Text(e.value, style: TextStyle(fontSize: 15)))]))),
      SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yummy! ${recipe.name} added to Cook Today"))); }, child: Text("Cook Today"), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, padding: EdgeInsets.all(14)))),
    ]))));
  }
}
