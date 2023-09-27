import 'dart:convert';
import 'package:flutter/material.dart';

class Asset {
  final String assetId;
  final String name;
  String iconUrl;
  final int isCrypto;
  final String dataQuoteStart;
  final String dataQuoteEnd;
  final String dataOrderbookStart;
  final String dataOrderbookEnd;
  final String dataTradeStart;
  final String dataTradeEnd;
  final int dataSymbolsCount;
  final double volume1hrsUsd;
  final double volume1dayUsd;
  final double volume1mthUsd;
  final String idIcon;
  final String dataStart;
  final String dataEnd;

  Asset({
    required this.assetId,
    required this.name,
    required this.iconUrl,
    required this.isCrypto,
    required this.dataQuoteStart,
    required this.dataQuoteEnd,
    required this.dataOrderbookStart,
    required this.dataOrderbookEnd,
    required this.dataTradeStart,
    required this.dataTradeEnd,
    required this.dataSymbolsCount,
    required this.volume1hrsUsd,
    required this.volume1dayUsd,
    required this.volume1mthUsd,
    required this.idIcon,
    required this.dataStart,
    required this.dataEnd,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetId: json["asset_id"],
      name: json["name"] ?? "undefined",
      iconUrl: "",
      isCrypto: json["type_is_crypto"] ?? 0,
      dataQuoteStart: json["data_quote_start"] ?? "",
      dataQuoteEnd: json["data_quote_end"] ?? "",
      dataOrderbookStart: json["data_orderbook_start"]?? "",
      dataOrderbookEnd: json["data_orderbook_end"] ?? "",
      dataTradeStart: json["data_trade_start"] ?? "",
      dataTradeEnd: json["data_trade_end"]?? "",
      dataSymbolsCount: json["data_symbols_count"] ?? 0,
      volume1hrsUsd: json["volume_1hrs_usd"].toDouble() ?? 0.0,
      volume1dayUsd: json["volume_1day_usd"].toDouble() ?? 0.0,
      volume1mthUsd: json["volume_1mth_usd"].toDouble() ?? 0.0,
      idIcon: json["id_icon"] ?? "",
      dataStart: json["data_start"] ?? "",
      dataEnd: json["data_end"] ?? "",
    );
  }
}

class AssetCollection extends ChangeNotifier{
  List<Asset> _allAssets = [];
  List<Asset> get allAssets => _allAssets;

  void updateListOfAssets(String assetsjson, String iconsjson){
    _allAssets = [];
    List<dynamic> decodedAssets = jsonDecode(assetsjson);
    List<dynamic> decodedIcons = jsonDecode(iconsjson);
    for(var a in decodedAssets){
      var asset = Asset.fromJson(a);
      String iconUrl = decodedIcons.firstWhere((element) => element["asset_id"] == asset.assetId, orElse: () => {"url":""})["url"];
      asset.iconUrl = iconUrl;
      _allAssets.add(asset);
    }
    notifyListeners();
  }
}

class SelectedAsset extends ChangeNotifier{
  Asset? _selectedAsset;
  Asset? get selectedAsset => _selectedAsset;

  void setSelectedAsset(Asset asset) {
    _selectedAsset = asset;
    notifyListeners();
  }
}

class SelectedCurrency extends ChangeNotifier{
  Asset? _selectedCurrency;
  Asset? get selectedCurrency => _selectedCurrency;

  void setSelectedCurrency(Asset currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }
}
