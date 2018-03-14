
class Repo {

  final int id;

  final String name;

  final String fullName;

  final String description;

  Repo(this.id, this.name, this.fullName, this.description);

  Repo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        fullName = json['full_name'],
        description = json['description'];
}