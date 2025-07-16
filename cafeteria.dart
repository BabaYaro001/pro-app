class CafeteriaItem {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category; // e.g. Snack, Meal, Drink
  final String available; // Yes/No

  CafeteriaItem({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.available,
  });

  factory CafeteriaItem.fromMap(Map<String, dynamic> map) => CafeteriaItem(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        category: map['category'],
        available: map['available'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'available': available,
      };
}