import 'package:cripstory/models/asset_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InfiniteList extends StatefulWidget {
  final List<Asset> items;
  final int cantidadDeCarga;

  const InfiniteList({super.key, required this.items, required this.cantidadDeCarga});

  @override
  State<InfiniteList> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  int _visibleItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return widget.items.isNotEmpty
        ? ListView.builder(
            itemCount: _visibleItemCount + 1,
            itemBuilder: (context, index) {
              if (index == _visibleItemCount) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _loadMoreItems();
                });
                return Container();
              }
              if (index < widget.items.length) {
                return Card(
                  child: ListTile(
                    leading: widget.items[index].iconUrl.isEmpty
                        ? const Icon(Icons.monetization_on)
                        : Image.network(widget.items[index].iconUrl, width: 18, height: 18,),
                    title: Text(widget.items[index].name),
                    onTap: () {
                      Provider.of<SelectedAsset>(context, listen: false).setSelectedAsset(widget.items[index]);
                      context.go("/details/:${widget.items[index].assetId}");
                    },
                  ),
                );
              }
              return null; // Evita crear un elemento nulo.
            },
          )
        : const Center(child: Text("Not found"));
  }

  void _loadMoreItems() {
    setState(() {
      _visibleItemCount += widget.cantidadDeCarga;
      if (_visibleItemCount > widget.items.length) {
        _visibleItemCount = widget.items.length;
      }
    });
  }
}


