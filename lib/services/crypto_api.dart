import 'dart:convert';
import 'package:cripstory/models/asset_model.dart';
import 'package:cripstory/models/exchange_rate_model.dart';
import 'package:cripstory/models/period_model.dart';
import 'package:cripstory/services/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String autorithy = 'rest.coinapi.io';



Future<void> getAllAssets(AssetCollection value) async {
  try{
    Uri url = Uri.https(autorithy,'/v1/assets');
    http.Response response = await http.get(
      url,
      headers: authorizer
    );
    if(response.statusCode == 200){
      value.updateListOfAssets(response.body);
    }else{
      debugPrint(response.statusCode.toString());
    }
  }
  catch(e){
    debugPrint(e.toString());
  }
}

Future<List<ExchangeRate>> getExchangeRate(String assetIdBase, String assetIdQuote) async {
  try{
    var url = Uri.https(autorithy,'/v1/exchangerate/$assetIdBase/$assetIdQuote/history',{"period_id":"1DAY"});
    http.Response response = await http.get(
      url,
      headers: authorizer
    );

    if(response.statusCode == 200){
      List<ExchangeRate> listExchangeRate = [];
      for(var n in jsonDecode(response.body)){
        listExchangeRate.add(ExchangeRate.fromJson(n));
      }
      return listExchangeRate;
    }else{
      throw("${response.statusCode}: ${jsonDecode(response.body)['error']}");
    }
  }catch(e){
    throw("$e");
  }
}

Future<List<CryptoPeriod>> getListCryptoPeriods() async {
  try{
    var url = Uri.https(autorithy,'/v1/ohlcv/periods');
    http.Response response = await http.get(
      url,
      headers: authorizer
    );

    if(response.statusCode == 200){
      List<CryptoPeriod> periods = [];
      for(var n in jsonDecode(response.body)){
        periods.add(CryptoPeriod.fromJson(n));
      }
      return periods;
    }else{
      debugPrint(response.statusCode.toString());
    }
  }catch(e){
    debugPrint(e.toString());
  }
  return [];
}