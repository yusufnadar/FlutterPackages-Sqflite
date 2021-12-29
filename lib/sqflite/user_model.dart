class UserModel{

  var id;
  var name;

  UserModel({this.id,this.name});


  factory UserModel.fromJson(json)=>UserModel(
    id: json['id'],
    name:json['name']
  );

}

