class PostModel {
  int? _userId;
  int? _id;
  String? _title;
  String? _body;
  int? _fav;

  PostModel({int? userId, int? id, String? title, String? body, int? fav}) {
    if (userId != null) {
      this._userId = userId;
    }
    if (id != null) {
      this._id = id;
    }
    if (title != null) {
      this._title = title;
    }
    if (body != null) {
      this._body = body;
    }
    if (fav != null) {
      this._fav = fav;
    }
  }

  int? get userId => _userId;

  set userId(int? userId) => _userId = userId;

  int get id => _id ?? -1;

  set id(int? id) => _id = id;

  String? get title => _title;

  set title(String? title) => _title = title;

  String? get body => _body;

  set body(String? body) => _body = body;

  set fav(int? fav) => _fav = fav;

  int get fav => _fav ?? 0;

  bool get isFavourite => fav == 0 ? false : true;

  PostModel.fromJson(Map<String, dynamic> json) {
    _userId = json['userId'];
    _id = json['id'];
    _title = json['title'];
    _body = json['body'];
    _fav = json['fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['id'] = this._id;
    data['title'] = this._title;
    data['body'] = this._body;
    data['fav'] = this._fav;
    return data;
  }

  @override
  bool operator ==(Object other) {
    return other is PostModel && other.id == id;
  }
}
