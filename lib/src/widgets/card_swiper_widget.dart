import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {

  final List<Pelicula> items;

  //Se coloca como obligatorio de que manden la lista
  CardSwiper({@required this.items});

  @override
  Widget build(BuildContext context) {
    //Nos permite saber las dimensiones del telefono que corre la app
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index){
          items[index].uniqueId = '${items[index].id}-tarjeta';
          return Hero(
            tag: items[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: items[index]),
                child: FadeInImage(
                  image: NetworkImage(items[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: items.length,          
      ),
    );
  }
}