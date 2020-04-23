
import 'package:wallpaperhub/models/category.dart';

List<Category> getCategories(){
  List<Category> categories = [
    Category(imageUrl: "https://images.pexels.com/photos/545008/pexels-photo-545008.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",categoryName: "Street Art"),
    Category(imageUrl: "https://images.pexels.com/photos/704320/pexels-photo-704320.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500", categoryName: "Wild Life"),
    Category(imageUrl: "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&w=500", categoryName: "Nature"),
    Category(imageUrl: "https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500", categoryName: "City"),
    Category(imageUrl: "https://images.pexels.com/photos/1434819/pexels-photo-1434819.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260", categoryName: "Motivation"),
    Category(imageUrl: "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500", categoryName: "Bikes"),
    Category(imageUrl: "https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500", categoryName: "Cars"),
  ];
  return categories;
}
