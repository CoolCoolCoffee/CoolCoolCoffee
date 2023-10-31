class Menu{

}

class StarbucksAcno{
  final String id;
  final String ice;
  final String hot;

  StarbucksAcno({
    required this.id,
    required this.ice,
    required this.hot,
  });

  factory StarbucksAcno.formJson(Map<dynamic,dynamic> json) => StarbucksAcno(
    id: json['id'],
    ice: json['ice'],
    hot: json['hot'],
  );
  Map<String,dynamic> toJson() => {
    "id": id,
    "ice": ice,
    "hot": hot,
  };
}