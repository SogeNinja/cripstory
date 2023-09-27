import 'package:cripstory/models/asset_model.dart';
import 'package:cripstory/models/exchange_rate_model.dart';
import 'package:cripstory/services/crypto_api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({ super.key, required this.assetId });

  final String assetId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, List<dynamic>> data = {};

  @override
  Widget build(BuildContext context) {
    List<Asset> fiat = context.watch<AssetCollection>().allAssets.where((element) => element.isCrypto == 0).toList();
    //Moneda principal 
    var selectedAsset = context.watch<SelectedAsset>().selectedAsset;
    fiat.removeWhere((element) => element.assetId == selectedAsset!.assetId);
    // Valor a transformar la moneda principal
    var selectedCurrency = context.watch<SelectedCurrency>().selectedCurrency ?? fiat[0];

    if(selectedCurrency.assetId == selectedAsset!.assetId){
      selectedCurrency = fiat[0];
      Provider.of<SelectedCurrency>(context, listen: false).setSelectedCurrency(selectedCurrency);
    }
    if (context.watch<SelectedCurrency>().selectedCurrency == null) {
      Provider.of<SelectedCurrency>(context, listen: false).setSelectedCurrency(selectedCurrency);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go("/"),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Cryptostory")
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Center( 
          child: Consumer<SelectedCurrency>(
            builder: (context, value, child) => FutureBuilder(
                future: getExchangeRate(selectedAsset.assetId, selectedCurrency.assetId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.isEmpty){
                    return const Text("The server does not have data related to these coins.");
                  } else{
                    List<ExchangeRate> exchangeRate = snapshot.data!;
                    data = {
                      "rateOpen" : exchangeRate.map((e) => e.rateLow).toList().reversed.toList(),
                      "rateClose" : exchangeRate.map((e) => e.rateClose).toList().reversed.toList(),
                      "rateHigh" : exchangeRate.map((e) => e.rateHigh).toList().reversed.toList(),
                      "dates": exchangeRate.map((e) {
                        return e.timePeriodStart.split('T')[0];
                      }).toList().reversed.toList()
                    };
                    return Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text(selectedAsset.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showDialogCurrency(context, fiat, selectedCurrency);
                                  },
                                  child: Text("Price in ${selectedCurrency.name} ${exchangeRate.first.rateOpen}", style: const TextStyle(fontSize: 16))
                                ),
                              ],
                            )
                          )
                        ),
                        const SizedBox(height: 5),
                        const Text("History price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
                        const SizedBox(height: 5),
                        lineChartWidget(data)
                      ]
                    );
                  }
                },
              ),
            ) 
          )
        )
      )
    );
  }

  Widget lineChartWidget(Map<String, List<dynamic>> data){
    bool isNotEmpty = data.isNotEmpty;
    List<FlSpot> rateCloseSpot = [];

    if(isNotEmpty) {
      double i = 0;
      for (var element in data["rateClose"]!) {// 1
        rateCloseSpot.add(FlSpot(i, element));
        i++;
      }
    }

    return isNotEmpty
    ? Card(
      child: Container(
        margin: const EdgeInsets.only(left:22, right: 5),
        padding: const EdgeInsets.only(top:30, right: 30),
        child: AspectRatio(
          aspectRatio: 1,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: rateCloseSpot,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true)
                ),
              ],
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1000,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(meta.formattedValue,
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  )
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: data["dates"]!.length / 2,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(data["dates"]![value.toInt()],
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  )
                )
              )
            )
          )
        )
      )
    )
    : Container();
  }
  
  void _showDialogCurrency(BuildContext context, List<Asset> fiat, Asset selectedCurrency) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a fiat currency"),
          content: SingleChildScrollView(
            child: Column(
              children: fiat.map((opcion) {
                return ListTile(
                  title: Text(opcion.name),
                  onTap: () {
                    if(selectedCurrency.assetId != opcion.assetId){
                      Provider.of<SelectedCurrency>(context, listen: false).setSelectedCurrency(opcion);
                    }
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  
}