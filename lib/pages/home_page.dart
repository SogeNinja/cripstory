import 'package:cripstory/models/asset_model.dart';
import 'package:cripstory/services/crypto_api.dart';
import 'package:cripstory/widgets/infinite_list_widget.dart';
import 'package:cripstory/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Asset> notCryptos = [];
  List<Asset> cryptos = [];
  Future<void>? _assetsFuture;
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _assetsFuture = getAllAssets(Provider.of<AssetCollection>(context, listen: false));
  }

  void distribudeAssets(List<Asset> allAssets){
    notCryptos = [];
    cryptos = [];
    for (Asset asset in allAssets) {
      if (asset.isCrypto == 0 && asset.name.toLowerCase().contains(searchTerm.toLowerCase())) {
        notCryptos.add(asset);
      } else if (asset.isCrypto == 1 && asset.name.toLowerCase().contains(searchTerm.toLowerCase())) {
        cryptos.add(asset);
      }
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Consumer<AssetCollection>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Criptostory"),
            actions: [
              SizedBox(
                width: 200,
                child: SearchWidget(
                  onChanged: (p0) {
                    setState(() {
                    searchTerm = p0;
                    distribudeAssets(value.allAssets);
                  });
                  }, 
                hintText: "Search"
              ),
              ),
              
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const<Tab> [
                Tab(text: "Crypto"),
                Tab(text: "Fiat"),
              ],
            ),
          ),
          body: FutureBuilder(
            future: _assetsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                distribudeAssets(value.allAssets);
                return TabBarView(
                  controller: _tabController,
                  children: [
                    InfiniteList(
                      items: cryptos,
                      cantidadDeCarga: 20,
                    ),
                    InfiniteList(
                      items: notCryptos,
                      cantidadDeCarga: 20,
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("ERROR"),
                );
              }
            },
          )
        );
      },
    )
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
