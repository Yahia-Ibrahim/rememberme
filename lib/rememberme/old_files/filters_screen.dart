import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rememberme/rememberme/widgets/main_drawer.dart';

import 'filters_providers.dart';

class FiltersScreen extends ConsumerStatefulWidget {


  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
  
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("filters"),
        backgroundColor: Colors.blue,
      ),
      body: const Column(
        children: [

        ],
      ),
    );
  }
}
