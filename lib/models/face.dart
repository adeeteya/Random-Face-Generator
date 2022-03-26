class Face {
  String gender;
  String imageUrl;
  int age;
  Face(this.gender, this.imageUrl, this.age);
  factory Face.fromJson(Map<String, dynamic> json) {
    return Face(json['gender'], json['image_url'], json['age']);
  }
}
