class SubCategory {
  final int idiomID;
  final int catID;
  final String idiom;
  final String define;
  final String example;
  final int fav;

  SubCategory({
    required this.define,
    required this.catID,
    required this.example,
    required this.fav,
    required this.idiom,
    required this.idiomID,
  });
}
