import 'package:flutter/material.dart';

class AppListItem extends StatelessWidget {
  const AppListItem({

    Key key,
    @required this.displayName, this.item,
  }) : super(key: key);

  final String displayName;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ExcludeSemantics(
        child: CircleAvatar(
          radius: 25.0,
          backgroundColor:
              Theme.of(context).colorScheme.onPrimary,
          child: Text(
            displayName.substring(0, 2).toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              // fontWeight:
              //     selectedIndex != null && selectedIndex == index
              //         ? FontWeight.bold
              //         : FontWeight.normal,
            ),
          ),
        ),
      ),
      title: Hero(
        tag: '${item?.id}__heroTag',
        child: Text(item[displayName].toUpperCase(),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item?.proviousDue == 0.0
              ? Container()
              : Text(
                  'Previous Due: ${item?.proviousDue}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                ),
          Text(
            '${item?.phoneNumber}',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: () {
        // if (isLargeScreen) {
        //   selectedValue = model.item?;
        //   setState(() {
        //     selectedIndex = index;
        //   });
        // } else {
        //   var arguments = {
        //     'client': item?,
        //     'clientModel': model,
        //   };
        //   Navigator.pushNamed(context, AppRoutes.client_detail,
        //       arguments: arguments);
        // }
      },
    );
  }
}
