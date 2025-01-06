import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});
  final void Function(String identifier) onSelectScreen;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            child: DrawerHeader(
                padding: const EdgeInsets.all(20),
                child: Row(

                  children: [
                    const Icon(
                        Icons.fastfood,
                        size: 48,
                        color: Colors.white,
                    ),
                    const SizedBox(width: 18,),
                    Text(
                      "Cooking Up...",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white
                      ),
                    )
                  ],
                )
            ),
          ),
          const SizedBox(height: 20,),
          ListTile(
            onTap: () {
              onSelectScreen("meals");
            },
            leading: const Icon(Icons.restaurant),
            title: const Text(
                "Meals",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54, fontSize: 18),
              )
          ),
          ListTile(
              onTap: () {
                onSelectScreen("filters");
              },
              leading: const Icon(Icons.settings),
              title: const Text(
                "Filters",
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54, fontSize: 18),
              )
          )

        ],
      ),
    );
  }
}
