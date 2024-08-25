class CartItem {
  final String id;
  final String image;
  final String title;
  final int price;
  int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    this.quantity = 1,
  });
}
