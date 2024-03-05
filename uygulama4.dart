import 'package:flutter/material.dart';

class Movies {
  late int movieId;
  late String movieName;
  late String movieImageName;
  late double moviePrice;

  Movies(this.movieId, this.movieName, this.movieImageName, this.moviePrice);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Movies>> createMovies() async {
    var moviesList = <Movies>[];

    var m1 = Movies(1, "Anatolia", "anatolia.png", 159.90);
    var m2 = Movies(2, "Django", "django.png", 99.90);
    var m3 = Movies(3, "Inception", "inception.png", 79.90);
    var m4 = Movies(4, "Interstellar", "interstellar.png", 219.90);
    var m5 = Movies(5, "The Hateful Eight", "thehatefuleight.png", 59.90);
    var m6 = Movies(6, "The Pianist", "thepianist.png", 179.90);

    moviesList.add(m1);
    moviesList.add(m2);
    moviesList.add(m3);
    moviesList.add(m4);
    moviesList.add(m5);
    moviesList.add(m6);

    return moviesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<Movies>>(
          future: createMovies(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              var moviesList = snapshot.data;
              
              return GridView.builder(
                  itemCount: moviesList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3.5,
                  ),
                  itemBuilder: (context, i){
                    var movie = moviesList[i];

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(movie: movie)));
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("images/${movie.movieImageName}"),
                            ),
                            Text(movie.movieName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            Text("${movie.moviePrice} \u20BA", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    );
                  },
              );
            } else {
              return const Center();
            }
          },
        )
    );
  }
}

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.movie}) : super(key: key);

  final Movies movie;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.movieName),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("images/${widget.movie.movieImageName}"),
              Text(widget.movie.movieName, style: const TextStyle(fontSize: 48, color: Colors.blue),),
              ElevatedButton(
                  onPressed: (){
                    print("The movie has been rented.");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Rent The Movie"),
              ),
            ],
          ),
        ),
    );
  }
}
