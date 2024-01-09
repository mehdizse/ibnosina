class LoginModel {
  final String token;
  final String tel;
  final int patientId;
  final String name;
  final String password;


  LoginModel(this.token, this.tel,this.patientId,this.name,this.password);

  LoginModel.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        tel = json['tel'],
        patientId=json['patient_id'],
        name=json["name"],
        password=json["password"];

  Map<String, dynamic> toJson() =>
      {
        'token': token,
        'tel': tel,
        'patient_id' :patientId,
        'name':name,
        'password':password,
      };
}