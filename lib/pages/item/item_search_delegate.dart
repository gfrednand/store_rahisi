import 'package:flutter/material.dart';
import 'package:storeRahisi/constants/routes.dart';
import 'package:storeRahisi/models/item.dart';


class ItemSearchDelegate extends SearchDelegate<List<Item>> {
  final List<Item> history;
  List<Item> datas = [];

  ItemSearchDelegate(this.history);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, datas);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    datas = history != null ? history : new List<Item>();
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }
    return Container();

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Item> suggestionList = query.isEmpty && history == null
        ? history
        : history != null
            ? history.map((p) {
                if (p.name
                    .trim()
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  return p;
                }
                return null;
              }).toList()
            : null;

    return suggestionList != null
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              Item suggestion = suggestionList[index];
              return suggestion != null
                  ? ListTile(
                      onTap: () {
                        query = suggestion.name;
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.item_detail,
                            arguments: suggestion);
                      },
                      title: Text(
                        '${suggestion.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      // subtitle: Text(
                      //   '${suggestion.purchasePrice}',
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      trailing:
                          Text('${suggestion.inStock}${suggestion.unit}'),
                    )
                  : Container();
            },
          )
        : Container();
  }
}
