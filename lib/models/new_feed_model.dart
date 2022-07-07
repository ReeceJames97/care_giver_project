class NewFeedModel{
  //attributes = fields in table
  int? _faid;
  String? _name;
  String? _instruction;
  String? _caution;
  dynamic? _photo;

  NewFeedModel(dynamic obj){
    _faid = obj['faid'];
    _name = obj['name'];
    _instruction = obj['instruction'];
    _caution = obj['caution'];
    _photo = obj['photo'];
  }
  NewFeedModel.fromMap(Map<String,dynamic> data){
    _faid = data['faid'];
    _name = data['name'];
    _instruction = data['instruction'];
    _caution = data['caution'];
    _photo = data['photo'];
  }
  Map<String, dynamic> toMap() => {'faid' : _faid,'name' : _name,'instruction' : _instruction, 'caution' : _caution, 'photo':_photo};

  int get faid => _faid!;
  String get name => _name!;
  String get instruction => _instruction!;
  String get caution => _caution!;
  dynamic get photo => _photo;
}