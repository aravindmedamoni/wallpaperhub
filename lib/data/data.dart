
import 'package:wallpaperhub/models/category.dart';

const String APIKEY = "563492ad6f91700001000001900744a9962149d2a813d44e91dec444";
const String url = "https://api.pexels.com/v1/curated?per_page=105&page=1";
const String searchImagesUrl = "https://api.pexels.com/v1/search?query=example+query&per_page=15&page=1";
var header = {
  'Authorization':APIKEY
};


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
