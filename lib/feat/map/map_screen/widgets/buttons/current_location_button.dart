import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../bloc/event.dart';
import '../../bloc/map_bloc.dart';


class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 170,
      right: 0,
      child: GestureDetector(
        onTap: () => context.read<MapBloc>().add(GoToUserLocation()),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/location.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
