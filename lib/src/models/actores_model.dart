// Con esta clase puedo obtener una lista de actores de una pelicula
class Cast {
  
  List<Actor> actores = List();

  Cast();

  Cast.fromJsonMap(List<dynamic> jsonList) {

    if(jsonList == null) return;

    jsonList.forEach((item){
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });

  }

}

// Esta clase me sirve para declarar u obtener un solo actor
class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  // con este metodo constructor asigno los valores a las propiedades de mi clase Actor mediante un json
  Actor.fromJsonMap(Map<String, dynamic>json) {
    castId      = json['cast_id'];
    character   = json['character'];
    creditId    = json['credit_id'];
    gender      = json['gender'];
    id          = json['id'];
    name        = json['name'];
    order       = json['order'];
    profilePath = json['profile_path'];
  }

  getPosterImg() {
    if (profilePath == null) {
      return 'https://innmind.com/assets/placeholders/no_avatar-3d6725770296b6a1cce653a203d8f85dcc5298945b71fa7360e3d9aa4a3fc054.svg';
    } else {
      return 'https://image.tmdb.org/t/p/original$profilePath';
    }
  }
}


